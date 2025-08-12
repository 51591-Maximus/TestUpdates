trigger ProjectRoleDefinition on Project_Role__c (before insert, before update, after insert, after update, after delete) {
    RoleHandler.objHandled = 'Project_Role__c';
    
    if (Trigger.isBefore){
        if (Trigger.isInsert || Trigger.isUpdate){        
            RoleHandler.handleBeforeInsertOrUpdate(Trigger.new);
        }
    }
    if (Trigger.isAfter){
        if (Trigger.isInsert || Trigger.isUpdate){
            RoleHandler.handleAfterInsertOrUpdate(Trigger.new);
        }       
        if (Trigger.isDelete){
            RoleHandler.handleAfterDelete(Trigger.old);
        }
    }
    
}