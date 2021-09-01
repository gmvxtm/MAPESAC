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
    IdMenuProfile: string;
    IdMenu: string;
    IdProfile: string;
    MenuName: string;
    UrlName: string;
    RecordStatus: string;  
    orderDetail?:OrderDetailEntity[];
  }

  
  export class OrderDetailEntity
  {
    IdMenuProfile: string;
    IdMenu: string;
    IdProfile: string;
    MenuName: string;
    UrlName: string;
    RecordStatus: string;  
  }