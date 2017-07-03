public with sharing class SomTv_OLI_AdfExportData
{

    /*
     * TODO: 
     * FieldMappingHandler umstellen auf interne verwendung von:
     * - List<Schema.SObjectField> (reihenfolge der Felder)
     * - Map<Schema.SObjectField, String> Pfad zum Feld
     */ 
    
    public class FactSheetExportException extends System.Exception{}
    
    private List<OpportunityLineItem> opportunityLineItems;
    public Integer count {get{ return opportunityLineItems.size();} private set;}
    public List<List<Object>> records {get; private Set;}
    public FieldMappingHandler fieldMappingHandler;
    public Id adfProjectId;
    
    public SomTv_OLI_AdfExportData(Id adfProjectId)
    {
        this.adfProjectId = adfProjectId;
        fieldMappingHandler = new ImprovedHardCodedFieldMapper();
        this.opportunityLineItems = (List<OpportunityLineItem>)Database.query(buildQuery());
        this.records = getRecords();
    }
    
    private List<List<Object>> getRecords()
    {
        List<List<Object>> result = new List<List<Object>>();
        for(ExportField exportField : fieldMappingHandler.getFieldsToExport())
        {
            List<Object> fieldValues = new List<Object>();

            fieldValues.add(exportField.fieldLabel);
            for(OpportunityLineItem oli : this.opportunityLineItems)
            {
                fieldValues.add(formatValue(getValue(oli,exportField.fieldPath)));
            }
            result.add(fieldValues);
        }
        return result;
    }

    @TestVisible
    private String buildQuery()
    {
        String query = '';
        query += 'SELECT ';
        query += fieldMappingHandler.getFieldsPaths();  
        query += ' From OpportunityLineItem WHERE ';
        query += 'Opportunity.CloseDate >= '+String.valueOf(Date.newInstance(Date.today().year(), 1, 1));
        query += ' AND Opportunity.CloseDate <= '+ String.valueOf(Date.newInstance(Date.today().year(), 12, 31));
        query += ' AND Opportunity.SomTv_AdFProjekt__c = \''+adfProjectId+'\'';
        query += ' ORDER BY Product2.Name, SomTv_SendeDatumVon__c';
        return query;
    }
    
    public static Object formatValue(Object value)
    {
        if(value == NULL) return ' ';//throw new FactSheetExportException();
        if(Value instanceof String)
        {
            String str = (String)value;
            value = str.replace('<br>', ' ');
        }
        return value;
    }
    
    public static Object getValue(SObject obj, String fieldPath)
    {
        If (fieldPath == NULL) return NULL;
        If (obj == NULL) return NULL;
        
        system.debug('got Path: '+fieldPath);
        if(fieldPath.contains('.'))
        {
            List<String> tempPath = fieldPath.split('\\.',2);
            system.debug('splitting path: '+tempPath);
            SObject referencedRecord = obj.getSObject(tempPath[0]);
            system.debug('referencedRecord: '+referencedRecord);
            return getValue(referencedRecord, tempPath[1]);
        }
        else
        {
            system.debug('getting value from field: '+fieldPath);
            return obj.get(fieldPath);
        }
    }
    
    public abstract class FieldMappingHandler
    {
        public List<String> fieldPaths = new List<String>();
        public Map<String,String> fieldLabels = new Map<String,String>();
        
        public FieldMappingHandler()
        {
            init();
        }

        public abstract String getFieldsPaths();

        public abstract List<ExportField> getFieldsToExport();      
        
        protected abstract void init();
    } 
   
    public virtual class ImprovedHardCodedFieldMapper extends FieldMappingHandler
    {
        protected List<ExportField> fieldsToExport;

        protected override void init()
        {

            this.fieldsToExport = new List<ExportField>();
            this.addFields();
            this.fieldPaths = new List<String>();
            this.fieldLabels = new Map<String,String>();

            for(ExportField fieldWrapper : this.fieldsToExport)
            {
                this.fieldPaths.add(fieldWrapper.path);
                this.fieldLabels.put(fieldWrapper.path, fieldWrapper.label);
            }
        }

        public override String getFieldsPaths()
        {
            return String.join(new List<String>(new Set<String>(this.fieldPaths)), ', ');
        }

        public override List<ExportField> getFieldsToExport()
        {
            return this.fieldsToExport;            
        }

        protected virtual void addFields()
        {
            this.fieldsToExport.add(new ExportField('Opportunity.Account.Name', 'Account Name', True));

            this.fieldsToExport.add(new ExportField('Opportunity.SomTv_MutterOpportunity__r.Name', 'Mutter Opportunity', False));
            this.fieldsToExport.add(new ExportField('SomTv_Kundenprodukt__c', 'Kundenprodukt', False));
            this.fieldsToExport.add(new ExportField('Opportunity.SomTv_Externe_ID__r.Name', 'ProSedi ID buchender Kunde', False));
            this.fieldsToExport.add(new ExportField('Opportunity.SomTv_ProSedi_ID_Rechnungsadresse__r.Name', 'ProSedi ID Rechnungsadresse', False));
            this.fieldsToExport.add(new ExportField('Opportunity.SomTv_Agentur__r.Name', 'Agentur', False));
            this.fieldsToExport.add(new ExportField('Opportunity.SomTv_Beziehung__r.ConnectionReceivedId', 'Beziehung', False));
            this.fieldsToExport.add(new ExportField('Product2.Name', 'Product Name', True));
            this.fieldsToExport.add(new ExportField('SomTv_Sponsoring__c', 'Sponsoring', False));
            this.fieldsToExport.add(new ExportField('SomTv_ContentMarketing__c', 'Content Marketing', False));
            this.fieldsToExport.add(new ExportField('SomTv_NrGoodwill__c', 'NR/Goodwill/Diverse', False));
            this.fieldsToExport.add(new ExportField('SomTv_Geschaeftsart__c', 'Geschäftsart', False));
            this.fieldsToExport.add(new ExportField('SomTv_Tarifart__c', 'Tarifart', False));
            this.fieldsToExport.add(new ExportField('SomTv_Detail_Informationen__c', 'Detail-Informationen', False));
            this.fieldsToExport.add(new ExportField('SomTv_Sender__c', 'Sender', True));
            this.fieldsToExport.add(new ExportField('SomTv_Genre__c', 'Genre', False));
            this.fieldsToExport.add(new ExportField('SomTv_UmfeldFormat__c', 'Umfeld / Format', False));
            this.fieldsToExport.add(new ExportField('SomTv_SendeDatumVon__c', 'Sendedatum von', False));
            this.fieldsToExport.add(new ExportField('SomTv_SendeDatumBis__c', 'Sendedatum bis', False));
            this.fieldsToExport.add(new ExportField('SomTv_SendeZeitVon__c', 'Sendezeit von', False));
            this.fieldsToExport.add(new ExportField('SomTv_SendeZeitBis__c', 'Sendezeit bis', False));
            this.fieldsToExport.add(new ExportField('SomTv_Wochentag__c', 'Wochentag', False));
            this.fieldsToExport.add(new ExportField('SomTv_Sendezeit__c', 'Sendemonat', True));
            this.fieldsToExport.add(new ExportField('SomTv_Ausstrahlung__c', 'Ausstrahlung', False));
            this.fieldsToExport.add(new ExportField('SomTv_Folgen__c', 'Folgen', False));
            this.fieldsToExport.add(new ExportField('Description', 'Beschreibung des Belegpostens', False));
            this.fieldsToExport.add(new ExportField('SomTv_OpenerAnzahl__c', 'Opener Anzahl', False));
            this.fieldsToExport.add(new ExportField('SomTv_OpenerSek__c', 'Opener Sek', False));
            this.fieldsToExport.add(new ExportField('SomTv_CloserAnzahl__c', 'Closer Anzahl', False));
            this.fieldsToExport.add(new ExportField('SOmTv_CloserSek__c', 'Closer Sek', False));
            this.fieldsToExport.add(new ExportField('SomTv_ReminderAnzahl__c', 'Reminder Anzahl', False));
            this.fieldsToExport.add(new ExportField('SomTv_ReminderSek__c', 'Reminder Sek', False));
            this.fieldsToExport.add(new ExportField('SomTv_ScharnierAnzahl__c', 'Scharnier Anzahl', False));
            this.fieldsToExport.add(new ExportField('SomTv_ScharnierSek__c', 'Scharnier Sek', False));
            this.fieldsToExport.add(new ExportField('SomTv_TrailerGesamtlaenge__c', 'Trailer Gesamtlänge', False));
            this.fieldsToExport.add(new ExportField('SomTv_TrailerSponsoringSek12MinRelevant__c', 'Trailer Sponsoring Sek (12-Min relevant)', False));
            this.fieldsToExport.add(new ExportField('SomTv_SplitsSpots__c', 'Split-/Spot-/Trailer-Anzahl', False));
            this.fieldsToExport.add(new ExportField('SomTv_TechnischeLaenge__c', 'Technische Länge', False));
            this.fieldsToExport.add(new ExportField('SomTv_AbzurechnendeLaenge__c', 'Abzurechnende Länge', False));
            this.fieldsToExport.add(new ExportField('SomTv_NrProzent__c', 'NR (%)', False));
        this.fieldsToExport.add(new ExportField('CurrencyIsoCode', 'NR/Goodwill/Diverse in EUR Währung', False));
            this.fieldsToExport.add(new ExportField('SomTv_NrGoodwillInEUR__c', 'NR/Goodwill/Diverse in EUR', False));
        this.fieldsToExport.add(new ExportField('CurrencyIsoCode', 'Verkaufspreis Währung', False));
            this.fieldsToExport.add(new ExportField('UnitPrice', 'Verkaufspreis in EUR', True));
            this.fieldsToExport.add(new ExportField('SomTv_DispoPreisprozent__c', 'Dispo-Preisprozent', False));
        this.fieldsToExport.add(new ExportField('CurrencyIsoCode', 'MB1 (bezahlt) Währung', True));
            this.fieldsToExport.add(new ExportField('SomTv_MB1Bezahlt__c', 'MB1 (bezahlt) in EUR', True));
            this.fieldsToExport.add(new ExportField('BR__c', 'BR (%)', False));
            this.fieldsToExport.add(new ExportField('SomTv_AE_inProzent__c', 'AE (%)', False));
            this.fieldsToExport.add(new ExportField('SomTv_Skonto__c', 'Skonto', False));
        this.fieldsToExport.add(new ExportField('CurrencyIsoCode', 'MN3 Währung', True));
            this.fieldsToExport.add(new ExportField('SomTv_MN3__c', 'MN3 in EUR', True));
            this.fieldsToExport.add(new ExportField('SomTv_Yield__c', 'Yield', False));
            this.fieldsToExport.add(new ExportField('Opportunity.SomTV_Innerhalb_Commitment__c', 'Innerhalb Commitment / Zubuchung', False));
            this.fieldsToExport.add(new ExportField('SomTv_Faktura__c', 'Faktura', False));
            this.fieldsToExport.add(new ExportField('Opportunity.SomTv_Konvergent__c', 'konvergent', False));
            this.fieldsToExport.add(new ExportField('SomTv_Buchungssystem__c', 'Buchungssystem', False));
            this.fieldsToExport.add(new ExportField('SomTv_Umsatzaenderung__c', 'Umsatzänderung', False));
            this.fieldsToExport.add(new ExportField('SomTv_FakturaInfofeld__c', 'Faktura Infofeld', False));
            this.fieldsToExport.add(new ExportField('Opportunity.SomTv_ErlaeuterungGeschaeftsvorfall_del__c', 'Erläuterung Geschäftsvorfall', False));
            this.fieldsToExport.add(new ExportField('Opportunity.SomTv_AdFProjekt__r.SomTv_SomTvSales__r.Name', 'AdFProjekt: Verkäufer SOM-TV Sales', False));
            this.fieldsToExport.add(new ExportField('Opportunity.SomTv_AdFProjekt__r.SomTv_DigitalSales__r.Name', 'AdFProjekt: Verkäufer SOM Digital Sales', False));
            this.fieldsToExport.add(new ExportField('Opportunity.SomTv_AdFProjekt__r.SomTv_AdFConceptAdSales__r.Name', 'AdFProjekt: Verkäufer AdF Concept Sales', False));
            this.fieldsToExport.add(new ExportField('Opportunity.SomTv_AdFProjekt__r.SomTv_AdFProjectManager__r.Name', 'AdFProjekt: AdF Project Manager', False));
            this.fieldsToExport.add(new ExportField('Opportunity.SomTv_AdFProjekt__r.SomTv_AgencyServiceTeam__c', 'AdFProjekt: Agency Service Team', False));
        }

    }

    public class ExportField
    {
        private String fieldPath;
        private String fieldLabel;
        private Boolean fieldIsHighlighted;
        private Object fieldValue;

        public ExportField(String fieldPath, String fieldLabel, Boolean fieldIsHighlighted)
        {
            this.fieldLabel = fieldLabel;
            this.fieldPath = fieldPath;
            this.fieldIsHighlighted = isHighlighted;
        } 

        public Object value{get;set;}
        public String path {get{return fieldPath;} private set;}
        public String label {get{return fieldLabel;} private set;}
        public Boolean isHighlighted {get{return fieldIsHighlighted;} private set;}
    }



}