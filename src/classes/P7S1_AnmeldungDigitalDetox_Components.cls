public class P7S1_AnmeldungDigitalDetox_Components {

    private final String DEFAULT_LANGUAGE = 'de_DE';

    private String feedbackCode;

    public Boolean isSelected { get; set;}

    public String language { get; set; }

    public String eigeneSnowboardschuheVal { get; set; }
    public String eigenerSnowboardVal { get; set;}
    public String skischuheSnowboardschuheVal { get; set; }
    public String skistoeckeVal { get; set; }
    public String skiSnowboardVal{ get; set; }
    public Boolean isdetails { get; set; }
    public String eishockeyVal { get; set; }
    public String eisstockVal { get; set; }
	
    /* Added in Dezember 2016 */
    public String teilnehmerkreis  { get; set; }
    public String essen { get; set; }
    // public String anreise { get; set; }
    // public Boolean shuttleBus { get; set; }
    public String parkplatz { get; set; }
    

    /******/
    
    public P7S1_B2BAktionsmitgliederFeedback__c sobjectRecord {
      get {
        if (sobjectRecord == null) {
           try {
               
             sobjectRecord = [
              SELECT ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,CurrencyIsoCode,Id,
                     LastModifiedById,LastModifiedDate,Name,OwnerId,P7S1_Anrede__c,P7S1_Contact__c,P7S1_DatenschutzbedingungenAkzeptiert__c,
                     P7S1_EMail__c,P7S1_EventTeilnahme__c,P7S1_Firma__c,P7S1_Mobil__c,P7S1_Name__c,P7S1_Ort__c,
                     P7S1_PLZ__c,P7S1_Registrierungscode__c,P7S1_Strasse__c, P7S1_BonuskartenNr__c,
                     P7S1_Eishockey__c, P7S1_Eisstock__c, P7S1_Fluggesellschaft__c, P7S1_Abflugort__c,
                     P7S1_SkiSnowboard__c, P7S1_SkischuheSnowboardschuhe__c,
                     P7S1_Skistoecke__c,  P7S1_Veranstaltungsort__c, P7S1_Vorname__c,
                     P7S1_Snowboarder__c,P7S1_Skifahrer__c,
                     P7S1_Rechnungsadresse__c, P7S1_AbweichendeRechnungsadresse__c, P7S1_EigeneAnreise__c, P7S1_Gewicht__c,
                     P7S1_Koerpergroesse__c, P7S1_Schuhgrosse__c, P7S1_ZustimmungKosten__c, P7S1_LanguageCode__c, P7S1_Status__c, P7S1_B2BAktionsmitgliedID__c,
                     P7S1_AnredeBrief__c, P7S1_EigenerSnowboard__c, P7S1_EigeneSnowboardschuhe__c, P7S1_AnredeDynLanguage__c, P7S1_MobilTeilnehmerkreis__c, P7S1_Essen__c, P7S1_ShuttleBus__c,
                 P7S1_Parkplatz__c

              FROM P7S1_B2BAktionsmitgliederFeedback__c
              WHERE P7S1_Registrierungscode__c =: code
              AND P7S1_EMail__c =: email
              LIMIT 1
            ];

            language = sobjectRecord.P7S1_LanguageCode__c;
          } catch (Exception ex) {
            sobjectRecord = new P7S1_B2BAktionsmitgliederFeedback__c();
            sobjectRecord.P7S1_Registrierungscode__c = apexpages.currentpage().getparameters().get('code');
            sobjectRecord.P7S1_EMail__c = apexpages.currentpage().getparameters().get('email');
            language = DEFAULT_LANGUAGE;
          }
        }
        return sobjectRecord;
      }
      set;
    }

     public Boolean initialized = false;

    public String code {
        get;
        set {
            code = value;
            if (!initialized) {
                initialized = true;
            }
        }
    }

    public String email {
        get;
        set {
            email = value;
        }

    }

    public P7S1_AnmeldungDigitalDetox_Components() {

      try {

        System.debug('!!!!------IN CONTROLLER----------');

        feedbackCode = apexpages.currentpage().getparameters().get('code');
        String campaignMemberId = apexpages.currentpage().getparameters().get('campaignMemberId');
        if (String.isNotBlank(campaignMemberId)) {
            campaignMemberId = EncodingUtil.base64Decode(campaignMemberId).toString();
        	campaignMemberId = campaignMemberId.substring(0, 15);
        }
        if (String.isNotBlank(feedbackCode) || String.isNotBlank(campaignMemberId)) {
          sobjectRecord = [
            SELECT ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,CurrencyIsoCode,Id,
                     LastModifiedById,LastModifiedDate,Name,OwnerId,P7S1_Anrede__c,P7S1_Contact__c,P7S1_DatenschutzbedingungenAkzeptiert__c,
                     P7S1_EMail__c,P7S1_EventTeilnahme__c,P7S1_Firma__c,P7S1_Mobil__c,P7S1_Name__c,P7S1_Ort__c,
                     P7S1_PLZ__c,P7S1_Registrierungscode__c,P7S1_Strasse__c, P7S1_BonuskartenNr__c,
                     P7S1_Eishockey__c, P7S1_Eisstock__c, P7S1_Fluggesellschaft__c, P7S1_Abflugort__c,
                     P7S1_SkiSnowboard__c, P7S1_SkischuheSnowboardschuhe__c,
                     P7S1_Skistoecke__c,  P7S1_Veranstaltungsort__c, P7S1_Vorname__c,
                     P7S1_Snowboarder__c,P7S1_Skifahrer__c,
                     P7S1_Rechnungsadresse__c, P7S1_AbweichendeRechnungsadresse__c, P7S1_EigeneAnreise__c, P7S1_Gewicht__c,
                     P7S1_Koerpergroesse__c, P7S1_Schuhgrosse__c, P7S1_ZustimmungKosten__c, P7S1_Status__c, P7S1_B2BAktionsmitgliedID__c, P7S1_AnredeBrief__c,
              		 P7S1_EigenerSnowboard__c, P7S1_EigeneSnowboardschuhe__c, P7S1_AnredeDynLanguage__c, P7S1_MobilTeilnehmerkreis__c, P7S1_Essen__c, P7S1_ShuttleBus__c, 
              		 P7S1_Parkplatz__c  
              FROM P7S1_B2BAktionsmitgliederFeedback__c
              WHERE P7S1_Registrierungscode__c =: feedbackCode OR P7S1_B2BAktionsmitgliedID__c = :campaignMemberId
              LIMIT 1
          ];
        }
          
        this.teilnehmerkreis = sobjectRecord.P7S1_MobilTeilnehmerkreis__c;
        this.essen = sobjectRecord.P7S1_Essen__c != null ? sobjectRecord.P7S1_Essen__c : System.Label.P7S1_VIRTUALTHEMOUNTAIN_DETAIL_Essen;
		this.parkplatz = sobjectRecord.P7S1_Parkplatz__c;  
          
      } catch (Exception ex) {
         this.sobjectRecord = new P7S1_B2BAktionsmitgliederFeedback__c();
      }

      isdetails = false;

     }

    
    /* For the Radio Option Ja/Nein on page 1
		"Meine Mobile-Nummer darf an den internen Teilnehmerkreis kommuniziert werden?"
	*/
  	public List<SelectOption> getItems() {
 	 	List<SelectOption> options = new List<SelectOption>();
 	 	options.add(new SelectOption('Ja','Ja'));
 	 	options.add(new SelectOption('Nein','Nein'));
 	 	return options;
  	}
    public String getTeilnehmerkreis() {
        return teilnehmerkreis;
    }
    public void setTeilnehmerkreis(String teilnehmerkreis) { this.teilnehmerkreis = teilnehmerkreis; }
    
    
    /* For the Radio Option Vegetarisch/Vegan on page 4 */
    public List<SelectOption> getEssenItems() {
 	 	List<SelectOption> options = new List<SelectOption>();
 	 	options.add(new SelectOption('Trifft nicht zu.',System.Label.P7S1_VIRTUALTHEMOUNTAIN_DETAIL_Essen ));
        options.add(new SelectOption('Vegetarisch',System.Label.P7S1_VIRTUALTHEMOUNTAIN_DETAIL_Vegetarisch ));
 	 	options.add(new SelectOption('Vegan',System.Label.P7S1_VIRTUALTHEMOUNTAIN_DETAIL_Vegan));
 	 	return options;
  	}
    
    /* For the Radio Option Anreise */
    public List<SelectOption> getAnreiseItems() {
 	 	List<SelectOption> options = new List<SelectOption>();
 	 	options.add(new SelectOption('false',System.Label.P7S1_VIRTUALTHEMOUNTAIN_DETAIL_ShuttleBus));
 	 	options.add(new SelectOption('true',System.Label.P7S1_VIRTUALTHEMOUNTAIN_DETAIL_SelbstorganisationAnreiseAbreise ));
 	 	return options;
  	}

    /* For the Radio Option Parkplatz */
    public List<SelectOption> getParkplatzItems() {
 	 	List<SelectOption> options = new List<SelectOption>();
 	 	options.add(new SelectOption('Ja','Ja'));
 	 	options.add(new SelectOption('Nein','Nein'));
 	 	return options;
  	}
    
    public void submit() {
        //do nothing in Apex
    }
        
    public PageReference updateRecord() {
        if (isDetails) {
          this.sobjectRecord.P7S1_Eishockey__c = eishockeyVal;
          this.sobjectRecord.P7S1_Eisstock__c =eisstockVal;
          this.sobjectRecord.P7S1_EigeneSnowboardschuhe__c = eigeneSnowboardschuheVal;
          this.sobjectRecord.P7S1_EigenerSnowboard__c = eigenerSnowboardVal;
          this.sobjectRecord.P7S1_SkischuheSnowboardschuhe__c = skischuheSnowboardschuheVal;
          this.sobjectRecord.P7S1_Skistoecke__c = skistoeckeVal;
          this.sobjectRecord.P7S1_SkiSnowboard__c = skiSnowboardVal;
          isDetails = false;
        }
        
        this.sobjectRecord.P7S1_MobilTeilnehmerkreis__c = this.teilnehmerkreis;
        this.sobjectRecord.P7S1_Essen__c  				= this.essen;
        // this.sobjectRecord.P7S1_Veranstaltungsort__c  	= this.anreise == 'true' ? true : false; 
        //this.sobjectRecord.P7S1_ShuttleBus__c 		 	= this.shuttleBus;//  == 'true' ? true : false; 
        this.sobjectRecord.P7S1_Parkplatz__c 		 	= this.parkplatz; 
            
        try {
            upsert this.sobjectRecord;
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        
        return null;
    }

    public PageReference updateRecordZusage() {
        this.sobjectRecord.P7S1_Status__c = 'Zusage';
        update this.sobjectRecord;

        List<CampaignMember> listCM = new List<CampaignMember>([select ID, Status from CampaignMember where ID = :this.sobjectRecord.P7S1_B2BAktionsmitgliedID__c]);

        if (listCM.size() > 0) {
            listCM[0].Status = 'Zusage';
        	//update listCM;
        }

        system.debug('** CM : ' + listCM);

        return null;
    }



    public PageReference searchrecord() {
      isSelected = [SELECT COUNT() FROM P7S1_B2BAktionsmitgliederFeedback__c WHERE P7S1_Registrierungscode__c =: sobjectRecord.P7S1_Registrierungscode__c AND P7S1_EMail__c =: sobjectRecord.P7S1_EMail__c] > 0;
      return null;
    }
}