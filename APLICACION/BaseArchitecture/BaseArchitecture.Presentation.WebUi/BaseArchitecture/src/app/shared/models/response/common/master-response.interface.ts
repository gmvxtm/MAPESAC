import { GeneralResponse } from './common-response.interface';

export class MasterTable {
  IdMasterTable: string;
  IdMasterTableParent: string;
  Order: number;
  Name: string;
  Value: string;
  checked?: boolean;
  AdditionalOne?: string;
  AdditionalTwo?: string;
}
export class ListMasterTableResponse extends GeneralResponse {
  Value: MasterTable[];
}

export class MasterTableResponse extends GeneralResponse {
  Value: MasterTable;
}
