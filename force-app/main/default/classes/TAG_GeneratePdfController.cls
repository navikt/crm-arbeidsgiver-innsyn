public class TAG_GeneratePdfController {
    private ApexPages.StandardController standardController;

    public TAG_GeneratePdfController(ApexPages.StandardController controller) {
        this.standardController = controller;
    }

    public List<Candidate_on_list__c> getCandidateOnList() {
        List<Candidate_on_list__c> records = [
            SELECT Name, Candidatelistnumber__c, Copy_of_notes__c
            FROM Candidate_on_list__c
            WHERE Candidate__c = :ApexPages.currentPage().getParameters().get('id')
        ];

        return records;
    }
}
