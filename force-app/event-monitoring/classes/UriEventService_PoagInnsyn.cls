/* 
convert UriEvent to Log__c record with lookup to Person Ident
Make it possible for NAV's "snokelogg" to get log elemnts
*/
public with sharing class UriEventService_PoagInnsyn {
        
    public static void addPersonRelatedRecordsToLog(List<UriEvent> uriEvents) {
            Set<Id> personRecordIds = new Set<Id>();
            List<Log__c> logs = new List<Log__c>();
    
            Map<Id, UriEvent> uriEventByRecordId = new Map<Id, UriEvent>();
    
            //record ids for each object we want to log
            Set<Id> candidateRecordIds = new Set<Id>();
    
            //check if object ype should be logged
            for (UriEvent ue : uriEvents) {
                //only standard users are logged
                if (ue.UserType != 'Standard')
                    continue;
    
                switch on ue.QueriedEntities {
                    when 'Candidate__c' {
                        uriEventByRecordId.put(ue.RecordId, ue);
                        personRecordIds.add(ue.RecordId);
                    }
                }
            }
            //get related person ident for each object
            Map<Id, String> personIdentByRecordId = getPersonIdentsForEachObject(
                personRecordIds,
                candidateRecordIds
            );
    
            //add log elemnt with person ident
            for (Id recordId : personIdentByRecordId.keyset()) {
                logs.add(UriEventService.addLogElement(uriEventByRecordId.get(recordId), personIdentByRecordId.get(recordId)));
            }
    
         if (logs.size() > 0) {
                insert logs;
            }
      
    }
    
    private static Map<Id, String> getPersonIdentsForEachObject(
        Set<Id> personRecordIds,
        Set<Id> candidateRecordIds
    ) {
        Map<Id, String> personIdentByRecordId = new Map<Id, String>();
    
        //Candidate
        if (personRecordIds.size() > 0) {
            for (Candidate__C candidate : [SELECT Id,Personnumber__c FROM Candidate__C WHERE Id IN :personRecordIds]) {
                if(candidate.Personnumber__c!=null){
                    personIdentByRecordId.put(candidate.Id, candidate.Personnumber__c);
                }
            }
        }
        return personIdentByRecordId;
    }   
}