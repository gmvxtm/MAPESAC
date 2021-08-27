import { GeneralResponse } from '../common/common-response.interface';
import { MasterTable } from '../common/master-response.interface';
import { UserNominate } from './user-nominate-response.interface';
import { User } from './user-response.interface';

export class DataIndex {
    ListUser: User[];
    ListUserNominate: UserNominate[];
    ListMasterTable: MasterTable[];
}

export class DataIndexResponse extends GeneralResponse {
  Value: DataIndex;
  constructor() {
    super();
    this.Value = new DataIndex();
  }
}
