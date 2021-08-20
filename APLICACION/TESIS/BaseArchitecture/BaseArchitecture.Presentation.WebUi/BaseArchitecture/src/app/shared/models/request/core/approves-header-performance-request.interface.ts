import { BaseRecordRequest } from '../common/audit-request.interface';

export class ApprovesHeaderPerformanceRequest extends BaseRecordRequest {
  IdApprovesHeaderPerformance: number;
  IdHeaderPerformance: string;
  IdUser: number;
  IdMasterTableStatus: string;
  ExecutionDate: Date;
  Orde: number;
}
