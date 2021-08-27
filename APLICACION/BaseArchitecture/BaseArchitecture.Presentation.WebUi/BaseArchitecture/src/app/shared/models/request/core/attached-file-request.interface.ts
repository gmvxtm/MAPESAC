import { BaseRecordRequest } from '../common/audit-request.interface';

export class AttachedFileRequest extends BaseRecordRequest {
  IdBaseArchitectureFile?: number;
  IdPerformanceFile?: number;
  IdAttachedFile: string;
  Name: string;
  PathFile: string;
  IdHeaderPerformance?: string;
  FileBase64?: string | ArrayBuffer;
}
