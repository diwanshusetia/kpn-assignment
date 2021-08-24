/*
 * Class Name :kpn_AvailableProducts_Test
 * Purpose : Test class for kpn_AvailableProducts
 */
@isTest
public class kpn_AvailableProducts_Test {
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
        
        
    }
    /*
 	* Method Name :testAvailableProduct
	* param      :
 	* return : testmethod to test getAllProducts method
 	*/
    public static testMethod void testAvailableProduct(){
        
        Order odr =[Select id from Order];
        List<PricebookEntry> pbEntLst=kpn_AvailableProducts.getAllProducts(odr.Id);
        System.assert(pbEntLst.size()>0,'PricebookEntry List should not be null');
        
    } 
}