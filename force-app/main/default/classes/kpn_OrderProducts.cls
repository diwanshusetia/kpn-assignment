/*
 * Class Name :kpn_OrderProducts
 * Purpose : Reffered by LWC component kpn_OrderProducts
 */
public with sharing class kpn_OrderProducts {
     /*
 	* Method Name :getOrderedProducts
	* param      :Order Id
 	* return : Returns List of OrderItem
 	*/
    @AuraEnabled
    public static List<OrderItem> getOrderedProducts(String ordrId) {
        return [SELECT Id, UnitPrice,TotalPrice,PricebookEntryId,Quantity,OrderId,Order.Status,Product2Id,Product2.Name  FROM OrderItem WHERE OrderId =:ordrId];
    }
    /*
 	* Method Name :getAllProducts
	* param      :List of OrderItem,Order Id
 	* return : Returns current Order record after Status update and Inserting OrderItems
 	*/
    @AuraEnabled
    public static Order upsertOrderItems(List<OrderItem> updatedOrdrList,String ordrId) {
        upsert(updatedOrdrList);
        Order odr=[SELECT Id,Pricebook2.Name,Status FROM Order where id=:ordrId];
        odr.Status='Activated';
        update odr;
        return odr;
        
    }
}