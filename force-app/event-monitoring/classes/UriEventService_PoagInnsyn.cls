/* 
convert UriEvent to Log__c record with lookup to Person Ident
Make it possible for NAV's "snokelogg" to get log elemnts
*/
public with sharing class UriEventService_PoagInnsyn {
        
    public static void addPersonRelatedRecordsToLog(List<UriEvent> uriEvents) {
          
            List<Log__c> logs = new List<Log__c>();
    
            Map<Id, UriEvent> uriEventByRecordId = new Map<Id, UriEvent>();
    
            //record ids for each object we want to log
            Set<Id> candidateRecordIds = new Set<Id>();
            Set<Id> candidateOnListRecordIds = new Set<Id>();
    
            //check if object ype should be logged
            for (UriEvent ue : uriEvents) {
                //only standard users are logged
                if (ue.UserType != 'Standard')
                    continue;
    
                switch on ue.QueriedEntities {
                    when 'Candidate__c' {
                        uriEventByRecordId.put(ue.RecordId, ue);
                        candidateRecordIds.add(ue.RecordId);
                    }
                    when 'Candidate_on_list__c' {
                        uriEventByRecordId.put(ue.RecordId, ue);
                        candidateOnListRecordIds.add(ue.RecordId);
                    }
                }
            }
            //get related person ident for each object
            Map<Id, String> personIdentByRecordId = getPersonIdentsForEachObject(
                candidateRecordIds,
                candidateOnListRecordIds
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
        Set<Id> candidateRecordIds,
        Set<Id> candidateOnListRecordIds
    ) {
        Map<Id, String> personIdentByRecordId = new Map<Id, String>();
    
        //Candidate
        if (candidateRecordIds.size() > 0) {
            for (Candidate__c candidate : [SELECT Id,Personnumber__c FROM Candidate__C WHERE Id IN :candidateRecordIds]) {
                if(candidate.Personnumber__c!=null){
                    personIdentByRecordId.put(candidate.Id, candidate.Personnumber__c);
                }
            }
        }

         //Candidate on list
         if (candidateOnListRecordIds.size() > 0) {
            for (Candidate_on_list__c candidateOnList : [SELECT Id,Candidate__r.Personnumber__c FROM Candidate_on_list__c WHERE Id IN :candidateOnListRecordIds]) {
                if(candidateOnList.Candidate__c != null && candidateOnList.Candidate__r.Personnumber__c!=null){
                    personIdentByRecordId.put(candidateOnList.Id, candidateOnList.Candidate__r.Personnumber__c);
                }
            }
        }
        return personIdentByRecordId;
    }   
}