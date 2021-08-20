import { BaseRecordRequest } from "./audit-request.interface";

export class MasterTableRequest extends BaseRecordRequest {
  IdMasterTable: string;
  IdMasterTableParent: string;
  Value: string;
  constructor() {
    super();
    this.IdMasterTable = "";
    this.IdMasterTableParent = "";
    this.Value = "";
  }
}