/**
 * Starts the broadcast import data transformator batch job.
 */
public with sharing class MT_BroadcastImpDataTransformScheduler implements Schedulable {

    /**
     * Starts the batch job.
     *
     * @param SchedulableContext sc
     */
  public void execute(SchedulableContext sc) {
    MT_BroadcastImportDataTransformator bidt = new MT_BroadcastImportDataTransformator();
    Database.executeBatch(bidt);
  }

}