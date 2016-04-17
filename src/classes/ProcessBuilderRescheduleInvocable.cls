public class ProcessBuilderRescheduleInvocable {

    @InvocableMethod( label = 'Reschedule Jobs' )
    public static List<String> rescheduleJobs( List<ID> processBuilderScheduleIds ) {

        System.debug( 'Rescheduling jobs: ' + processBuilderScheduleIds );
        
        ProcessBuilderScheduleAbortInvocable.abortJobs( processBuilderScheduleIds );

        List<String> jobIds = ProcessBuilderScheduleInvocable.scheduleJobs( processBuilderScheduleIds );
        
        System.debug( 'Rescheduled job ids: ' + jobIds );
        
        return jobIds;
    }
    
}