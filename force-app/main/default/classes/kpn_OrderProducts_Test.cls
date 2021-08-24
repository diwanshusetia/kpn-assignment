/*
 * Class Name :kpn_OrderProducts_Test
 * Purpose : Test class for kpn_OrderProducts
 */
@isTest
public class kpn_OrderProducts_Test {
     
    /*
 	* Method Name :setup
	* param      :
 	* return : test data setup method
 	*/
     @testSetup static void setup() {
        // Test data setup
        // Insert Account
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        // Insert Contract
        Contract ct = new Contract();
        ct.AccountId = acc.Id;
        ct.Status = 'Draft';
        ct.StartDate = Date.Today();
        ct.ContractTerm = 12;
        insert ct;
    	
        //Activate Contract
        ct.Status='Activated';
        update ct;
        
        // Insert Product
        Product2 p = new Product2();
        p.Name = ' Test Product ';
        p.Description='Test Product Entry 1';
        p.productCode = 'ABC';
        p.isActive = true;
        insert p;
        
    
        Id pricebookId = Test.getStandardPricebookId();
        system.debug('pricebookId---->'+pricebookId);
        
        // Insert PricebookEntry
    
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = p.Id;
        standardPrice.UnitPrice = 1;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        
        // Insert Order
        
        Order odr = new Order();
        odr.Name = 'Test Order ';
        odr.Status = 'Draft';
        odr.EffectiveDate = system.today();
        odr.EndDate = system.today() + 4;
        odr.AccountId = acc.id;
        odr.ContractId = ct.Id;
        odr.Pricebook2Id =  pricebookId ;
        
        insert odr;
        
        // Insert Order Item
    	
        OrderItem odrItm = new OrderItem();
        odrItm.OrderId = odr.id;
        odrItm.Quantity = 24;
        odrItm.UnitPrice = 240;
        odrItm.Product2id = p.id;
        odrItm.PricebookEntryId=standardPrice.id;
        insert odrItm;
        
        
    }
     /*
 	* Method Name :testOrderProductMethod1
	* param      :
 	* return : testmethod to test getOrderedProducts method
 	*/
    public static testMethod void testOrderProductMethod1(){
        
        Order odr =[Select id from Order];
        List<OrderItem> ordrItemLst=kpn_OrderProducts.getOrderedProducts(odr.Id);
        System.assert(ordrItemLst.size()>0,'OrderItem List should not be null');
        
       
	} 
     /*
 	* Method Name :testOrderProductMethod2
	* param      :
 	* return : testmethod to test upsertOrderItems method
 	*/
    public static testMethod void testOrderProductMethod2(){
        
		List<OrderItem> ordrItemLst=[SELECT Id, UnitPrice, Quantity, OrderId,Order.Status,Product2Id,Product2.Name  FROM OrderItem];
        Order odr =[Select id from Order];
        
        Order odrRec=kpn_OrderProducts.upsertOrderItems(ordrItemLst,odr.Id);
        System.assert(odrRec.id!=null,'Order id should not be null');
	} 
}