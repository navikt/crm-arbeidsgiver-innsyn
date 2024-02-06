/**
 * @description This GeneratePdfController class supplies the TAG_GeneratePDF visualforce page with necassary data
 *
 * @author Andre Colle <andre.colle@nav.no>
 * @since 2024-01-31 Created.
 *
 * @see [License](https://github.com/navikt/crm-arbeidsgiver-innsyn/blob/main/LICENSE)
 * @see [Github](https://github.com/navikt/crm-arbeidsgiver-innsyn)
 *
 * @group TAG Pdf Contoller
 */

public class TAG_GeneratePdfController {
    public List<Candidate_on_list__c> candidateOnLists { get; private set; }
    public List<Candidate_Comment_on_list__c> commentsOnLists { get; private set; }
    public Set<Id> candidateOnListIds = new Set<Id>();

    public TAG_GeneratePdfController(ApexPages.StandardController controller) {
        candidateOnLists = getCandidateOnList(controller.getId());
        //this.candidateOnListIds = new Set<String>();
        commentsOnLists = getCommentsOnList();
    }

    public List<Candidate_on_list__c> getCandidateOnList(Id candidateId) {
        List<Candidate_on_list__c> candidateOnList = [
            SELECT Id, List__c, Date_added_to_list__c, List__r.List_Name__c, List__r.List_description__c, Candidate__c
            FROM Candidate_on_list__c
            WHERE RemoveListFromPdf__c = FALSE AND Candidate__c = :candidateId
        ];

        for (Candidate_on_list__c cl : candidateOnList) {
            candidateOnListIds.add(cl.id);

            if (cl.List__r.List_description__c != null && cl.List__r.List_description__c.length() > 80) {
                String modifiedListDescription = '';
                // Calculate the number of line breaks to insert
                Integer numOfLineBreaks = cl.List__r.List_description__c.length() / 80;

                // Insert line breaks after every 80 characters
                for (Integer i = 1; i <= numOfLineBreaks; i++) {
                    modifiedListDescription += cl.List__r.List_description__c.substring((i - 1) * 80, i * 80) + '\n';
                }
                // Set the modified ListDescription back to the record
                cl.List__r.List_description__c = modifiedListDescription;
            }
        }

        return candidateOnList;
    }

    public List<Candidate_Comment_on_list__c> getCommentsOnList() {
        List<Candidate_Comment_on_list__c> commentsOnList = [
            SELECT Id, Comment__c, Kandidat_p_liste__c, Date_added_to_list__c
            FROM Candidate_Comment_on_list__c
            WHERE RemoveCommentFromPdf__c = FALSE AND Kandidat_p_liste__c IN :candidateOnListIds
        ];

        // Iterate through each comment and add line breaks if the text is more than 80 characters
        for (Candidate_Comment_on_list__c comment : commentsOnList) {
            if (comment.Comment__c != null && comment.Comment__c.length() > 80) {
                String modifiedComment = '';
                // Calculate the number of line breaks to insert
                Integer numOfLineBreaks = comment.Comment__c.length() / 80;

                // Insert line breaks after every 80 characters
                for (Integer i = 1; i <= numOfLineBreaks; i++) {
                    modifiedComment += comment.Comment__c.substring((i - 1) * 80, i * 80) + '\n';
                }
                // Set the modified comment back to the record
                comment.Comment__c = modifiedComment;
            }
        }
        return commentsOnList;
    }
}
