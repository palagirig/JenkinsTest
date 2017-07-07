public class Lcm_Tooling {
    
    public class Result{
        
        public Boolean success {get;set;}
		public Integer statusCode {get;set;}
		public String message {get;set;}
        
        public Result(){
            this.success = false;
            this.statusCode = 666;
            this.message = '!ERROR Unknown failture';
        }
        public Result(Boolean success, Integer statusCode, String message){
            this.success = success;
            this.statusCode = statusCode;
            this.message = message;
        }

    }
}