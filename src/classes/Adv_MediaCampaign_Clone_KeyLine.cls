global class Adv_MediaCampaign_Clone_KeyLine {
	private ADvendio__KeyLine__c objKeyLine;
	private List<ADvendio__KeyValue__c> listKeyValues = new List<ADvendio__KeyValue__c>();

	public Adv_MediaCampaign_Clone_KeyLine(ADvendio__KeyLine__c keyLine) {
		this.objKeyLine = keyLine;	
	}

	public void addKeyValue(ADvendio__KeyValue__c value){
		this.listKeyValues.add(value);
	}

	public Integer size() {
		return this.listKeyValues.size();
	}

	public ADvendio__KeyLine__c cloneKeyLine(Map<Id, ADvendio__Campaign_Item__c> mapping){
		ADvendio__KeyLine__c result = new ADvendio__KeyLine__c(Name = this.objKeyLine.Name);
		result.ADvendio__CampaignItem__c = mapping.get(objKeyLine.ADvendio__CampaignItem__c).Id;

		return result;
	}

	public List<ADvendio__KeyValue__c> cloneKeyValues(ADvendio__KeyLine__c objKeyLine){
		List<ADvendio__KeyValue__c> listResult = new List<ADvendio__KeyValue__c>();

		ADvendio__KeyValue__c objClone;
		for(ADvendio__KeyValue__c objKeyValue :listKeyValues){
			objClone = objKeyValue.clone();
			objClone.ADvendio__KeyLine__c = objKeyLine.Id;

			listResult.add(objClone);
		}

		return listResult;
	}

	public override String toString(){
		String result = '(';
		
		for(ADvendio__KeyValue__c objKeyValue :listKeyValues){
			result += '(';
			result += String.isBlank(objKeyValue.Advendio__Key__r.ADvendio__ExternalName__c) ? objKeyValue.ADvendio__Key__r.Name : objKeyValue.Advendio__Key__r.ADvendio__ExternalName__c;
			result += (objKeyValue.ADvendio__Operator__c == 'equal to') ? '=' : '!=';
			result += objKeyValue.ADvendio__Values__c; 
			result += ')';
			result += ' AND ';
		}
		result = result.removeEnd(' AND ');
		result += ')';
		return result;
	}

	public Id getKeyLineId(){
		return objKeyLine.Id;
	}

	/**
	 * Checks if the key lines are valid for targeting surcharge.
	 * function ported from ModifyCampaignItemJavaScriptExtension aka CJS.
	 * @return boolean answer
	 */
	public Boolean isValidKeyValueTarget_TargetingAufschlag() {
		Boolean isValidKeyValueTargeting = false;
		for(ADvendio__KeyValue__c keyValue : listKeyValues) {
			if(keyValue.ADvendio__Key__r.Name != 'Ausschluss-Identifier') {
				isValidKeyValueTargeting = true;
				break;
			}
		}
		return isValidKeyValueTargeting;
	}

	/**
	 * Checks if the key lines are valid for rotation surcharge.
	 * function ported from ModifyCampaignItemJavaScriptExtension aka CJS.
     * @param adSpec_rotationsTyp string containing the rotationsTyp of the placement
	 * @return boolean answer
	 */
	public Boolean isValidKeyValueTargeting_RotationsAufschlag(String adSpec_rotationsTyp) {
		Boolean isValidKeyValueTargeting = false;
		for(ADvendio__KeyValue__c keyValue : listKeyValues) {
			if(keyValue.ADvendio__Key__r.Name == 'Ausschluss-Identifier') {
				String values = keyValue.ADvendio__Values__c != null ? keyValue.ADvendio__Values__c : '';
				if(values.split(',').size() > 3 || (values.contains('Videovalis.de') && isValidRotationstyp(adSpec_rotationsTyp)) ) {
					isValidKeyValueTargeting = true;
					break;
				}
				
			}
		}
		return isValidKeyValueTargeting;
	}

	/**
     * Checks if the rotationstyp of a placement is Network-Rotation.
     * function ported from ModifyCampaignItemJavaScriptExtension aka CJS.
     * @param adSpec_rotationsTyp string containing the rotationsTyp of the placement
     * @return boolean answer
     */
	public Boolean isValidRotationstyp(String adSpec_rotationsTyp) {
    	return adSpec_rotationsTyp == 'Network-Rotation';
    }
}