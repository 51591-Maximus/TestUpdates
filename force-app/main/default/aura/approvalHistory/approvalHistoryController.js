({
	doInit : function(component, event, helper) {
		var action = component.get("c.getApprovalHistory");
     	action.setParams({
            "recordId": component.get("v.thisRecordId")
     	});
     	action.setCallback( this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.approvalHistoryList", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	}
})