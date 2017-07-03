/**
 * this class contains subclasses provides utilities to create an Excel-XML file according to:
 * Microsoft - XML Spreadsheet Reference: https://msdn.microsoft.com/en-us/library/aa140066(v=office.10).aspx
**/

public class P7S1_ExcelExportUtils
{
    public class cls_P7S1_ExcelExportUtils_Exception extends System.Exception {}

    public abstract class XmlExcelExport_Base
    {
        @TestVisible
        private Xmlstreamwriter privateXmlStream;

        protected Xmlstreamwriter xmlStream {get{return this.privateXmlStream;} private set;}

        public XmlExcelExport_Base(Xmlstreamwriter xmlStream)
        {
            this.privateXmlStream = xmlStream;
        }

        public abstract void addToXmlStream();        
    }

    public virtual class WorkbookExport extends XmlExcelExport_Base
    {
        //private String content;
        protected List<WorksheetExport> worksheets;
        protected List<StyleExport> styles;

        public WorkbookExport(Xmlstreamwriter xmlStream)
        {
            super(xmlStream);
            this.worksheets = new List<WorksheetExport>();
            this.styles = new List<StyleExport>();
        }

        public void addStyle(StyleExport style)
        {
            this.styles.add(style);
        }

        public void addWorksheet(WorksheetExport Worksheet)
        {
            this.worksheets.add(Worksheet);
        }

        public override void addToXmlStream()
        {
            this.xmlStream.writeStartDocument(null, '1.0');
            this.xmlStream.writeProcessingInstruction('mso-application', 'progid="Excel.Sheet"');
            this.xmlStream.writeStartElement(NULL, 'ss:Workbook', NULL);
            this.xmlStream.writeAttribute(NULL,NULL,'xmlns','urn:schemas-microsoft-com:office:spreadsheet');
            this.xmlStream.writeAttribute(NULL,NULL,'xmlns:html','http://www.w3.org/TR/REC-html40');
            this.xmlStream.writeAttribute(NULL,NULL,'xmlns:o','urn:schemas-microsoft-com:office:office');
            this.xmlStream.writeAttribute(NULL,NULL,'xmlns:ss','urn:schemas-microsoft-com:office:spreadsheet');
            this.xmlStream.writeAttribute(NULL,NULL,'xmlns:x','urn:schemas-microsoft-com:office:excel');

            
            if(!this.styles.isEmpty())
            {
                this.xmlStream.writeStartElement(NULL, 'ss:Styles', NULL);
                for(StyleExport style : this.styles)
                {
                    style.addToXmlStream();
                }
                this.xmlStream.writeEndElement();
            }
            //this.styles.addToXmlStream();
            
            for(WorksheetExport worksheet : worksheets)
            {
                Worksheet.addToXmlStream();
            }
            this.xmlStream.writeEndDocument();
        }
    }

    public abstract class StyleExport extends XmlExcelExport_Base
    {

        private String styleId;

        public StyleExport(String styleId, Xmlstreamwriter xmlStyleWriter)
        {
            super(xmlStyleWriter);
            this.styleId = styleId;
        }

        public override void addToXmlStream()
        {
            this.xmlStream.writeStartElement(NULL, 'ss:Style', NULL);
            this.xmlStream.writeAttribute(NULL,NULL,'ss:ID',this.styleId);
            this.addAttributes();
            this.xmlStream.writeEndElement();
        }

        public abstract void addAttributes();
    }

    public abstract class WorksheetExport extends XmlExcelExport_Base
    {

        private String name;

        public WorksheetExport(String name, Xmlstreamwriter xmlStream)
        {
            super(xmlStream);
            this.name =  name;
        }

        public abstract void addContent();

        public override void addToXmlStream()
        {
            this.xmlStream.writeStartElement(NULL, 'ss:Worksheet', NULL);
            this.xmlStream.writeAttribute(NULL,NULL,'ss:Name',this.name);
            this.addContent();
            this.xmlStream.writeEndElement();
        }        
    }

    /**
     * This Factory-Method returns the DataElement class which is appopriate to the type of the given value
    **/
    public static DataElement_Base getDataElement(Object value, Xmlstreamwriter xmlWriter)
    {
        if(value instanceOf Integer)
        {
            return new IntegerDataElement(value, xmlWriter);
        }
        if(value instanceOf Decimal)
        {
            return new DecimalDataElement(value, xmlWriter);
        }
        if(value instanceOf Date)
        {
            return new DateDataElement(value, xmlWriter);
        }
        if(value instanceOf String || value instanceOf Boolean)
        {
            return new StringDataElement(value, xmlWriter);
        }
       
        throw new cls_P7S1_ExcelExportUtils_Exception();            
    }

/**
 * @Description Represents a basi
 *
 *
 *
**/
    public abstract class DataElement_Base extends XmlExcelExport_Base
    {

