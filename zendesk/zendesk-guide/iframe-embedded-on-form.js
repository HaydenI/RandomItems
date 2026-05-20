$(document).ready(function () {
    // START iFrame
    var selected = $('#request_issue_type_select option:selected').text();
    if (selected == "iFrame Form") {
        $('div.request_ticket_form_id').append('<p><iframe src="https://linktoiframe.com" title="iFrame" width="100%" height="1000"></iframe></p>');
        $('.form-field.request_subject').hide();
        $('.form-field.request_description').hide();
        $('.form-field.request-attachments').hide();
        $('.form-field label:contains("Attachments")').hide();
        $('#upload-dropzone').hide();
        $('input').hide();
    }
    // END iFrame 
});