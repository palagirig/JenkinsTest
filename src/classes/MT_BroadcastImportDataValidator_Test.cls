/**
 * Unit test for MT_BroadcastImportDataValidator class.
 */
@IsTest
private class MT_BroadcastImportDataValidator_Test {

  @IsTest
  public static void testConstructorEmptyControl() {
    try {
      new MT_BroadcastImportDataValidator(null);
      System.assertEquals(true, false, 'Missing exception on provided but empty control record');
    } catch (MT_BroadcastImportDataValidator.MT_BroadcastImportDataValidatorException ex) {}
  }


  @IsTest
  public static void testStart() {
    MT_BroadcastImportDataValidator validator = new MT_BroadcastImportDataValidator(createControlRecord());

    Test.startTest();
    Database.QueryLocator ql = validator.start(null);
    Test.stopTest();

    String query = ql.getQuery();
    System.assertEquals(true, query.contains('FROM ' + MT_MediaBroadcastImportData__c.sObjectType.getDescribe().getName()), 'Query runs on wrong table');
    System.assertEquals(true, query.contains(MT_MediaBroadcastImportData__c.MT_MB1__c.getDescribe().getName()), 'Query is missing required column');
    System.assertEquals(true, query.contains(MT_MediaBroadcastImportData__c.MT_MB3__c.getDescribe().getName()), 'Query is missing required column');
    System.assertEquals(true, query.contains(MT_MediaBroadcastImportData__c.MT_MN3__c.getDescribe().getName()), 'Query is missing required column');
  }


  @IsTest
  public static void testExecuteSuccessful() {
    final Decimal mb1TestValue = 123456.789;
    final Decimal mb3TestValue = 9876.54321;
    final Decimal mn3TestValue = 101010.10101;
    final Integer recordCount = 200;

    List<MT_MediaBroadcastImportData__c> data = new List<MT_MediaBroadcastImportData__c>();
    for (Integer i = 0; i < recordCount; i++) {
      data.add(new MT_MediaBroadcastImportData__c(
        MT_MB1__c = mb1TestValue,
        MT_MB3__c = mb3TestValue,
        MT_MN3__c = mn3TestValue
      ));
    }

    MT_BroadcastImportDataValidator validator = new MT_BroadcastImportDataValidator(createControlRecord());

    Test.startTest();
    validator.execute(null, data);
    Test.stopTest();

    System.assertEquals(recordCount, validator.recordCount, 'Counted wrong number of records.');
    System.assertEquals(recordCount * mb1TestValue, validator.mb1Sum, 'Wrong sum for MB1');
    System.assertEquals(recordCount * mb3TestValue, validator.mb3Sum, 'Wrong sum for MB3');
    System.assertEquals(recordCount * mn3TestValue, validator.mn3Sum, 'Wrong sum for MN3');
  }


  @IsTest
  public static void testExecuteError() {
    List<MT_MediaBroadcastImportData__c> data = new List<MT_MediaBroadcastImportData__c>{
      null,
      new MT_MediaBroadcastImportData__c()
    };

    MT_BroadcastImportDataValidator validator = new MT_BroadcastImportDataValidator(createControlRecord());

    try {
      validator.execute(null, data);
      System.assertEquals(true, false, 'Did not throw an exception when executing on invalid scope.');
    } catch (NullPointerException ex) {
      final Integer countBefore = validator.recordCount;
      validator.execute(null, new List<MT_MediaBroadcastImportData__c>{
          new MT_MediaBroadcastImportData__c()
        });
      System.assertEquals(countBefore, validator.recordCount, 'Did not stop to count after an error occurred!');
      return;
    }
    System.assertEquals(true, false, 'Did not throw the expected exception when executing on invalid scope.');
  }


