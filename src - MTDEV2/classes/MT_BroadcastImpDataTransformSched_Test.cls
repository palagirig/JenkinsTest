/**
 * Test the broadcast import data transformator scheduler
 */
@IsTest
public with sharing class MT_BroadcastImpDataTransformSched_Test {

  private static String CRON_EXP = '0 0 0 3 9 ? 2022';

  @IsTest
  public static void testExecute() {
    Test.startTest();

    System.assertEquals(0, [SELECT COUNT() FROM AsyncApexJob]);

    String jobId = System.schedule(
      'MT_BroadcastImpDataTransformScheduler_Test',
      CRON_EXP,
      new MT_BroadcastImpDataTransformScheduler()
    );

    CronTrigger ct = [
      SELECT Id, CronExpression, TimesTriggered,
        NextFireTime
      FROM CronTrigger
      WHERE id = :jobId
    ];

    // Verify the expressions are the same
    System.assertEquals(CRON_EXP, ct.CronExpression);

    // Verify the job has not run
    System.assertEquals(0, ct.TimesTriggered);

    // Verify the next time the job will run
    System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
    System.assertEquals(0, [SELECT COUNT() FROM MT_MediaBroadcastData__c]);

    // Now the batch will be scheduled, so we can test the job queue
    Test.stopTest();

    System.assertEquals(1, [SELECT COUNT() FROM AsyncApexJob WHERE JobType = 'BatchApex']);
  }
}