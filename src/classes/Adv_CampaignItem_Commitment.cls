/**
 * Commitments and Discounts
 */
global class Adv_CampaignItem_Commitment {

	public final static String PREFIX_MEDIA_CAMP	= Schema.getGlobalDescribe().get('ADvendio__MediaCampaign__c').getDescribe().getKeyPrefix();
	public final static String INPAGE_IND		   = 'InPage';
	public final static String INSTREAM_IND		 = 'InStream';
	public static Boolean doneTracking			  = false;

	/**
	 * Call from a button shown on Commitment "SomDig_CreateMediaCampaign"
	 * @param commId, source Commitment record
	 * @return url with pre-populated data
	 */
	webservice static String generateUrl(String commId) {
		ADvendio__MediaCampaign__c mediaCamp = new ADvendio__MediaCampaign__c(ADvendio__IsApproved__c = true, SomDig_RabatteMKgenehmigt__c=true);
		SomDig_Commitment__c comm = getCommitmentsData(new Set<Id>{Id.valueOf(commId)}).get(Id.valueOf(commId));
		tranCommitmentToMediaCamp(comm, mediaCamp);
		String urlString = '/' + PREFIX_MEDIA_CAMP +  '/e?' + 'nooverride=1&retURL=/'+commId;
		Map<String, String> mValue =  createDefaultValues(comm, mediaCamp);
		for(String fldId : mValue.keySet()){
			urlString += '&' + fldId + '=' + mValue.get(fldId);
		}
		return urlString;
	}

	/**
	* copy campaign discounts to all it's campaign-items if a discount is changed
	* @param	a list of ADvendio__MediaCampaign__c records (trigger.new)
	* @param	a map of ADvendio__MediaCampaign__c records (trigger.oldMap)
	**/
	public static void copyDiscountsToItems(List<ADvendio__MediaCampaign__c> newCampaignList, Map<Id, ADvendio__MediaCampaign__c> oldCampaignMap) {

		Map<Id, ADvendio__MediaCampaign__c> mediaCampaigns  = new Map<Id, ADvendio__MediaCampaign__c>();
		Set<Id> mcIsNotApproved = new Set<Id>();

		// identify and store any involved campaign
		for (ADvendio__MediaCampaign__c mc : newCampaignList) {
			if ( mc.SomDig_Kundenrabatt_InPage__c   != oldCampaignMap.get(mc.Id).SomDig_Kundenrabatt_InPage__c ||
				 mc.SomDig_Kundenrabatt_InStream__c != oldCampaignMap.get(mc.Id).SomDig_Kundenrabatt_InStream__c ||
				 mc.SomDig_Sonderrabatt_InPage__c   != oldCampaignMap.get(mc.Id).SomDig_Sonderrabatt_InPage__c ||
				 mc.SomDig_Sonderrabatt_InStream__c != oldCampaignMap.get(mc.Id).SomDig_Sonderrabatt_InStream__c ||
				 mc.SomDig_Agenturrabatt__c			!= oldCampaignMap.get(mc.Id).SomDig_Agenturrabatt__c ||
				 mc.SomDig_Naturalrabatt_Inpage__c 	!= oldCampaignMap.get(mc.Id).SomDig_Naturalrabatt_Inpage__c
			) {

				if (mc.ADvendio__IsApproved__c  != oldCampaignMap.get(mc.Id).ADvendio__IsApproved__c && !mc.ADvendio__IsApproved__c
				   /* mc.SomDig_Kundenrabatt_InPage__c  > oldCampaignMap.get(mc.Id).SomDig_Kundenrabatt_InPage__c   && mc.SomDig_Kundenrabatt_InPage__c	 >= 65 ||
					mc.SomDig_Kundenrabatt_InStream__c  > oldCampaignMap.get(mc.Id).SomDig_Kundenrabatt_InStream__c && mc.SomDig_Kundenrabatt_InStream__c   >= 65 ||
					mc.SomDig_Sonderrabatt_InPage__c	> oldCampaignMap.get(mc.Id).SomDig_Sonderrabatt_InPage__c   && mc.SomDig_Sonderrabatt_InPage__c	 >= 65 ||
					mc.SomDig_Sonderrabatt_InStream__c  > oldCampaignMap.get(mc.Id).SomDig_Sonderrabatt_InStream__c && mc.SomDig_Sonderrabatt_InStream__c   >= 65 ||
					mc.ADvendio__Rate_Discount_3__c	 > oldCampaignMap.get(mc.Id).ADvendio__Rate_Discount_3__c	&& mc.ADvendio__Rate_Discount_3__c	  >= 65*/
				) {
					mcIsNotApproved.add(mc.Id);
				}
				mediaCampaigns.put(mc.Id, mc);
			}
		}

		Set<String> sonderRabattNamen   = new Set<String>{'Kompensation', 'Nachlieferung', 'Positionsrabatt Natural', 'Storno mit Leistungsfluss', 'Storno ohne Leistungsfluss'};

		List<ADvendio__Campaign_Item__c> campaignItemsToUpdate  = new List<ADvendio__Campaign_Item__c>();
		if (!mediaCampaigns.isEmpty()) {
			// get all campaign-items for changed campaigns
			for (ADvendio__Campaign_Item__c ci : [SELECT Id, SomDig_Menge__c, SomDig_Naturalrabatt__c, ADvendio__Rate_Discount_4_Name__c, SomDig_RabatteFreigegebenCheck__c, 
														 SomDig_MediagattungsDifferenzierungName__c, ADvendio__Rate_Discount_2_custom__c, ADvendio__Rate_Discount_3_custom__c,
														 ADvendio__Rate_Discount_4__c, ADvendio__Media_Campaign__c, ADvendio__Billing_category__c, ADvendio__Sales_Price__c,
														 ADvendio__Frequency__c, ADvendio__SurchargeSalesPrice__c
													FROM ADvendio__Campaign_Item__c
													WHERE ADvendio__Media_Campaign__c IN :mediaCampaigns.keySet() order by ADvendio__Media_Campaign__c asc]) {
				ADvendio__MediaCampaign__c mc	   = mediaCampaigns.get(ci.ADvendio__Media_Campaign__c);
				ADvendio__Campaign_Item__c ciUpdate = new ADvendio__Campaign_Item__c(Id=ci.Id);
				Boolean changed = false;

				if (mcIsNotApproved.contains(ci.ADvendio__Media_Campaign__c)) {
					if (!ci.SomDig_RabatteFreigegebenCheck__c) {
						ciUpdate.SomDig_RabatteFreigegebenCheck__c  = true;
						changed = true;
					}
				}

				if (ci.SomDig_MediagattungsDifferenzierungName__c != null) {
					if (ci.SomDig_MediagattungsDifferenzierungName__c.contains(INSTREAM_IND)) { // InStream
						if (ci.ADvendio__Rate_Discount_2_custom__c != mc.SomDig_Kundenrabatt_InStream__c && mc.SomDig_Kundenrabatt_InStream__c != oldCampaignMap.get(mc.Id).SomDig_Kundenrabatt_InStream__c) { // Kundenrabatt changed
							ciUpdate.ADvendio__Rate_Discount_2_custom__c	= mc.SomDig_Kundenrabatt_InStream__c;
							changed = true;
						}
						if (ci.ADvendio__Rate_Discount_4__c != mc.SomDig_Sonderrabatt_InStream__c && mc.SomDig_Sonderrabatt_InStream__c != oldCampaignMap.get(mc.Id).SomDig_Sonderrabatt_InStream__c) { // Sonderrabatt changed
							if (!sonderRabattNamen.contains(ci.ADvendio__Rate_Discount_4_Name__c)) {
								ciUpdate.ADvendio__Rate_Discount_4__c	   = mc.SomDig_Sonderrabatt_InStream__c;
								changed = true;
							}
						}
					}
					if (ci.SomDig_MediagattungsDifferenzierungName__c.contains(INPAGE_IND)) { // InPage
						if ('CPM'.equalsIgnoreCase(ci.ADvendio__Billing_category__c) && ci.ADvendio__Rate_Discount_4_Name__c != 'Positionsrabatt Natural') {
							if (ci.SomDig_Naturalrabatt__c != mc.SomDig_Naturalrabatt_Inpage__c && mc.SomDig_Naturalrabatt_Inpage__c != oldCampaignMap.get(mc.Id).SomDig_Naturalrabatt_Inpage__c) {
								ci.SomDig_Naturalrabatt__c				= mc.SomDig_Naturalrabatt_Inpage__c;
								ci										= Adv_CampaignItem_Naturalrabatt.setNaturalrabatt(ci);
								ciUpdate.ADvendio__SurchargeB3__c		= ci.ADvendio__SurchargeB3__c;
								ciUpdate.ADvendio__SurchargeB3Abs__c	= ci.ADvendio__SurchargeB3Abs__c;
								ciUpdate.ADvendio__Quantity__c			= ci.ADvendio__Quantity__c;
								ciUpdate.SomDig_Naturalrabatt__c		= ci.SomDig_Naturalrabatt__c;
								changed = true;
							}
						}
						if (ci.ADvendio__Rate_Discount_2_custom__c != mc.SomDig_Kundenrabatt_InPage__c && mc.SomDig_Kundenrabatt_InPage__c != oldCampaignMap.get(mc.Id).SomDig_Kundenrabatt_InPage__c) { // Kundenrabatt changed
							ciUpdate.ADvendio__Rate_Discount_2_custom__c	= mc.SomDig_Kundenrabatt_InPage__c;
							changed = true;
						}
						if (ci.ADvendio__Rate_Discount_4__c != mc.SomDig_Sonderrabatt_InPage__c && mc.SomDig_Sonderrabatt_InPage__c != oldCampaignMap.get(mc.Id).SomDig_Sonderrabatt_InPage__c) { // Sonderrabatt changed
							if (!sonderRabattNamen.contains(ci.ADvendio__Rate_Discount_4_Name__c)) {
								ciUpdate.ADvendio__Rate_Discount_4__c	   = mc.SomDig_Sonderrabatt_InPage__c;
								changed = true;
							}
						}
					}
				}

				if (ci.ADvendio__Rate_Discount_3_custom__c != mc.SomDig_Agenturrabatt__c && mc.SomDig_Agenturrabatt__c != oldCampaignMap.get(mc.Id).SomDig_Agenturrabatt__c) { // Agency discount changed
					ciUpdate.ADvendio__Rate_Discount_3_custom__c			= mc.SomDig_Agenturrabatt__c;
					changed = true;
				}
				if (changed) { // add campaign-item to the change-list if there are changes
					campaignItemsToUpdate.add(ciUpdate);
				}
			}

			if (!campaignItemsToUpdate.isEmpty()) { // update campaign-items
				update campaignItemsToUpdate;
			}
		}
	}

	/**
	 * Discounts from Commitment should be copied in the fields accordingly while creating.
	 * Called from trigger on ADvendio__Campaign_Item__c before insert
	 * @param newList, list current values
	 */
	public static void setCampaignItemDiscounts(List<ADvendio__Campaign_Item__c> newCampaignItemList) {
		Map<Id, ADvendio__MediaCampaign__c> mediaCampaigns  = new Map<Id, ADvendio__MediaCampaign__c>();

		// store any involved campaign-id
		for (ADvendio__Campaign_Item__c ci : newCampaignItemList) {
			mediaCampaigns.put(ci.ADvendio__Media_Campaign__c, null);
		}

		//store involved campaigns and commitments (ids)
		for (ADvendio__MediaCampaign__c mc : getMediaCampaignData(mediaCampaigns.keySet())) {
			mediaCampaigns.put(mc.Id, mc);
		}

		//copy discounts to new campaign-items
		for (ADvendio__Campaign_Item__c ci : newCampaignItemList) {
			ADvendio__MediaCampaign__c mc   = mediaCampaigns.get(ci.ADvendio__Media_Campaign__c);

			if (ci.SomDig_MediagattungsDifferenzierungName__c != null) {

				if (ci.SomDig_MediagattungsDifferenzierungName__c.contains(INSTREAM_IND)) { // InStream
					if (ci.ADvendio__Rate_Discount_2_custom__c == null) {
						ci.ADvendio__Rate_Discount_2_custom__c  = mc.SomDig_Kundenrabatt_InStream__c;
					}
					if (ci.ADvendio__Rate_Discount_4__c == null) {
						ci.ADvendio__Rate_Discount_4__c		 = mc.SomDig_Sonderrabatt_InStream__c;
					}
					if (ci.ADvendio__RateDiscount2Name__c == null) {
						ci.ADvendio__RateDiscount2Name__c	   = INSTREAM_IND;
					}
					if (ci.ADvendio__Rate_Discount_4_Name__c == null) {
						ci.ADvendio__Rate_Discount_4_Name__c	= INSTREAM_IND;
					}
				}

				if (ci.SomDig_MediagattungsDifferenzierungName__c.contains(INPAGE_IND)) { // InPage
					/*if (ci.SomDig_Naturalrabatt__c == null) {
						if ('CPM'.equalsIgnoreCase(ci.ADvendio__Billing_category__c) && ci.ADvendio__Rate_Discount_4_Name__c != 'Positionsrabatt Natural') {
							ci.SomDig_Naturalrabatt__c			= mc.SomDig_Naturalrabatt_Inpage__c;
							ci									= Adv_CampaignItem_Naturalrabatt.setNaturalrabatt(ci);
						}
					}*/
					if (ci.ADvendio__Rate_Discount_2_custom__c == null) {
						ci.ADvendio__Rate_Discount_2_custom__c  = mc.SomDig_Kundenrabatt_InPage__c;
					}
					if (ci.ADvendio__Rate_Discount_4__c == null) {
						ci.ADvendio__Rate_Discount_4__c		 = mc.SomDig_Sonderrabatt_InPage__c;
					}
					if (ci.ADvendio__RateDiscount2Name__c == null) {
						ci.ADvendio__RateDiscount2Name__c	   = INPAGE_IND;
					}
					if (ci.ADvendio__Rate_Discount_4_Name__c == null) {
						ci.ADvendio__Rate_Discount_4_Name__c	= INPAGE_IND;
					}
				}
			}

			if (ci.ADvendio__Rate_Discount_3_custom__c == null) {
				ci.ADvendio__Rate_Discount_3_custom__c		  = mc.SomDig_Agenturrabatt__c;
			}
		}
			/* warum?
		List<ADvendio__MediaCampaign__c> mediaCampaignUpdates   = new List<ADvendio__MediaCampaign__c>();
		for (ADvendio__MediaCampaign__c mc : mediaCampaigns.values()) {
			if (commitments.containsKey(mc.SomDig_Commitment__c)) {
				tranCommitmentToMediaCamp(commitments.get(mc.SomDig_Commitment__c), mc);
				mediaCampaignUpdates.add(mc);
			}
		}


		if (!mediaCampaignUpdates.isEmpty()) {
			update mediaCampaignUpdates;
		}*/
	}


	/**
	 * Scan the overall edit screen to find Field Id in metadata
	 * The field must be put into page layout to get pre-populated
	 * @reference: https://force201.wordpress.com/2012/01/22/hack-to-find-field-ids-allows-a-default-ui-new-page-to-be-pre-populated/
	 * @param comm, source Commitment record
	 * @param mediaCamp, related MediaCampaign record
	 * @return mapping field Id to value
	 */
	private static Map<String, String> createDefaultValues(SomDig_Commitment__c comm, ADvendio__MediaCampaign__c mediaCamp) {
		final Set<String> LOOKUP_FLDS = new Set<String>{'ADvendio__Agency__c', 'ADvendio__Account__c', 'SomDig_Commitment__c', 'SomDig_WtAgBeziehung__c'};
		String requiredHTML = '<span class=\"assistiveText\">*</span>';
		// Obtain the magic ids
		PageReference p = new PageReference('/' + PREFIX_MEDIA_CAMP + '/e?nooverride=1');
		// Running test won't go further code execution after getContent()
		String html = Test.isRunningTest() ? Adv_CampaignItem_Commitment_Test.mockEditPageBody : p.getContent().toString();

		Map<String, String> labelToId = new Map<String, String>();
		Matcher m = Pattern.compile('<label for="(.*?)">(<span class="requiredMark">\\*</span>)?(.*?)</label>').matcher(html);
		while (m.find()) {
			String label = m.group(3);
			String id = m.group(1);
			labelToId.put(label.replace(requiredHTML, ''), id);
		}
		// Relate the magic ids to the SObject fields
		Map<String, String> params = new Map<String, String>();
		for (SObjectField field : ADvendio__MediaCampaign__c.SObjectType.getDescribe().fields.getMap().values()) {
			Object value = mediaCamp.get(field);
			if (value != null) {
				DescribeFieldResult f = field.getDescribe();
				String label = f.getLabel();
				String fname = f.getName();
				if (labelToId.containsKey(label)) {
					String valueAsString = '';
					if (f.getType() == DisplayType.Date) {
						valueAsString = ((Date) value).format();
					} else if (f.getType() == DisplayType.Datetime) {
						valueAsString = ((Datetime) value).format();
					} else if (f.getType() == DisplayType.Boolean) {
						valueAsString = ((Boolean) value) ? '1' : '0';
					} else if (LOOKUP_FLDS.contains(fname)) {
						String idValue = '';
						if (fname == 'ADvendio__Agency__c') {
							valueAsString = comm.SomDig_WtAgBeziehung__r.SomDig_Agentur__r.Name;
							idValue = comm.SomDig_WtAgBeziehung__r.SomDig_Agentur__c;
						} else if (fname == 'ADvendio__Account__c') {
							valueAsString = comm.SomDig_WtAgBeziehung__r.SomDig_Werbetreibender__r.Name;
							idValue = comm.SomDig_WtAgBeziehung__r.SomDig_Werbetreibender__c;
						} else if (fname == 'SomDig_Commitment__c') {
							valueAsString = comm.Name;
							idValue = String.valueOf(value);
						} else if (fname == 'SomDig_WtAgBeziehung__c') {
							valueAsString = comm.SomDig_WtAgBeziehung__r.Name;
							idValue = String.valueOf(value);
						}
						params.put(labelToId.get(label) + '_lkid', idValue);
					} else if (f.getType() == DisplayType.Double || f.getType() == DisplayType.Currency || f.getType() == DisplayType.Percent) {
						valueAsString = ClsHelper.formatDecimal((Decimal)value, 2, /*Userinfo.getLocale()*/ 'en_US');
					} else {
						valueAsString = String.valueOf(value);
					}
					params.put(labelToId.get(label), valueAsString);
				}
			}
		}
		return params;
	}

	/**
	 * For the case if by a campaign item, the "Individual Gesamtrabatt Konsekutiv" is great than the "Commitment Gesamtrabatt Konsekutiv",
	 * this campaign item has to be approved.
	 * @param campItem, current Campaign Item
	 * @param campItem, current Campaign Item
	 * @return decimal not null
	 */
	private static Boolean campaignItemRequiresApproval(ADvendio__Campaign_Item__c campItem, ADvendio__MediaCampaign__c mediaCamp) {
		Decimal rab2	= campItem.ADvendio__Rate_Discount_2_custom__c == null ? 0 : campItem.ADvendio__Rate_Discount_2_custom__c;
		Decimal rab3	= campItem.ADvendio__Rate_Discount_3_custom__c == null ? 0 : campItem.ADvendio__Rate_Discount_3_custom__c;
		Decimal rab4	= campItem.ADvendio__Rate_Discount_4__c;

		Decimal valIndividuellGK =  1 - (discountRestValue(rab2) *
										discountRestValue(rab3) *
										discountRestValue(rab4));

		Decimal valCommitmentGK = 0;

		if (campItem.SomDig_MediagattungsDifferenzierungName__c != null) {
			if (campItem.SomDig_MediagattungsDifferenzierungName__c.contains(INPAGE_IND)) {

				if( rab2 >= 65 && rab2 > mediaCamp.SomDig_Kundenrabatt_InPage__c ||
					rab3 >= 65 && rab3 > mediaCamp.SomDig_Agenturrabatt__c ||
					rab4 >= 65 && rab4 > mediaCamp.SomDig_Sonderrabatt_InPage__c) {

					return true;
				}

				valCommitmentGK =	   1 - (discountRestValue(mediaCamp.SomDig_Kundenrabatt_InPage__c) *
											discountRestValue(mediaCamp.SomDig_Agenturrabatt__c) *
											discountRestValue(mediaCamp.SomDig_Sonderrabatt_InPage__c));
			}

			if (campItem.SomDig_MediagattungsDifferenzierungName__c.contains(INSTREAM_IND)) {

				if( rab2 >= 65 && rab2 > mediaCamp.SomDig_Kundenrabatt_InStream__c ||
					rab3 >= 65 && rab3 > mediaCamp.SomDig_Agenturrabatt__c ||
					rab4 >= 65 && rab4 > mediaCamp.SomDig_Sonderrabatt_InStream__c) {

					return true;
				}

				valCommitmentGK =	   1 - (discountRestValue(mediaCamp.SomDig_Kundenrabatt_InStream__c) *
											discountRestValue(mediaCamp.SomDig_Agenturrabatt__c) *
											discountRestValue(mediaCamp.SomDig_Sonderrabatt_InStream__c));
			}
		}

		return valIndividuellGK > valCommitmentGK;

	}

	/**
	 * Make appropriate value
	 * @param val, Decimal value
	 * @return decimal not null
	 */
	private static Decimal discountRestValue(Decimal val) {

		return 1-decValueOf(val)/100;
	}

	/**
	 * Make appropriate value
	 * @param val, Decimal value
	 * @return decimal not null
	 */
	private static Decimal decValueOf(Decimal val) {
		return val == null ? 0 : val;
	}

	/**
	 * Query SomDig_Commitment__c records, should not be invoked in loop
	 * @param commIds, record Ids
	 * @return SomDig_Commitment__c records
	 */
	private static Map<Id, SomDig_Commitment__c> getCommitmentsData(Set<Id> commIds) {
		return new Map<Id, SomDig_Commitment__c> ([Select Name, SomDig_Kundenrabatt_InPage__c, SomDig_Kundenrabatt_InStream__c, SomDig_Agentur_Rabatt__c,
				SomDig_Sonderrabatt_InPage__c, SomDig_Sonderrabatt_InStream__c, SomDig_Naturalrabatt_Inpage__c,
				SomDig_Agentur__c, SomDig_Werbetreibende__c, SomDig_WtAgBeziehung__c, SomDig_WtAgBeziehung__r.Name,
				SomDig_WtAgBeziehung__r.SomDig_Werbetreibender__c, SomDig_WtAgBeziehung__r.SomDig_Werbetreibender__r.Name,
				SomDig_WtAgBeziehung__r.SomDig_Agentur__c, SomDig_WtAgBeziehung__r.SomDig_Agentur__r.Name
				From SomDig_Commitment__c
			  Where Id IN: commIds]);
	}

	/**
	 * Query ADvendio__MediaCampaign__c records, should not be invoked in loop
	 * @param campIds, record Ids
	 * @return ADvendio__MediaCampaign__c records
	 */
	private static List<ADvendio__MediaCampaign__c> getMediaCampaignData(Set<Id> mcIds) {
		return [SELECT Id, Name, SomDig_Commitment__c, SomDig_WtAgBeziehung__c,
				SomDig_Agenturrabatt__c, SomDig_Sonderrabatt_InPage__c,
				SomDig_Sonderrabatt_InStream__c, SomDig_Naturalrabatt_Inpage__c, ADvendio__Agency__c,
				SomDig_Kundenrabatt_InPage__c, SomDig_Kundenrabatt_InStream__c,
				ADvendio__Account__c, OwnerId, ADvendio__IsApproved__c FROM ADvendio__MediaCampaign__c WHERE Id IN: mcIds];
	}

	/**
	 * Transfer Commitment data to MediaCampaign Item
	 * @param comm, SomDig_Commitment__c record
	 * @param mediaCamp, ADvendio__MediaCampaign__c record
	 */
	public static void tranCommitmentToMediaCamp(SomDig_Commitment__c comm, ADvendio__MediaCampaign__c mediaCamp) {
		mediaCamp.SomDig_Kundenrabatt_InPage__c	 = comm.SomDig_Kundenrabatt_InPage__c;
		mediaCamp.SomDig_Kundenrabatt_InStream__c   = comm.SomDig_Kundenrabatt_InStream__c;
		mediaCamp.SomDig_Agenturrabatt__c	  		= comm.SomDig_Agentur_Rabatt__c;
		mediaCamp.SomDig_Sonderrabatt_InPage__c	 = comm.SomDig_Sonderrabatt_InPage__c;
		mediaCamp.SomDig_Sonderrabatt_InStream__c   = comm.SomDig_Sonderrabatt_InStream__c;
		mediaCamp.SomDig_Naturalrabatt_Inpage__c	= comm.SomDig_Naturalrabatt_Inpage__c;
		mediaCamp.ADvendio__Agency__c			   = comm.SomDig_WtAgBeziehung__r.SomDig_Agentur__c;//comm.SomDig_Agentur__c;
		mediaCamp.ADvendio__Account__c			  = comm.SomDig_WtAgBeziehung__r.SomDig_Werbetreibender__c;//comm.SomDig_Werbetreibende__c;
		mediaCamp.SomDig_Commitment__c			  = comm.Id;
		mediaCamp.SomDig_WtAgBeziehung__c		   = comm.SomDig_WtAgBeziehung__c;
	}

	/**
	 * check wether MediaCampaign discounts exeed Commitment discounts
	 * @param comm, SomDig_Commitment__c record
	 * @param mediaCamp, ADvendio__MediaCampaign__c record
	 * @return boolean - false if campaign discoiunst fit commitment discounts; true otherwise
	 */
	private static boolean compareDiscountsWithCommitment(SomDig_Commitment__c comm, ADvendio__MediaCampaign__c mediaCamp) {
		if (mediaCamp.SomDig_Kundenrabatt_InPage__c	 > comm.SomDig_Kundenrabatt_InPage__c ||
			mediaCamp.SomDig_Kundenrabatt_InStream__c   > comm.SomDig_Kundenrabatt_InStream__c ||
			mediaCamp.SomDig_Agenturrabatt__c	 		> comm.SomDig_Agentur_Rabatt__c ||
			mediaCamp.SomDig_Sonderrabatt_InPage__c	 > comm.SomDig_Sonderrabatt_InPage__c ||
			mediaCamp.SomDig_Sonderrabatt_InStream__c   > comm.SomDig_Sonderrabatt_InStream__c ||
			mediaCamp.SomDig_Naturalrabatt_Inpage__c	> comm.SomDig_Naturalrabatt_Inpage__c
			) {
				return true;
			}
		return false;
	}
}