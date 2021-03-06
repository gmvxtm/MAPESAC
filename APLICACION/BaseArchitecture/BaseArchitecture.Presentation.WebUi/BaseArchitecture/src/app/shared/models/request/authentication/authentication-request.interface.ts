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
    ProfileName: string;
  }

  
  export class OrderEntity
  {
    IdOrder: string;
    DateOrder: string;
    CodeOrder: string;
    Total: string;
    StatusOrder:string;
    LocationOrder:string;
    StatusOrderName?:string;
    LocationOrderName?:string;
    Email?:string;
    FirstName?:string;
    LastName?:string;
    DocumentNumber?:string;
    PhoneNumber?:string;
    IdCustomer: string;  
    RecordStatus: string;  
    BusinessName: string;  
    BusinessNumber: string;  
    CustomerEntity:CustomerEntity;
    ListOrderDetail?:OrderDetailEntity[];
    Answer?:string;
    Status?: string;
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

  export class CustomerEntity
  {
    IdCustomer: string;
    FirstName: string;
    LastName: string;
    DocumentNumber: string;
    PhoneNumber: string;
    Email:string;
    IdDistrict:string;
    District:string;
    IdProvince:string;
    Province:string;
    IdDepartment:string;
    Department:string;
    RecordStatus: string;  
  }

  export class UbiEntity
  {
    ListDepartmentEntity? : DepartmentEntity[];
    ListProvinceEntity? : ProvinceEntity[];
    ListDistrictEntity? : DistrictEntity[];
  }

  export class DepartmentEntity
  {
    IdDepartment:string;
    Department:string;
  }
  export class ProvinceEntity
  {
    IdProvince:string;
    Province:string;
    IdDepartment:string;    
  }
  export class DistrictEntity
  {
    IdDistrict:string;
    District:string;
    IdProvince:string;
  }


  export class SupplyEntity
  {
    IdSupply: string;
    IdSupplier: string;    
    UnitPrice: string;
    Quantity: string;    
    TotalPrice: string;  
  }

  export class BuySupplyEntity
  {
    IdSupply: string;
    IdSupplier: string;    
    UnitPrice: string;
    Quantity: string;    
    TotalPrice: string;  
  }

  export class DecreaseEntity
  {
    IdOrderDetail: string;
    CodeSubOrder: string;    
    QuantityDecrease: string;
  }

  export class SubOrderFlowDetailEntity
  {
    IdSubOrderFlowDetail: string;
    QuantityReturn: string;    
    
  }