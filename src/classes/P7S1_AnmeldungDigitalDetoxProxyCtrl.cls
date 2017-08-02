public class P7S1_AnmeldungDigitalDetoxProxyCtrl {
    
    public PageReference goNext() {
        String pageLink = ApexPages.currentPage().getUrl();
        pageLink = pageLink.replace('P7S1_AnmeldungDigitalDetoxProxy'.toLowerCase(), 'P7S1_AnmeldungDigitalDetox');
        System.debug(pagelink);
        PageReference p = new PageReference(pageLink);
        //return new PageReference(pageLink);
        return p;
    }

}