import { GeneralResponse } from "../common/common-response.interface";


export class Process {
  ProcessId: string;
  ProcessName: string;
  ProcessOnlyRead: string;
}

export class Option {
  OptionId: string;
  OptionName: string;
  OptionUrl: string;
  OptionIdParent: string;
  OptionDescription?: string;
  OptionColor1?: string;
  OptionColor2?: string;
  OptionIcon?: string;
  Process: Process[];
  MenuChildren: Option[];
  constructor(){
    this.MenuChildren = new Array<Option>();
  }
}

export class Application {
  ApplicationId: string;
  ApplicationName: string;
  Url: string;
}

export class Profile {
  ProfileId: string;
  ProfileName: string;
  Type?: string;
  ReplaceName?: string;
  ReplaceRole?: string;
  Option?: Option[];
  constructor(){
    this.Option = new Array<Option>();
  }
}

export class Login {
  Token: string;
  User: string;
  UserEdit: number;
  EmployeeId: string;
  Title: string;
  State: boolean;
  Location: string;
  LocationDescription: string;
  AwsSessionToken: string;
  AwsAccessKey: string;
  AwsSecretKey: string;
  IdResponsible: number;
  IdManagement: number;
  NameManagement: string;
  ProfileId: string;
  TimeExpiration:string;
  Email: string;
  UserGuid: string;
  AccessDevice: string;
  IdUser: number;
  RefreshToken: string;
}

export class Access {
  Profile: Profile[];
  Application: Application[];
  constructor(){
    this.Profile = new Array<Profile>();
    this.Application = new Array<Application>();
  }
}

export class LoginResponse extends GeneralResponse {
  Value: string;
}

export class AccessResponse extends GeneralResponse {
  Value: string;
}

export class UserEntityResponse
{
  IdUser: string;
  Username: string;
  RecordStatus: string;
  IdProfile: string;
}
