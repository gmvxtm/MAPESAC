import { CollectionDataResponse } from "../common/common-response.interface";
import { HeaderPerformanceViewResponse } from "./header-performance-view-response.interface";

export class CoreResponse extends CollectionDataResponse {
    Collection: HeaderPerformanceViewResponse[];
    constructor(){
        super();
    }
}

export class CoreCollectionDataResponse{
    Value: CoreResponse;
}