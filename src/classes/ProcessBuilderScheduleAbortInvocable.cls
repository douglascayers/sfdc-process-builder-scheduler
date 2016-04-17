public class ProcessBuilderScheduleAbortInvocable {

    @InvocableMethod( label = 'Abort Jobs' )
    public static void abortJobs( List<ID> processBuilderScheduleIds ) {
        
        List<Process_Builder_Schedule__c> records = new List<Process_Builder_Schedule__c>([
            SELECT
                id, name, process_api_name__c, cron_expression__c, job_name__c
            FROM
                Process_Builder_Schedule__c
            WHERE
                id IN :processBuilderScheduleIds
        ]);
        
        System.debug( 'Aborting process schedules: ' + records );
        
        if ( records.size() > 0 ) {
            
            Set<String> jobNames = new Set<String>();
            for ( Process_Builder_Schedule__c record : records ) {
                jobNames.add( record.job_name__c );
            }
            
            for ( List<CronTrigger> cronTriggers : [
				SELECT
                	id, state, cronJobDetail.name
               	FROM
                	CronTrigger
                WHERE
                	cronJobDetail.name IN :jobNames
            ]) {
                
                System.debug( 'CronTriggers to abort: ' + cronTriggers );
                
                for ( CronTrigger cronTrigger : cronTriggers ) {
                    
                    try {
                        
                        System.debug( 'Aborting job: ' + cronTrigger );
                        System.abortJob( cronTrigger.id );
                        
                    } catch ( Exception e ) {
                        
                        System.debug( LoggingLevel.ERROR, 'Error trying to abort job: ' + cronTrigger + ': ' + e.getStackTraceString() );
                        
                    }
                    
                }
                
            }

        }
        
    }
    
}