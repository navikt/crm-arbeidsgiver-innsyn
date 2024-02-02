@IsTest
public with sharing class TAG_GeneratePdfControllerTest {
    @TestSetup
    static void makeData() {
        Candidate__c candidate1 = new Candidate__c(
            Name = '1527367521',
            Candidate_number__c = '2378457832',
            Personnumber__c = '12345678987'
        );
        insert candidate1;

        List__c list1 = new List__c(
            Name = '2387648932',
            List_Name__c = 'NAV liste',
            List_description__c = 'Manchester United ledet både 2–0 og 3–1 og så ut til å ha full kontroll borte mot Wolverhampton.',
            Listnumk__c = '8732894723894'
        );
        insert list1;

        List__c list2 = new List__c(
            Name = '2387648888',
            List_Name__c = 'UIO liste',
            List_description__c = 'skrev seg inn i alle Manchester United-supporteres hjerter torsdag kveld. Nå holdes det ikke tilbake på superlativene om stjerneskuddet.',
            Listnumk__c = '8732894723888'
        );
        insert list2;
    }

    @IsTest
    static void testGeneratePdfControllerPositive() {
        Candidate__c candidate = [SELECT Id FROM Candidate__c WHERE Name = '1527367521'];

        List<List__c> listNAV = [SELECT Id FROM List__c WHERE Name = '2387648932'];

        List<List__c> listUIO = [SELECT Id FROM List__c WHERE Name = '2387648888'];

        Candidate_on_list__c candidateOnListNAV = new Candidate_on_list__c(
            Candidate__c = candidate.Id,
            Name = '6238238',
            Candidatelistnumber__c = '328947389',
            List__c = listNAV[0].Id
        );
        insert candidateOnListNAV;

        Candidate_on_list__c candidateOnListUIO = new Candidate_on_list__c(
            Candidate__c = candidate.Id,
            Name = '6238267',
            Candidatelistnumber__c = '328947355',
            List__c = listUIO[0].Id
        );
        insert candidateOnListUIO;

        Candidate_Comment_on_list__c commentOnListNAV1 = new Candidate_Comment_on_list__c(
            Kandidat_p_liste__c = candidateOnListNAV.Id,
            Name = '63722154125',
            Comment__c = 'Following losses to Nottingham Forest and Manchester City, the black and whites are bidding to avoid a trio of successive PL home defeats for the first time since January/February 2021.',
            Date_added_to_list__c = Date.TODAY()
        );
        insert commentOnListNAV1;

        Candidate_Comment_on_list__c commentOnListNAV2 = new Candidate_Comment_on_list__c(
            Kandidat_p_liste__c = candidateOnListNAV.Id,
            Name = '6372215333',
            Comment__c = 'Following losses to Nottingham Forest and Manchester City, the black and whites are bidding to avoid a trio of successive PL home defeats for the first time since January/February 2021.',
            Date_added_to_list__c = Date.TODAY()
        );
        insert commentOnListNAV2;

        Candidate_Comment_on_list__c commentOnListUIO1 = new Candidate_Comment_on_list__c(
            Kandidat_p_liste__c = candidateOnListUIO.Id,
            Name = '63722154444',
            Comment__c = 'Following losses to Nottingham Forest and Manchester City, the black and whites are bidding to avoid a trio of successive PL home defeats for the first time since January/February 2021.',
            Date_added_to_list__c = Date.TODAY()
        );
        insert commentOnListUIO1;

        Candidate_Comment_on_list__c commentOnListUIO2 = new Candidate_Comment_on_list__c(
            Kandidat_p_liste__c = candidateOnListUIO.Id,
            Name = '63722154444',
            Comment__c = 'Following losses to Nottingham Forest and Manchester City, the black and whites are bidding to avoid a trio of successive PL home defeats for the first time since January/February 2021.',
            Date_added_to_list__c = Date.TODAY()
        );
        insert commentOnListUIO2;

        // Instantiate controller with standard controller and test data
        ApexPages.StandardController stdController = new ApexPages.StandardController(candidate);
        TAG_GeneratePdfController controller = new TAG_GeneratePdfController(stdController);

        // Test getCandidateOnList method
        List<Candidate_on_list__c> candidateOnLists = controller.getCandidateOnList(candidate.Id);
        System.assertEquals(2, candidateOnLists.size(), 'Candidate_on_list__c records not retrieved successfully');

        // Test getCommentsOnList method
        List<Candidate_Comment_on_list__c> commentsOnLists = controller.getCommentsOnList();
        System.assertEquals(
            4,
            commentsOnLists.size(),
            'Candidate_Comment_on_list__c records not retrieved successfully'
        );
    }
}
