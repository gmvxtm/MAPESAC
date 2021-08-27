import { GeneralResponse } from '../common/common-response.interface';

export class User {
  IdUser: number;
  CodeVendor: string;
  NameComplete: string;
  FirstName: string;
  LastFirstName: string;
  LastSecondName: string;
  Phone: string;
  Email: string;
  DescriptionVicePresidency: string;
  DescriptionManagement: string;
  DescriptionSuperintendence: string;
  DescriptionPosition: string;

  CodeVendorNameComplete?: string;
}

export class UserResponse extends GeneralResponse {
  Value: User;
}
