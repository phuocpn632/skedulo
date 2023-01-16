import { LightningElement, wire, track, api } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from "lightning/navigation";
import toDoListRepo from '@salesforce/apex/ToDoRepository.getToDoList';

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const columns = [
    // { label: 'ID', fieldName: 'Id'},
    { label: 'To Do Record Name', fieldName: 'Link', type: 'url',
        typeAttributes: { label: { fieldName: "Name" }, tooltip:"Name", target: "_blank" } 
    },
    { label: 'Contact', fieldName: 'Contact__c'},
    { label: 'Actions', fieldName: 'Actions__c'},    
    { 
      label: 'Created Date',
      fieldName: 'CreatedDate',
      sortable: true,
      type: "date",
        typeAttributes:{            
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit"
        }
    },
    { label: 'Status', fieldName: 'Status__c'},
    {
        type: 'action',
        typeAttributes: { rowActions: actions }
    }
];

export default class ToDoList extends NavigationMixin(LightningElement) {    
    columns = columns;    
    @track error;
    @track toDoList =  [];
    wiredActivities;

    // Sortable
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    @wire(toDoListRepo)    
    getToDoList(value){
        // Hold on to the provisioned value so we can refresh it later.
        this.wiredActivities = value;
        // Destructure the provisioned value 
        const { data, error } = value;

        if(data) {
            var tempToDoList = [];
            for (var i = 0; i < data.length; i++) {
                let tempToDoRecord = Object.assign({}, data[i]);
                tempToDoRecord.Link = '/' + tempToDoRecord.Id;
                tempToDoList.push(tempToDoRecord);
            }
            this.toDoList = tempToDoList;
            this.error = undefined;
        } else if (error) {  
            this.error = error;  
            this.toDoList = undefined;
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch(actionName) {
            case 'delete':
                this.deleteRow(row);
                break;
            case 'edit':
                this.editRow(row);
                break;
            default:
        }
    }

    deleteRow(row) {
        deleteRecord(row.Id)
        .then(() => {
            return refreshApex(this.wiredActivities);
        })
        .catch(error => {
        });
    }

    editRow(row) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id, // pass the record id here.
                objectApiName: 'To_Do__c',
                actionName: 'edit'
            },
        });
    }

    createRow() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'To_Do__c',
                actionName: 'new'
            },
        });
    }

    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.toDoList];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.toDoList = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }
}