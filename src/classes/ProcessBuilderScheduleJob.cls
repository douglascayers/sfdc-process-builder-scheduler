/**
 * Inspired by Marie Chandra's idea, "Ability to schedule when process builder triggers"
 * https://success.salesforce.com/ideaView?id=08730000000DjEmAAK
 * 
 * Developed by Doug Ayers
 * https://github.com/DouglasCAyers/sfdc-process-builder-scheduler
 * 
 * Purpose is to periodically update the Process Builder Schedule record
 * associated with this job instance. The update simply increments the times
 * triggered counter for no other reason than to cause Process Builder to
 * run on this record.
 * 
 * When Process Builder runs on this record that is when the user-created
 * process does whatever arbitrary actions they wanted run on this schedule.
 * They could create records, invoke flow, post to chatter, send emails...
 * 
 * When this scheduled job runs, it only updates the related record
 * if the record is still active and exists, otherwise the job is aborted.
 */
public class ProcessBuilderScheduleJob implements Schedulable {

    // id of the process builder schedule record that controls this job
    private ID recordId { get; set; }

    public ProcessBuilderScheduleJob( ID recordId ) {
        this.recordId = recordId;
    }

    public void execute( SchedulableContext context ) {

        Boolean abortJob = false;

        List<Process_Builder_Schedule__c> records = new List<Process_Builder_Schedule__c>([
            SELECT
                id, name, process_api_name__c, active__c, times_triggered__c
            FROM
                Process_Builder_Schedule__c
            WHERE
                id = :this.recordId
            LIMIT 1
        ]);

        if ( records.size() > 0 ) {

            Process_Builder_Schedule__c record = records[0];

            if ( record.active__c ) {

                System.debug( 'Updating record to fire process builder: ' + record );

                record.times_triggered__c++;

                update record;

            } else {

                System.debug( 'Record is inactive: ' + record );

                abortJob = true;

            }

        } else {

            System.debug( 'No record found by id: ' + this.recordId );

            abortJob = true;

        }

        if ( abortJob ) {

            System.debug( 'Aborting job: recordId=' + this.recordId + ', jobId=' + context.getTriggerId() );

            System.abortJob( context.getTriggerId() );

        }

    }

}