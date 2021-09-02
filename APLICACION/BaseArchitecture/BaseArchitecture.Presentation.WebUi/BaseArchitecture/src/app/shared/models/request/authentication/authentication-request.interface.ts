export class LoginRequest {
    // IdToken: string;
    // AccessToken: string;
    // ExpiresIn: string;
    // Device: string;
    Code: string;
    Header: string;
  }  

  export class LoginModel {
    AwsClientId: string;
    AwsClientSecret: string;
    AwsDomain: string;
    AwsUrlCallback: string;
    AwsIdentityPool: string;
    RefreshToken:string;
  }

  export class UserEntityRequest
  {
    IdUser: string;
    Username: string;
    Password: string;
    RecordStatus: string;
    IdProfile: string;
  }

  export class MenuLogin
  {
    userEntity  : UserEntityRequest;
    ListMenuProfile? : MenuProfile[];
  }

  export class MenuProfile
  {
    IdMenuProfile: string;
    IdMenu: string;
    IdProfile: string;
    MenuName: string;
    UrlName: string;
    RecordStatus: string;  
  }

  
  export class OrderEntity
  {
    IdOrder: string;
    DateOrder: string;
    Total: string;
    IdCustomer: string;    
    Status: string;  
    RecordStatus: string;  
    ListOrderDetail?:OrderDetailEntity[];
  }

  export class OrderDetailEntity
  {
    IdOrderDetail: string;
    IdOrder: string;
    IdProduct: string;
    Description: string;
    Quantity: string;
    RecordStatus: string;  
  }