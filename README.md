Process Builder Scheduler
=========================

Provides a declarative way to schedule process builder to run at arbitrary times.

Inspired by **Marie Chandra's** idea [Ability to schedule when process builder triggers](https://success.salesforce.com/ideaView?id=08730000000DjEmAAK).

Installation
------------
You can easily install these components to your org as an unmanaged package.
* [Production URL](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tj0000001ejTg)
* [Sandbox URL](https://test.salesforce.com/packaging/installPackage.apexp?p0=04tj0000001ejTg)

Usage
-----
The package comes with one process that monitors the custom object `Process Builder Schedule` to automatically schedule, unschedule, or reschedule jobs to run your processes.

A second process, `Auto Post to Chatter`, is also included as an example of how you can arbitrarily schedule when Chatter posts are made.
Of course you are not limited to Chatter posts, you can schedule a process to create new records, send emails, invoke flows, etc.

Just note that the object and record context the scheduled process runs under is the custom object `Process Builder Schedule`. If you need to schedule specific actions for Account, Contact, etc. record changes then use Process Builder's built-in [Scheduled Actions](https://developer.salesforce.com/trailhead/en/business_process_automation/process_builder).

Cron Expressions
----------------
In this early version, processes are scheduled by specifying a cron expression. In future releases, I hope to provide a more natural UI for choosing the minute/hour/day/etc. for the schedule.
In the meantime, please see the [Apex Scheduler](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_scheduler.htm) docs for proper syntax.

| Expression | Description |
| ---------- | ----------- |
| 0 0 13 * * ? | Process runs every day at 1 PM. |
| 0 0 22 ? * 6L | Process runs the last Friday of every month at 10 PM. |
| 0 0 10 ? * MON-FRI | Process runs Monday through Friday at 10 AM. |
| 0 0 20 * * ? 2010 | Process runs every day at 8 PM during the year 2010. |