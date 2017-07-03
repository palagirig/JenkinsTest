global class Lcm_Sandbox_Setup implements SandboxPostCopy {
	global void runApexClass(SandboxContext context) {
		upadteEmailAdress(queryUserList(context));
		createDefaultCompRecordIfMissing();
	}

	global void upadteEmailAdress(List<User> listUsers){ 
		Boolean runInTestMode = false;
		System.debug('### Anzahl User: ' + listUsers.size());

		for (User usr : listUsers) {
			String oldEmail = usr.Email;
			List<String> parts = oldEmail.split('[=@]');
			parts.remove(2);
			usr.Email = String.join(parts, '@');

			System.debug('### Updating email: ' + oldEmail + ' => ' + usr.Email);
		}

		Savepoint sp = Database.setSavepoint();

		try {
			if (!runInTestMode) {
				update listUsers;
			}
		} catch (Exception e) {
			System.debug('### Error while updating email addresses: ' + e);
			Database.rollback(sp);
		}
	}

	global List<User> queryUserList(SandboxContext context){ 
		List<User> listUser = [SELECT Id, Username, Email, Lcm_Sandboxes__c
								FROM User
								WHERE IsActive = true
									AND Email LIKE '%example.com%'
									AND Lcm_Sandboxes__c != null
									AND P7S1_Projects__c INCLUDES ('AdC_CoreTeam', 'CRMSALES_CoreTeam', 'SalesExcellence_CoreTeam')
								ORDER BY Email
							];
		for(Integer i=0;i<listUser.size();i++){
			User oneUser = listUser.get(i);
			String sRegex = '(?i)^('+oneUser.Lcm_Sandboxes__c+')';
			sRegex = sRegex.replaceAll(',','|');
			sRegex = sRegex.replaceAll('\\*','\\.\\*');
			System.debug('### User: '+oneUser.Username+ ' // '+sRegex);

			Pattern onePattern = Pattern.compile(sRegex);
			Matcher oneMatcher = onePattern.matcher(context.sandboxName());
			System.debug('Result: '+oneMatcher.matches());
			if(oneMatcher.matches()){
				System.debug('Match found');
			}else{
				listUser.remove(i);
				i--;
			}
		}
		System.debug(listUser);
		return listUser;
	}

	/*
	 * Checks if there is a valid ID in P7S1_Setting__c. If not, creates a Firma(P7S1_Comp__c) record and stores the ID to mark it as default. Used for P7S1_Emp_Serviceweb.
	 */
	private void createDefaultCompRecordIfMissing() {
		// check if the P7S1_Comp__c ID in custom setting is valid.
		List<P7S1_Comp__c> comps = new List<P7S1_Comp__c>([SELECT Id FROM P7S1_Comp__c WHERE ID = :P7S1_Settings__c.getOrgDefaults().P7S1_Emp_Serviceweb_DefaultCompID__c]);
		// if so, exit.
		if(!comps.isEmpty()) return;

		// if not, create one and assign as default.
		P7S1_Comp__c objComp = cls_P7S1_TestData.createTestFirma(true);
        upsert new P7S1_Settings__c(SetupOwnerId = Userinfo.getOrganizationId(), P7S1_Emp_Serviceweb_DefaultCompID__c = objComp.Id);
	}
}