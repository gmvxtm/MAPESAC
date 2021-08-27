export class FilterColumn {
  NameColumn: string;
  ValueColumn: string;
}

export class PaginationRequest {
  CurrentPage: number;
  RowsPerPage: number;
  ColumnOrder: string;
  TypeOrder: string;
}
