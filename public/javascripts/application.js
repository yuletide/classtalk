$(document).ready(function() {
	$('form').live('submit', function(e) {
		$('.infield_form_label').each(function() {
			// if ($(this).attr('title') == $(this).val()) {
			// 	$('form').prepend('ERROR');
			// 	e.preventDefault();
			// }
		});
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
	
	//Puts field title in form field
	$('.infield_form_label').each(function() {
		$thisInput = $(this);
		if ($thisInput.val() == '') {
			$thisInput.val($thisInput.attr('title'));
		}
	        
		$thisInput.focus(function() {
			if ($(this).val() === $(this).attr('title')) {
				$(this).val('').addClass('focused');
			}
		});
	        
		$thisInput.blur(function() {
			if ($(this).val() === '') {
				$(this).val($(this).attr('title')).removeClass('focused');
			}
		});
	});
});
//On click of Message link, hides Members and displays send message
function toggleMessage() {
	var message = document.getElementById("message");
	var members = document.getElementById("members");
	if(members.style.display == "block" && message.style.display == "none") {
    	members.style.display = "none";
		message.style.display = "block";
  	}
	else {
		members.style.display = "none";
		message.style.display = "block";
	}
}
//On click of Members link, hides Message and displays members
function toggleMembers() {
	var message = document.getElementById("message");
	var members = document.getElementById("members");
	if(members.style.display == "none" && message.style.display == "block") {
    	members.style.display = "block";
		message.style.display = "none";
  	}
	else {
		members.style.display = "block";
		message.style.display = "none";
	}
}