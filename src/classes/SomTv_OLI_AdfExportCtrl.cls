public with sharing class SomTv_OLI_AdfExportCtrl
{

    public class SomTv_OLI_AdfExportCtrl_Exception extends System.Exception {}

    public static final String DEFAULT_STYLE = 'std';
    public static final String READHEADING_STYLE = 'redHeading';
    public static final String FIRSTCOLUMN_STYLE = 'firstColumn';
    public static final String GREYLINE_STYLE = 'greyLine';

    public static final String SPREADSHEET_NAMESPACE = 'ss'; 

    public static final String HEAD_RED = '#FF0033';
    public static final String LIGHTER_GREY = '#FFFFFF';
    public static final String DARKER_GREY = '#C4C9CF';


    private SomTv_OLI_AdfExportData dataContainer;
    
    public SomTv_OLI_AdfExportCtrl(Id adfProjectId)
    {
        init(adfProjectId);
    }
    
    public SomTv_OLI_AdfExportCtrl(ApexPages.StandardController stdCtrl)
    {
        init(stdCtrl.getRecord().Id);
    }
    
    private void init(Id adfProjectId)
    {   
        this.dataContainer = new SomTv_OLI_AdfExportData(adfProjectId);
    }
    
    public String content {get{return xlsxContent();}}
    
    private String xlsxContent()
    {
        Base_ExcelXmlExport xls = new FactsheetExport(this.dataContainer);
        return xls.export();
    }
    

    /**
     * abstract class to separate the exporting logic from the calling logic
    **/
    private abstract class Base_ExcelXmlExport 
    {
        protected SomTv_OLI_AdfExportData data;
       
        public abstract String export();
    }

    /**
     * This class generates the actual Export combining the classes of the components
    **/ 
    public virtual class FactsheetExport extends Base_ExcelXmlExport
    {

        private Xmlstreamwriter xmlStream;

        public FactsheetExport(SomTv_OLI_AdfExportData data)
        {
            this.data = data;
            this.xmlStream = new Xmlstreamwriter();
        }

        public override String toString()
        {
            P7S1_ExcelExportUtils.WorkbookExport workbookExport = new P7S1_ExcelExportUtils.WorkbookExport(this.xmlStream);
            WorkbookExport.addStyle(new DefaultStyling(this.xmlStream));
            WorkbookExport.addStyle(new RedHeading(this.xmlStream));
            WorkbookExport.addStyle(new FirstColumn(this.xmlStream));
            WorkbookExport.addStyle(new GreyLine(this.xmlStream));
            WorkbookExport.addWorksheet(new FactsheetContent_Worksheet(this.data, this.xmlStream));
            workbookExport.addToXmlStream();
            return xmlStream.getXmlString();
        }

        public virtual override String export()
        {
            return this.toString();
        }

    }  

//-----------------------------
// Components of the Export
//-----------------------------

    public virtual class FactsheetContent_Worksheet extends P7S1_ExcelExportUtils.WorksheetExport
    {
        private Set<Integer> highlightedLines = new Set<Integer> {2, 9, 16, 24, 45, 48, 53};
        private SomTv_OLI_AdfExportData data;

        public FactsheetContent_Worksheet(SomTv_OLI_AdfExportData data, Xmlstreamwriter xmlFactsheetWriter)
        {
            super('Factsheet', xmlFactsheetWriter);
            this.data = data;
        }

        public override void addContent()
        {
            //Table-Start
            this.xmlStream.writeStartElement(NULL, 'ss:Table',NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'x:FullColumns', '0');
            this.xmlStream.writeAttribute(NULL, NULL, 'x:FullRows', '0');

            for(Integer col = 0; col < data.count+1 ; col++)
            {
                //Add column headers
                this.xmlStream.writeEmptyElement(NULL, 'ss:Column', NULL);
                this.xmlStream.writeAttribute(NULL, NULL, 'ss:AutoFitWidth', '0');
                this.xmlStream.writeAttribute(NULL, NULL, 'ss:Width', '250');
            }

            //Start of first line (with the red 'FACTSHEET')
            this.xmlStream.writeStartElement(NULL, 'ss:Row', NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Height', '27');
            this.xmlStream.writeStartElement(NULL, 'ss:Cell', NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:StyleID', READHEADING_STYLE);
            getDataElement('FACTSHEET', this.xmlStream).addToXmlStream();

            this.xmlStream.writeEndElement();

            for(Integer col = 1; col < data.count+1 ; col++)
            {
                this.xmlStream.writeStartElement(NULL, 'ss:Cell', NULL);
                this.xmlStream.writeEndElement();
            }
            //End of first line
            this.xmlStream.writeEndElement();

            //Start of data rows
            Integer rowCounter = 2;
            for(List<Object> cells : data.records)
            {

                Boolean isHighlighted = this.highlightedLines.contains(rowCounter);

                //Start of Row
                this.xmlStream.writeStartElement(NULL, 'ss:Row', NULL);
                if(isHighlighted) this.xmlStream.writeAttribute(NULL, NULL, 'ss:Height', '22');

                System.Iterator<Object> cellIt = cells.iterator();
                // add cell of first column
                if(cellIt.hasNext())
                {
                    Object value = cellIt.next();
                    this.xmlStream.writeStartElement(NULL, 'ss:Cell', NULL);
                    this.xmlStream.writeAttribute(NULL, NULL, 'ss:StyleID', isHighlighted ? GREYLINE_STYLE : FIRSTCOLUMN_STYLE);
                    P7S1_ExcelExportUtils.getDataElement(value, this.xmlStream).addToXmlStream();
                    this.xmlStream.writeEndElement();

                }
                // add all other cells
                while(cellIt.hasNext())
                {
                    Object value = cellIt.next();
                    this.xmlStream.writeStartElement(NULL, 'ss:Cell', NULL);
                    this.xmlStream.writeAttribute(NULL, NULL, 'ss:StyleID', isHighlighted ? GREYLINE_STYLE : DEFAULT_STYLE);
                    P7S1_ExcelExportUtils.getDataElement(value, this.xmlStream).addToXmlStream();
                    this.xmlStream.writeEndElement();

                }
                //End of Row
                this.xmlStream.writeEndElement();
                rowCounter += 1;
                
            }
            //Table-End
            this.xmlStream.writeEndElement();       
        }
    }

//-----------------------------
// Defining Styles
//-----------------------------

    public virtual class DefaultStyling extends P7S1_ExcelExportUtils.StyleExport
    {
        public DefaultStyling(Xmlstreamwriter defaultWriter)
        {
            super(DEFAULT_STYLE, defaultWriter);
        }

        public override void addAttributes()
        {
            this.xmlStream.writeEmptyElement(NULL, 'ss:Font', NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Size', '11');
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Bold', '0');
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Color', '#000000');

            this.xmlStream.writeEmptyElement(NULL, 'Interior', NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Color', LIGHTER_GREY);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Pattern', 'Solid');
        }
    }


    public virtual class RedHeading extends P7S1_ExcelExportUtils.StyleExport
    {
        public RedHeading(Xmlstreamwriter xmlWriter)
        {
            super(READHEADING_STYLE, xmlWriter);
        }

        public override void addAttributes()
        {
            this.xmlStream.writeEmptyElement(NULL, 'ss:Font', NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Size', '16');
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Bold', '1');
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Color', '#FFFFFF');

            this.xmlStream.writeEmptyElement(NULL, 'Interior', NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Color', HEAD_RED);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Pattern', 'Solid');

            this.xmlStream.writeEmptyElement(NULL, 'Alignment', NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Vertical', 'Center');
        }
    }

    public virtual class FirstColumn extends P7S1_ExcelExportUtils.StyleExport
    {
        public FirstColumn(Xmlstreamwriter xmlWriter)
        {
            super(FIRSTCOLUMN_STYLE, xmlWriter);
        }

        public override void addAttributes()
        {
            this.xmlStream.writeEmptyElement(NULL, 'ss:Font', NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Size', '11');
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Bold', '1');
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Color', '#000000');

            this.xmlStream.writeEmptyElement(NULL, 'Interior', NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Color', LIGHTER_GREY);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Pattern', 'Solid');
        }
    }

    public virtual class GreyLine extends P7S1_ExcelExportUtils.StyleExport
    {
        public GreyLine(Xmlstreamwriter xmlWriter)
        {
            super(GREYLINE_STYLE, xmlWriter);
        }

        public override void addAttributes()
        {
            this.xmlStream.writeEmptyElement(NULL, 'ss:Font', NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Size', '11');
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Bold', '1');
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Color', '#000000');

            this.xmlStream.writeEmptyElement(NULL, 'Interior', NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Color', DARKER_GREY);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Pattern', 'Solid');

            this.xmlStream.writeEmptyElement(NULL, 'Alignment', NULL);
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Vertical', 'Center');
        }
    }
}