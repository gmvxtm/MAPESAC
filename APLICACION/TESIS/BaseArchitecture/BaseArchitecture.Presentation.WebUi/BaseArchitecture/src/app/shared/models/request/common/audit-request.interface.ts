import { RecordStatus } from "src/app/shared/constant";

export class BaseRecordRequest {
    RecordStatus: string;
    UserRecord?: string;
    RecordDate?: Date;
    constructor() {
      // this.RecordStatus = RecordStatus.Activate;
    }
  }