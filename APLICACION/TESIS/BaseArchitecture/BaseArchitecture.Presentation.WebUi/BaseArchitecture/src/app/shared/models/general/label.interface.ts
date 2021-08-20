export class ResponseLabel {
    general: GeneralLabel;
    message: MessageLabel;
    login: LoginLabel;
    constructor() {
      this.general = new GeneralLabel();
      this.message = new MessageLabel();
      this.login = new LoginLabel();
    }
  }
  
  export class LoginLabel {
    lblTitle: string;
    lblEmail: string;
    lblNetworkUserEmail: string;
    lblNetworkUser: string;
    lblAccess: string;
    lblNetworkUserStrategicPartner: string;
  }
  export class GeneralLabel {
    lblTitle: string;
    lblClosedSession: string;
    lblLoading: string;
    lblFilter:string;
    lblFilterBy:string;
    lblShowRows:string;
    lblWelcome: string;
    lblStartDate: string;
    lblFooter: string;
    lblUserProfile:string;
    lblEndDate: string;
    lblClear: string;
    lblSearch: string;
    lblFileUpload: string;
  }
  
  export class MessageLabel {
    error: string;
    success: string;
  }
  