/*
 * Class Name :kpn_AvailableProducts
 * Purpose : Reffered by LWC component kpn_AvailableProducts
 */
public with sharing class kpn_AvailableProducts {
    /*
 	* Method Name :getAllProducts
	* param      :Order Id
 	* return : Returns List of PricebookEntry
 	*/
   @AuraEnabled(Cacheable=true)
    public static List<PricebookEntry> getAllProducts(String ordrId) {
        Set<Id> prdIds=new Set<Id>();
        List<PricebookEntry> priceBookLst=new List<PricebookEntry>();
        List<PricebookEntry> updatedPriceBookLst=new List<PricebookEntry>();
        Order odr=[SELECT Id,Pricebook2.Name,Pricebook2Id FROM Order where id=:ordrId];
        for(OrderItem ordItm :[SELECT Id, UnitPrice, Quantity, OrderId,Order.Status,Product2Id,Product2.Name  FROM OrderItem WHERE OrderId =:ordrId ]){
            prdIds.add(ordItm.Product2Id);
        }
        priceBookLst=[SELECT Id, Product2Id,PriceBook2Id, Product2.Name,UnitPrice FROM PricebookEntry where PriceBook2Id =:odr.Pricebook2Id];
        for(PricebookEntry prBkEnt :priceBookLst){
            if(prdIds.contains(prBkEnt.Product2Id)){
                updatedPriceBookLst.add(0,prBkEnt);
            }else{
                updatedPriceBookLst.add(prBkEnt);
            }
        }
        return updatedPriceBookLst;
    }
   
    
}