  @IsTest
  public static void testFinishWithError() {
    List<AsyncApexJob> jobs = [SELECT Id
                                 FROM AsyncApexJob
                                WHERE JobType = 'BatchApex'
                                  AND Status IN ('Holding', 'Queued')
                                  AND ApexClass.NamespacePrefix = null
                                  AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];

    MT_BroadcastImportDataValidator validator = new MT_BroadcastImportDataValidator(createControlRecord());
    validator.errorOccurred = true;
    validator.caughtException = new MT_BroadcastImportDataValidator.MT_BroadcastImportDataValidatorException('test exception');

    Test.startTest();
    validator.finish(null);
    Test.stopTest();

    // FIXME assert that error email is sent out
    // FIXME assert that error email is correct
    List<AsyncApexJob> jobsAfter = [SELECT Id
                                      FROM AsyncApexJob
                                     WHERE JobType = 'BatchApex'
                                       AND Status IN ('Holding', 'Queued')
                                       AND ApexClass.NamespacePrefix = null
                                       AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];
    System.assert(jobs.size() == jobsAfter.size(), 'Transformator batch job has been called although an error occurred!');
  }


  @IsTest
  public static void testFinishWithCountMismatch() {
    List<AsyncApexJob> jobs = [SELECT Id
                                 FROM AsyncApexJob
                                WHERE JobType = 'BatchApex'
                                  AND Status IN ('Holding', 'Queued')
                                  AND ApexClass.NamespacePrefix = null
                                  AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];

    MT_MediaBroadcastImportControlData__c ctrlRec = createControlRecord(21, 0, 0, 0);
    MT_BroadcastImportDataValidator validator = new MT_BroadcastImportDataValidator(ctrlRec);

    validator.recordCount = 17;

    Test.startTest();
    validator.finish(null);
    Test.stopTest();


    // FIXME assert that email is sent out
    // FIXME assert that email is correct
    List<AsyncApexJob> jobsAfter = [SELECT Id
                                      FROM AsyncApexJob
                                     WHERE JobType = 'BatchApex'
                                       AND Status IN ('Holding', 'Queued')
                                       AND ApexClass.NamespacePrefix = null
                                       AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];
    System.assert(jobs.size() == jobsAfter.size(), 'Transformator batch job has been called although an error occurred!');
  }


  @IsTest
  public static void testFinishWithMB1SumMismatch() {
    List<AsyncApexJob> jobs = [SELECT Id
                                 FROM AsyncApexJob
                                WHERE JobType = 'BatchApex'
                                  AND Status IN ('Holding', 'Queued')
                                  AND ApexClass.NamespacePrefix = null
                                  AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];

    MT_MediaBroadcastImportControlData__c ctrlRec = createControlRecord(0, 9876.543, 0, 0);
    MT_BroadcastImportDataValidator validator = new MT_BroadcastImportDataValidator(ctrlRec);

    validator.mb1Sum = 12345.678;

    Test.startTest();
    validator.finish(null);
    Test.stopTest();


    // FIXME assert that email is sent out
    // FIXME assert that email is correct
    List<AsyncApexJob> jobsAfter = [SELECT Id
                                      FROM AsyncApexJob
                                     WHERE JobType = 'BatchApex'
                                       AND Status IN ('Holding', 'Queued')
                                       AND ApexClass.NamespacePrefix = null
                                       AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];
    System.assert(jobs.size() == jobsAfter.size(), 'Transformator batch job has been called although an error occurred!');
  }


  @IsTest
  public static void testFinishWithMB3SumMismatch() {
    List<AsyncApexJob> jobs = [SELECT Id
                                 FROM AsyncApexJob
                                WHERE JobType = 'BatchApex'
                                  AND Status IN ('Holding', 'Queued')
                                  AND ApexClass.NamespacePrefix = null
                                  AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];

    MT_MediaBroadcastImportControlData__c ctrlRec = createControlRecord(0, 0, 9876.543, 0);
    MT_BroadcastImportDataValidator validator = new MT_BroadcastImportDataValidator(ctrlRec);

    validator.mb3Sum = 12345.678;

    Test.startTest();
    validator.finish(null);
    Test.stopTest();


    // FIXME assert that email is sent out
    // FIXME assert that email is correct
    List<AsyncApexJob> jobsAfter = [SELECT Id
                                      FROM AsyncApexJob
                                     WHERE JobType = 'BatchApex'
                                       AND Status IN ('Holding', 'Queued')
                                       AND ApexClass.NamespacePrefix = null
                                       AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];
    System.assert(jobs.size() == jobsAfter.size(), 'Transformator batch job has been called although an error occurred!');
  }


