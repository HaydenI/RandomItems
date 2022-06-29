var tags = HelpCenter.user.tags;
if (tags.indexOf('tag_that_should_be_applied_to_user') == -1) {
    var selected = $('#request_issue_type_select option:selected').text();
    if (selected == "Form That Should Be Blocked") {
      $('.form-field.request_ticket_form_id').append('<p id="prio_disclaimer">This form is blocked</p>');
        $('.form-field.request_subject').hide();
        $('.form-field.request_custom_fields_FIELDID').hide();
        $('.form-field.request_description').hide();
        $('.form-field.request-attachments').hide();
        $('.form-field label:contains("Attachments")').hide();
        $('#upload-dropzone').hide();
        $('input').hide();
    }
}
else { 

} 