        public DataElement_Base(Xmlstreamwriter xmlWriter)
        {
            super(xmlWriter);
        }

        public abstract void addAttributeAndValue();

        public override void addToXmlStream()
        {
            this.xmlStream.writeStartElement(NULL, 'ss:Data', NULL);
            this.addAttributeAndValue();
            this.xmlStream.writeEndElement();
        }
    }

    public virtual class DateDataElement extends DataElement_Base
    {
        private Date value;

        public DateDataElement(Object value, Xmlstreamwriter xmlWriter)
        {
            super(xmlWriter);
            this.value = (Date)value;
        }

        public override void addAttributeAndValue()
        {
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Type', 'String');
            this.xmlStream.writeCharacters(getStringFromDate(this.value));
        }
    }

    public virtual class DecimalDataElement extends DataElement_Base
    {
        private Decimal value;

        public DecimalDataElement(Object value, Xmlstreamwriter xmlWriter)
        {
            super(xmlWriter);
            this.value = (Decimal)value;
        }

        public override void addAttributeAndValue()
        {
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Type', 'String');
            this.xmlStream.writeCharacters(getStringFromNumber(this.value));
        }
    }

    public virtual class IntegerDataElement extends DataElement_Base
    {
        private Integer value;

        public IntegerDataElement(Object value, Xmlstreamwriter xmlWriter)
        {
            super(xmlWriter);
            this.value = (Integer)value;
        }

        public override void addAttributeAndValue()
        {
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Type', 'String');
            this.xmlStream.writeCharacters(getStringFromNumber(this.value));
        }
    }

    public virtual class StringDataElement extends DataElement_Base
    {
        private String value;

        public StringDataElement(Object value, Xmlstreamwriter xmlWriter)
        {
            super(xmlWriter);
            this.value = (String)value;
        }

        public override void addAttributeAndValue()
        {
            this.xmlStream.writeAttribute(NULL, NULL, 'ss:Type', 'String');
            this.xmlStream.writeCharacters(this.value);
        }
    }    

//------------------------------
// formating stuff
//------------------------------

/**
 * @param value Value to be fomated as a german number string
 * @return Number as string in german format
 * 
 *
 * @throws cls_P7S1_ExcelExportUtils_Exception if value is neither Decimal or Integer.
 * @throws cls_P7S1_ExcelExportUtils_Exception if language of the user is neither german or english.
**/
    private static String getStringFromNumber(Object value)
    {
        Boolean isDecimal = value instanceOf Decimal;
        Boolean isInteger = value instanceOf Integer;
        if(!(isDecimal || isInteger))
            throw new cls_P7S1_ExcelExportUtils_Exception('value: ' + value + ' is neither Decimal or Integer.');

        if(UserInfo.getLocale().startsWith('de'))
        {
            if(isInteger) 
                return ((Integer)value).format();
            if(isDecimal) 
                return ((Decimal)value).format();
        }
        if(UserInfo.getLocale().startsWith('en'))
        {
            if(isDecimal) 
                return String.valueOf(value).replace(',','#').replace('.',',').replace('#','.');
            if(isInteger) 
                return String.valueOf(value).replace(',','.');
        }
        
        throw new cls_P7S1_ExcelExportUtils_Exception('Language is not supported: ' + UserInfo.getLocale());
    }


/**
 * @param value Value to be fomated as a date string
 * @return the date  string value
 * 
 *
 * @throws cls_P7S1_ExcelExportUtils_Exception if value is neither Decimal or Integer.
 * @throws cls_P7S1_ExcelExportUtils_Exception if language of the user is neither german or english.
**/
    private static String getStringFromDate(Object value)
    {
        if(value instanceOf Date)
        {
            Date d = Date.valueOf(value);
            String result = (d.day() < 10 ? '0' : '') + String.valueOf(d.day());
            result +='.';
            result += (d.month() < 10 ? '0' : '') + String.valueOf(d.month());
            result +='.'+d.year();
            return result;
        }
        throw new cls_P7S1_ExcelExportUtils_Exception('value: ' + value + ' is not a Date.');
    }
}