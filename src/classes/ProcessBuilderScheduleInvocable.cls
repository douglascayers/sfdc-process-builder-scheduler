public class ProcessBuilderScheduleInvocable {

    @InvocableMethod( label = 'Schedule Jobs' )
    public static List<String> scheduleJobs( List<ID> processBuilderScheduleIds ) {

        List<Process_Builder_Schedule__c> records = new List<Process_Builder_Schedule__c>([
            SELECT
                id, name, process_api_name__c, cron_expression__c, job_name__c
            FROM
                Process_Builder_Schedule__c
            WHERE
                id IN :processBuilderScheduleIds
                AND
                active__c = true
        ]);
        
        System.debug( 'Scheduling processes: ' + records );

        List<String> jobIds = new List<String>();

        if ( records.size() > 0 ) {

            // before schedule the job, look to see
            // if the job has already been scheduled
            
            Set<String> jobNames = new Set<String>();
            for ( Process_Builder_Schedule__c record : records ) {
                jobNames.add( record.job_name__c );
            }
            
            Set<String> cronJobNames = new Set<String>();
            for ( CronTrigger cronTrigger : [
				SELECT
                	id, state, cronJobDetail.name
               	FROM
                	CronTrigger
                WHERE
                	cronJobDetail.name IN :jobNames
            ]) {
                cronJobNames.add( cronTrigger.cronJobDetail.name );
            }
            
            for ( Process_Builder_Schedule__c record : records ) {

                // if job has not already been scheduled then schedule it
                if ( !cronJobNames.contains( record.job_name__c ) ) {
                
                    System.debug( 'Scheduling job: ' + record );
                    
                    String jobId = System.schedule(
                        record.job_name__c,
                        record.cron_expression__c,
                        new ProcessBuilderScheduleJob( record.id )
                    );
    
                    jobIds.add( jobId );
                    
                } else {
                    
                    System.debug( LoggingLevel.WARN, 'Job has already been scheduled: ' + record.job_name__c );
                    
                }

            }

        }

        return jobIds;
    }
    
}