$(document).ready(function() {
	$('form').live('submit', function(e) {
    	$(this).append('Loading...');
  	});
	$("#edit_group_cancel").live('click', function() { 
		$('#edit_group').hide(); 
		$('#group_info').show();
	});
	$("#edit_student_cancel").live('click', function() { 
		id = $(this).attr("data");
		$("#edit_student_"+id).hide();
		$("#student_info_"+id).show();
	});
	// $('.email_form input[email]').each(function() {
	//         $thisInput = $(this);
	//         if ($thisInput.val() == '') {
	//             $thisInput.val($thisInput.attr('title'));
	//         }
	//         
	//         $thisInput.focus(function() {
	//             if ($(this).val() === $(this).attr('title')) {
	//                 $(this).val('').addClass('focused');
	//             }
	//         });
	//         
	//         $thisInput.blur(function() {
	//             if ($(this).val() === '') {
	//                 $(this).val($(this).attr('title')).removeClass('focused');
	//             }
	//         });
	// });
});