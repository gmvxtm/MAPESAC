import { PaginationResponse } from "./pagination-response.interface";

export class Result {
  CodeResult: number;
  Id: number;
  IdResult: number;
  MessageResult: string;
}

export class GeneralResponse {
  Status: boolean;
  State: number;
  Message: string;
  ResultResponse: Result;
}

export class NumberResponse extends GeneralResponse{
  Value: number;
  Status:boolean;
  Message: string;
}

export class ExportExcelValueResponse extends GeneralResponse {
  Value: ArrayBuffer;
}

export class CollectionDataResponse {
  Pagination: PaginationResponse;
}