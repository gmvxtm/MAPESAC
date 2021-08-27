import { GeneralResponse } from '../common/common-response.interface';
import { ActivityTrackingPerformanceResponse } from './activity-tracking-performance-response.interface';
import { ApprovesHeaderPerformanceResponse } from './approves-header-performance-response.interface';
import { HeaderPerformanceResponse } from './header-performance-response.interface';
import { PerformanceFileResponse } from './performance-file-response.interface';

export class HeaderPerformanceById {
  HeaderPerformance: HeaderPerformanceResponse;
  ListApprovesHeaderPerformances: ApprovesHeaderPerformanceResponse[];
  ListPerformanceFile: PerformanceFileResponse[];
  ListActivityTrackingPerformance: ActivityTrackingPerformanceResponse[];
}

export class HeaderPerformanceByIdResponse extends GeneralResponse {
  Value: HeaderPerformanceById;
}
