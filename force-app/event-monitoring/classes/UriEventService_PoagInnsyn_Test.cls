@IsTest
private class UriEventService_PoagInnsyn_Test{

    @IsTest
    private static void addPersonRelatedRecordsToLog_forCandidates() {
        //check test data
        List<Candidate__c> candidates=new List<Candidate__c>{
            new Candidate__c(Candidate_number__c='1', Name='First', Personnumber__c='1234'),
            new Candidate__c(Candidate_number__c='2', Name='Second')
        };
        insert candidates;
        System.assertEquals(2, candidates.size());

        //create test uriEvents
        List<UriEvent> uriEvents = new List<UriEvent>();
        uriEvents.add(new UriEvent(candidates[0].Id, DateTime.now(), 'Candidate__c', 'Read', 'user@user.nav.no', 'Standard'));
        uriEvents.add(new UriEvent(candidates[1].Id, DateTime.now(), 'Candidate__c', 'Read', 'user@user.nav.no', 'Standard'));

        Test.startTest();
        UriEventService_PoagInnsyn.addPersonRelatedRecordsToLog(uriEvents);
        Test.stopTest();

        List<Log__c> logs = [SELECT CRM_PersonIdent__c FROM Log__c WHERE CRM_Type__c = 'LightningUriEvent'];
        System.assertEquals(1, logs.size(), 'One log element is created');
        System.assertEquals(
            candidates[0].Personnumber__c,
            logs[0].CRM_PersonIdent__c,
            'Log element should have persons fødselsr'
        );
    }

    @IsTest
    private static void addPersonRelatedRecordsToLog_forCandidatesOnList() {
        //check test data
        List<Candidate__c> candidates=new List<Candidate__c>{
            new Candidate__c(Candidate_number__c='1', Name='First', Personnumber__c='1234'),
            new Candidate__c(Candidate_number__c='2', Name='Second')
        };
        insert candidates;

        List__c candidateList= new List__c(Name='List');
        insert candidateList;
        
        List<Candidate_on_list__c> candidateOnLists=new List<Candidate_on_list__c>{
            new Candidate_on_list__c(Candidate__c=candidates[0].Id, List__c=candidateList.Id),
            new Candidate_on_list__c(Candidate__c=candidates[1].Id, List__c=candidateList.Id)
        };
        insert candidateOnLists;

        System.assertEquals(2, candidateOnLists.size());

        //create test uriEvents
        List<UriEvent> uriEvents = new List<UriEvent>();
        uriEvents.add(new UriEvent(candidateOnLists[0].Id, DateTime.now(), 'Candidate_on_list__c', 'Read', 'user@user.nav.no', 'Standard'));
        uriEvents.add(new UriEvent(candidateOnLists[1].Id, DateTime.now(), 'Candidate_on_list__c', 'Read', 'user@user.nav.no', 'Standard'));

        Test.startTest();
        UriEventService_PoagInnsyn.addPersonRelatedRecordsToLog(uriEvents);
        Test.stopTest();

        List<Log__c> logs = [SELECT CRM_PersonIdent__c FROM Log__c WHERE CRM_Type__c = 'LightningUriEvent'];
        System.assertEquals(1, logs.size(), 'One log element is created');
        System.assertEquals(
            candidates[0].Personnumber__c,
            logs[0].CRM_PersonIdent__c,
            'Log element should have persons fødselsr'
        );
    }

 
}
