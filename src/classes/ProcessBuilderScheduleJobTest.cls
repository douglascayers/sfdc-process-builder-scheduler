@isTest
private class ProcessBuilderScheduleJobTest {

    @isTest
    static void test_active() {
        
        Test.startTest();
        
        Process_Builder_Schedule__c record = new Process_Builder_Schedule__c(
            process_api_name__c = 'MyProcess',
            cron_expression__c = '0 0 * * * ?',
            active__c = true
        );
        
        insert record;
        
        Test.stopTest();
        
    }
    
    @isTest
    static void test_inactive() {

		Test.startTest();
        
        Process_Builder_Schedule__c record = new Process_Builder_Schedule__c(
            process_api_name__c = 'MyProcess',
            cron_expression__c = '0 0 * * * ?',
            active__c = true
        );
        
        insert record;
        
        record.active__c = false;
        
        update record;
        
        Test.stopTest();
        
    }
    
    @isTest
    static void test_reschedule() {

		Test.startTest();
        
        Process_Builder_Schedule__c record = new Process_Builder_Schedule__c(
            process_api_name__c = 'MyProcess',
            cron_expression__c = '0 0 * * * ?',
            active__c = true
        );
        
        insert record;
        
        record.cron_expression__c = '0 1 * * * ?';
        
        update record;
        
        Test.stopTest();
        
    }
    
    @isTest
    static void test_delete() {
        
		Test.startTest();
        
        Process_Builder_Schedule__c record = new Process_Builder_Schedule__c(
            process_api_name__c = 'MyProcess',
            cron_expression__c = '0 0 * * * ?',
            active__c = true
        );
        
        insert record;
        
        delete record;
        
        Test.stopTest();
        
    }
    
}