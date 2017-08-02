({
	checkValid : function(component) {
	  var detailOppCmp 	= component.find('detailOppCmp');
		var detailPipeCmp 	= component.find('detailPipeCmp');
		var detailAppCmp 	= component.find('detailApprovalCmp');

		detailOppCmp.checkDetailOppCmpValid();
		detailPipeCmp.checkDetailPipeCmpValid();
		detailAppCmp.checkDetailAppCmpValid();

    }
})