  @IsTest
  public static void testFinishWithMN3Mismatch() {
    List<AsyncApexJob> jobs = [SELECT Id
                                 FROM AsyncApexJob
                                WHERE JobType = 'BatchApex'
                                  AND Status IN ('Holding', 'Queued')
                                  AND ApexClass.NamespacePrefix = null
                                  AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];

    MT_MediaBroadcastImportControlData__c ctrlRec = createControlRecord(0, 0, 0, 9876.543);
    MT_BroadcastImportDataValidator validator = new MT_BroadcastImportDataValidator(ctrlRec);

    validator.mn3Sum = 12345.678;

    validator.finish(null);


    // FIXME assert that email is sent out
    // FIXME assert that email is correct
    List<AsyncApexJob> jobsAfter = [SELECT Id
                                      FROM AsyncApexJob
                                     WHERE JobType = 'BatchApex'
                                       AND Status IN ('Holding', 'Queued')
                                       AND ApexClass.NamespacePrefix = null
                                       AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];
    System.assert(jobs.size() == jobsAfter.size(), 'Transformator batch job has been called although an error occurred!');
  }


  @IsTest
  public static void testFinishWithRoundingUp() {
    List<AsyncApexJob> jobs = [SELECT Id
                                 FROM AsyncApexJob
                                WHERE JobType = 'BatchApex'
                                  AND Status IN ('Holding', 'Queued')
                                  AND ApexClass.NamespacePrefix = null
                                  AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];

    final String numbers = '0.5555555555555555555555555555555555555555555555555';

    final Integer mb1Scale = MT_MediaBroadcastImportData__c.MT_MB1__c.getDescribe().getScale();
    final Integer mb3Scale = MT_MediaBroadcastImportData__c.MT_MB3__c.getDescribe().getScale();
    final Integer mn3Scale = MT_MediaBroadcastImportData__c.MT_MN3__c.getDescribe().getScale();
    final Integer mb1SumScale = MT_MediaBroadcastImportControlData__c.MT_SumMB1__c.getDescribe().getScale();
    final Integer mb3SumScale = MT_MediaBroadcastImportControlData__c.MT_SumMB3__c.getDescribe().getScale();
    final Integer mn3SumScale = MT_MediaBroadcastImportControlData__c.MT_SumMN3__c.getDescribe().getScale();

    MT_MediaBroadcastImportControlData__c ctrlRec = createControlRecord(0,
        Decimal.valueOf(numbers.left(2 + mb1Scale)).setScale(mb1SumScale, System.RoundingMode.HALF_UP),
        Decimal.valueOf(numbers.left(2 + mb3Scale)).setScale(mb3SumScale, System.RoundingMode.HALF_UP),
        Decimal.valueOf(numbers.left(2 + mn3Scale)).setScale(mn3SumScale, System.RoundingMode.HALF_UP));
    MT_BroadcastImportDataValidator validator = new MT_BroadcastImportDataValidator(ctrlRec);

    validator.mb1Sum = Decimal.valueOf(numbers.left(2 + mb1Scale));
    validator.mb3Sum = Decimal.valueOf(numbers.left(2 + mb3Scale));
    validator.mn3Sum = Decimal.valueOf(numbers.left(2 + mn3Scale));

    validator.finish(null);

    // FIXME assert that no email is sent out
    List<AsyncApexJob> jobsAfter = [SELECT Id
                                      FROM AsyncApexJob
                                     WHERE JobType = 'BatchApex'
                                       AND Status IN ('Holding', 'Queued')
                                       AND ApexClass.NamespacePrefix = null
                                       AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];
    System.assert((jobs.size() + 1) == jobsAfter.size(), 'Transformator batch job has not been called although no error occurred!');
  }


