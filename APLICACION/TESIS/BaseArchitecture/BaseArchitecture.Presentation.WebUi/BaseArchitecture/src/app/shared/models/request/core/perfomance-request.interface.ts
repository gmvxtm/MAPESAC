import { ApprovesHeaderPerformanceRequest } from './approves-header-performance-request.interface';
import { AttachedFileRequest } from './attached-file-request.interface';
import { HeaderPerformanceRequest } from './header-performance-request.interface';

export class PerformanceRequest {
  HeaderPerformance: HeaderPerformanceRequest;
  ListAttachedFile: AttachedFileRequest[];
  ListApprovesHeaderPerformance: ApprovesHeaderPerformanceRequest[];
  constructor() {
    this.HeaderPerformance = new HeaderPerformanceRequest();
    this.ListAttachedFile = new Array<AttachedFileRequest>();
    this.ListApprovesHeaderPerformance =
      new Array<ApprovesHeaderPerformanceRequest>();
  }
}
