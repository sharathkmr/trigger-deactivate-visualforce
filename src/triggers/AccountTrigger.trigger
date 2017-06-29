trigger AccountTrigger on Account (before insert, before update) {
    if(Trigger_Control__c.getValues('AccountTrigger') != null) {
        return;
    }
    System.debug('Hello Account');
}