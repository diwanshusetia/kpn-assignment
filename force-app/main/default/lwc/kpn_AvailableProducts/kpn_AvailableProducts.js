import { LightningElement ,api, wire, track} from 'lwc';
import getProductList from '@salesforce/apex/kpn_AvailableProducts.getAllProducts';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
export default class LightningDatatableLWCExample extends LightningElement {
    @api recordId;
    @track sortBy;
    @track sortDirection;
    @track error;
    @api prdList ;
    @api buttonDisable=false;
    @track columns = [{
            label: 'Name',
            fieldName: 'productName',
            type: 'text',
            sortable: true
        },
        {
            label: 'List Price',
            fieldName: 'UnitPrice',
            type: 'text',
            sortable: true
        },
        {
            type:  'button',
            label: 'Add To Cart',
            typeAttributes: 
            {
              iconName: 'action:new',
              name: 'AddRecord', 
              title: 'AddRecord', 
              disabled: {fieldName:'buttonCheck'}, 
              value: 'test'
            }
          }
    ];
    /*
 	* Method Name :handleSortPrdData
	* Purpose : Sorting of Data on DataTable
 	*/
    handleSortPrdData(event) {       
        this.sortBy = event.detail.fieldName;       
        this.sortDirection = event.detail.sortDirection;       
        this.sortPrdData(event.detail.fieldName, event.detail.sortDirection);
    }
    /*
 	* Method Name :sortPrdData
	* Purpose : Method is getting called from handleSortPrdData to sort data 
 	*/
    sortPrdData(fieldname, direction) {
        
        let parseData = JSON.parse(JSON.stringify(this.prdList));
       
        let keyValue = (a) => {
            return a[fieldname];
        };

       let isReverse = direction === 'asc' ? 1: -1;

           parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; 
            y = keyValue(y) ? keyValue(y) : '';
           
            return isReverse * ((x > y) - (y > x));
        });
        
        this.prdList = parseData;

    }
    /*
 	* Method Name :handleRowAction
	* Purpose : On Click of Plus button of any row pass data to child component
 	*/
    handleRowAction(event) {
        this.row = event.detail.row;
        this.template.querySelector("c-kpn_-order-products").handleValueChange(this.row);
        
    }
    /*
 	* Method Name :handlebuttondisable
	* Purpose : Event method fired from child to disable plus button if 
                Status is already activated
 	*/
    handlebuttondisable(event){
        this.buttonDisable = event.detail;
        this.getProductListData();
    }
    /*
 	* Method Name :getProductListData
	* Purpose : method getting called from handlebuttondisable to load table data.
 	*/
    getProductListData(){
        getProductList({ordrId: this.recordId})
            .then(result => {
                this.prdList =  result.map(
                    record => Object.assign(
                    { "productName": record.Product2.Name,
                       "buttonCheck":this.buttonDisable},record)
                    );
            })
            .catch(error => {
                this.error = error;
            });
    }

}