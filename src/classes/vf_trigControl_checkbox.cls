public class vf_trigControl_checkbox {
        // to store the Apex triggers
    private List<ApexTrigger> lis;
    // objects to use in methods
    private TriggerHelper apexTrigger;
    private Trigger_Control__c customTriggerControl;
    
    // to store the custom wrapper class data of triggers
    public List<TriggerHelper> trigList {get; set;}
    // to get the row number when user interacts using on/off buttons
    public integer rowNumber {get; set;}
    
    public vf_trigControl_checkbox() {
        lis = new List<ApexTrigger>();
        // loading the ApexTrigger records using SOQL
        loadData();
    }
    
    // Loading triggers data using soql
    public void loadData() {
        lis = [select id, name, status, TableEnumOrId from ApexTrigger];
        
        // System.debug(lis);
        if(trigList == null) {
            trigList = new List<TriggerHelper>();
            for(integer i=0; i<lis.size(); i++) {
                boolean enabled = true;
                if(Trigger_Control__c.getValues(lis.get(i).name) != null) {
                    enabled = false;
                }
                trigList.add(new TriggerHelper(lis.get(i), i, enabled));
                }
        }
        // System.debug(trigList);
    }
    
    // checkbox update method
    public void updateStatus() {
                // getting the record using rowNum parameter
        apexTrigger = trigList.get(Integer.valueOf(ApexPages.currentPage().getParameters().get('rowNum')));
       
        if(!apexTrigger.enabled) {
            // inserting custom settings record
            // disabling the trigger
            if(Trigger_Control__c.getValues(apexTrigger.at.name) == null) {
                Trigger_Control__c trigControl = new Trigger_Control__c();
                trigControl.name = apexTrigger.at.name;
                System.debug(trigControl);
                insert trigControl;
                System.debug('Inserted Succesfully');
            }
        } else {
            // deleting the custom settings record
            // activating a trigger
            customTriggerControl = Trigger_Control__c.getValues(apexTrigger.at.Name);
            System.debug(customTriggerControl);
            delete customTriggerControl;
            System.debug('Deleted Successfully');
        }
    }
        
    // wrapper class
    public class TriggerHelper {
        public ApexTrigger at {get; set;}
        public integer count {get; set;}
        public boolean enabled {get; set;}
        public TriggerHelper(ApexTrigger at,integer count, boolean enabled) {
            this.at = at;
            this.count = count;
            this.enabled = enabled;
        }
    }
}