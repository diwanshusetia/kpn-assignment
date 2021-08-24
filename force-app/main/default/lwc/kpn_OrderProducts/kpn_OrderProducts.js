import { LightningElement ,api, wire, track} from 'lwc';
import getOrderedProductsList from '@salesforce/apex/kpn_OrderProducts.getOrderedProducts';
import upsertOrderItemsMethod from '@salesforce/apex/kpn_OrderProducts.upsertOrderItems';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
export default class LightningDatatableLWCExample extends LightningElement {
    @track columns = [{
            label: 'Name',
            fieldName: 'productName',
            type: 'text',
            sortable: true
        },
        {
            label: 'Unit Price',
            fieldName: 'UnitPrice',
            type: 'text',
            sortable: true
        },
        {
            label: 'Quantity',
            fieldName: 'Quantity',
            type: 'text',
            sortable: true
        },
        {
            label: 'Total Price',
            fieldName: 'TotalPrice',
            type: 'text',
            sortable: true
        }
    ];
    @api recordId;
    @track error;
    @api prdList ;
    @track updatedOrdrList =[];
    @track buttonDisable=false;
    /*
 	* Method Name :connectedCallback
	* Purpose : connectedCallback method to get existing Order Items
 	*/
    connectedCallback() {
        getOrderedProductsList({ordrId: this.recordId})
        .then(result => {
            if(result.length>0){
                if(result[0].Order.Status=='Activated'){
                    this.buttonDisable = true;
                    //custom event
                }
                const passEvent = new CustomEvent('buttondisable', {
                        detail:this.buttonDisable
                    });
                this.dispatchEvent(passEvent);
                this.updatedOrdrList = result.map(
                record => Object.assign(
                { "productName": record.Product2.Name},record)
                );
            }
        })
        .catch(error => {
            this.error = error;
        });
    }
    /*
 	* Method Name :handleValueChange
	* Purpose : event method called from parent to get retrieve new Order Item selected
 	*/
    @api handleValueChange(val) {
      
       let isExist= false;
       let tempPrdList= this.updatedOrdrList;
       tempPrdList.forEach(element => {
            if(element.Product2Id == val.Product2Id )
            {   
                element.Quantity=element.Quantity+1;
                element.TotalPrice=element.TotalPrice+val.UnitPrice;  
                isExist = true;
            }
        });
        
        if(!isExist)
        {
            let recordVal = {
                apiName: 'OrderItem',
                productName: val.productName,
                Quantity: 1,
                TotalPrice: val.UnitPrice,
                UnitPrice: val.UnitPrice,
                UnitPrice: val.UnitPrice,
                Product2Id:val.Product2Id,
                OrderId:this.recordId,
                PricebookEntryId:val.Id
            
             }
            tempPrdList.push(recordVal);
        }
        this.updatedOrdrList =[...tempPrdList];
       }
      /*
 	  * Method Name :handleOrderItemData
	  * Purpose : Sorting of Data on DataTable 
 	  */
       handleOrderItemData(event) {       
            this.sortBy = event.detail.fieldName;       
            this.sortDirection = event.detail.sortDirection;       
            this.sortOrderItemData(event.detail.fieldName, event.detail.sortDirection);
       }
       /*
 	   * Method Name :sortOrderItemData
	   * Purpose : Method is getting called from sortOrderItemData to sort data 
 	   */
       sortOrderItemData(fieldname, direction) {
            let parseData = JSON.parse(JSON.stringify(this.updatedOrdrList));
            let keyValue = (a) => {
                return a[fieldname];
            };
            let isReverse = direction === 'asc' ? 1: -1;

            parseData.sort((x, y) => {
                x = keyValue(x) ? keyValue(x) : ''; 
                y = keyValue(y) ? keyValue(y) : '';
            
                return isReverse * ((x > y) - (y > x));
            });
            this.updatedOrdrList = parseData;
        }
        /*
 	   * Method Name :handleClick
	   * Purpose : Method is used to save/update selected Order Items and disable 
       * Activate button
 	   */
        handleClick(event){
             upsertOrderItemsMethod({'updatedOrdrList': this.updatedOrdrList,
            'ordrId': this.recordId})
            .then(result => {
                if(result.Status=='Activated'){
                    this.buttonDisable = true;
                    getRecordNotifyChange([{recordId: this.recordId}]);
                    const passEvent = new CustomEvent('buttondisable', {
                            detail:this.buttonDisable
                        });
                    this.dispatchEvent(passEvent);
                }
            })
            .catch(error => {
            // eslint-disable-next-line no-console
                console.log(error);
             });

        }
        
    
}