  @IsTest
  public static void testFinishWithRoundingDown() {
    List<AsyncApexJob> jobs = [SELECT Id
                                 FROM AsyncApexJob
                                WHERE JobType = 'BatchApex'
                                  AND Status IN ('Holding', 'Queued')
                                  AND ApexClass.NamespacePrefix = null
                                  AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];

    final String numbers = '0.44444444444444444444444444444444444444444444';

    final Integer mb1Scale = MT_MediaBroadcastImportData__c.MT_MB1__c.getDescribe().getScale();
    final Integer mb3Scale = MT_MediaBroadcastImportData__c.MT_MB3__c.getDescribe().getScale();
    final Integer mn3Scale = MT_MediaBroadcastImportData__c.MT_MN3__c.getDescribe().getScale();
    final Integer mb1SumScale = MT_MediaBroadcastImportControlData__c.MT_SumMB1__c.getDescribe().getScale();
    final Integer mb3SumScale = MT_MediaBroadcastImportControlData__c.MT_SumMB3__c.getDescribe().getScale();
    final Integer mn3SumScale = MT_MediaBroadcastImportControlData__c.MT_SumMN3__c.getDescribe().getScale();

    MT_MediaBroadcastImportControlData__c ctrlRec = createControlRecord(0,
        Decimal.valueOf(numbers.left(2 + mb1Scale)).setScale(mb1SumScale, System.RoundingMode.HALF_UP),
        Decimal.valueOf(numbers.left(2 + mb3Scale)).setScale(mb3SumScale, System.RoundingMode.HALF_UP),
        Decimal.valueOf(numbers.left(2 + mn3Scale)).setScale(mn3SumScale, System.RoundingMode.HALF_UP));
    MT_BroadcastImportDataValidator validator = new MT_BroadcastImportDataValidator(ctrlRec);

    validator.mb1Sum = Decimal.valueOf(numbers.left(2 + mb1Scale));
    validator.mb3Sum = Decimal.valueOf(numbers.left(2 + mb3Scale));
    validator.mn3Sum = Decimal.valueOf(numbers.left(2 + mn3Scale));

    validator.finish(null);

    // FIXME assert that no email is sent out
    List<AsyncApexJob> jobsAfter = [SELECT Id
                                      FROM AsyncApexJob
                                     WHERE JobType = 'BatchApex'
                                       AND Status IN ('Holding', 'Queued')
                                       AND ApexClass.NamespacePrefix = null
                                       AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];
    System.assert((jobs.size() + 1) == jobsAfter.size(), 'Transformator batch job has not been called although no error occurred!');
  }


  @IsTest
  public static void testFinishWithTransformerInvocation() {
    List<AsyncApexJob> jobs = [SELECT Id
                                 FROM AsyncApexJob
                                WHERE JobType = 'BatchApex'
                                  AND Status IN ('Holding', 'Queued')
                                  AND ApexClass.NamespacePrefix = null
                                  AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];

    MT_BroadcastImportDataValidator validator = new MT_BroadcastImportDataValidator(createControlRecord());

    validator.finish(null);


    // FIXME assert that no email is sent out

    List<AsyncApexJob> jobsAfter = [SELECT Id
                                      FROM AsyncApexJob
                                     WHERE JobType = 'BatchApex'
                                       AND Status IN ('Holding', 'Queued')
                                       AND ApexClass.NamespacePrefix = null
                                       AND ApexClass.Name = :MT_BroadcastImportDataTransformator.class.getName()];
    System.assert((jobs.size() + 1) == jobsAfter.size(), 'Transformator batch job has not been invoked');
  }


  private static MT_MediaBroadcastImportControlData__c createControlRecord() {
    return createControlRecord(0, 0, 0, 0);
  }

  private static MT_MediaBroadcastImportControlData__c createControlRecord(Integer recCount, Decimal sumMB1, Decimal sumMB3, Decimal sumMN3) {
    return new MT_MediaBroadcastImportControlData__c(
        MT_ImportDate__c = System.today(),
        MT_RecordCount__c = recCount,
        MT_SumMB1__c = sumMB1,
        MT_SumMB3__c = sumMB3,
        MT_SumMN3__c = sumMN3
    );
  }
}