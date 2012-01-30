// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .



function show_or_hide_version_management_modes_div(automaticMode) {	

	if (automaticMode) {						
		$('span#update_mode_status').html("Version number is <b>automatically updated</b> from the AppStore.");
		
		// $("input.automatic_version_management").removeAttr("disabled");
	    $("input.manual_version_management_class").attr("disabled", true);
	    
	} else {
		$('span#update_mode_status').html("Version number is <b>manually managed</b> by you.");
		
		$("input.manual_version_management_class").removeAttr("disabled");
	    // $("input.automatic_version_management").attr("disabled", true); // Was there for appleID field
	    
	}
}



$(document).ready(function() {
	
      $("#ios_application_manual_version_management").iphoneStyle(
	{
		checkedLabel: 'Automatic', uncheckedLabel: 'Manual' ,
					        onChange: function(elem, value) { 
					show_or_hide_version_management_modes_div(value);
			        }
			}
		);
	

	show_or_hide_version_management_modes_div( $("#ios_application_manual_version_management").is(":checked") );
});