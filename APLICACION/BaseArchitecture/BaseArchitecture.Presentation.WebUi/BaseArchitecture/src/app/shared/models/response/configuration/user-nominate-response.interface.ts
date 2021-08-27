import { GeneralResponse } from '../common/common-response.interface';

export class UserNominate {
  IdUser: number;
  NameComplete: string;
  DocumentNumber: string;
  DescriptionVicePresidency: string;
  DescriptionManagement: string;
  DescriptionSuperintendence: string;
  DescriptionPosition: string;

  CodeVendorNameComplete?: string;
}

export class UserNominateResponse extends GeneralResponse {
  Value: UserNominate;
}
