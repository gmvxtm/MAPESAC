import {
  Component,
  EventEmitter,
  Input,
  OnChanges,
  OnInit,
  Output,
} from '@angular/core';
import { Router } from '@angular/router';
import { PageChangedEvent } from 'ngx-bootstrap/pagination';
import { RecordStatus } from 'src/app/shared/constant';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { Sort } from 'src/app/component/table/sort';
import { HeadersInterface } from 'src/app/shared/models/request/common/headers-request.interface';
import { GeneralLabel } from 'src/app/shared/models/general/label.interface';
import { general } from 'src/assets/label.json';

@Component({
  selector: 'app-table',
  templateUrl: './table.component.html',
  styleUrls: ['./table.component.css'],
})
export class TableComponent implements OnInit, OnChanges {
  @Input() headers: HeadersInterface[];
  @Input() data: any[];
  dataTemp: any[];
  @Input() configTable?: any;
  @Input() totalItems?: number;
  @Output()
  edit: EventEmitter<any> = new EventEmitter<any>();
  @Output()
  deactivate: EventEmitter<any> = new EventEmitter<any>();
  @Output()
  filter: EventEmitter<any> = new EventEmitter<any>();
  @Output()
  paging: EventEmitter<number> = new EventEmitter<number>();
  returnedArray: any[];
  columnMaps: HeadersInterface[];
  labelGeneral: GeneralLabel = new GeneralLabel();
  recordStatus = RecordStatus;
  configOption = {
    paging: false,
    searching: false,
    ordering: false,
    lengthChange: false,
    lengthMenu: [5, 10, 15, 20, 25],
    serverSide: false,
    filterColumn: false,
  };
  contentArray: any[];
  maxSize: number = null;
  currentPage: number = 1;
  rotate: boolean = false;
  filterColumn: any;
  searchText: string = '';
  isClickPagination: boolean;
  startItem: number;
  endItem: number;

  constructor(private localStorage: LocalService, private router: Router) {}

  ngOnInit(){
    this.labelGeneral = general;    
  }
  ngOnChanges() {
    this.configOption = {
      paging: this.configTable?.paging || this.configOption.paging,
      searching: this.configTable?.searching || this.configOption.searching,
      ordering: this.configTable?.ordering || this.configOption.ordering,
      lengthChange:
        this.configTable?.lengthChange || this.configOption.lengthChange,
      lengthMenu: this.configTable?.lengthMenu || this.configOption.lengthMenu,
      serverSide: this.configTable?.serverSide || this.configOption.serverSide,
      filterColumn:
        this.configTable?.filterColumn || this.configOption.filterColumn,
    };
    this.returnedArray =
      this.configOption.ordering && this.data != undefined
        ? this.data.slice(0, this.maxSize || this.configOption.lengthMenu[0])
        : this.data != undefined
        ? this.data.slice(0, this.maxSize || this.configOption.lengthMenu[0])
        : [];

    this.dataTemp = [...this.data];

    this.maxSize = this.maxSize || this.configOption.lengthMenu[0];

    if (
      this.configOption.searching &&
      this.searchText != '' &&
      (!this.filterColumn || this.filterColumn?.value == '')
    )
      this.filterArray();
    else if (
      this.configOption.filterColumn &&
      this.filterColumn != null &&
      this.filterColumn?.value != ''
    )
      this.searchHeader(this.filterColumn.value, this.filterColumn.column);

    if (this.headers) {
      this.columnMaps = this.headers;
      if (this.returnedArray.length > 0) {
        for (const colMap of this.columnMaps) {
          if (colMap.primaryKey && colMap.primaryKey.indexOf('.') > -1) {
            const fields = colMap.primaryKey.split('.');
            for (const field of fields) {
              for (let i = 0; i < this.data.length; i++) {
                this.data[i][colMap.primaryKey] = this.data[i][
                  colMap.primaryKey
                ]
                  ? this.data[i][colMap.primaryKey][field]
                  : this.data[i][field];
              }
            }
          } else if (colMap.primaryKey === '%ID%') {
            for (let i = 0; i < this.data.length; i++) {
              this.data[i][colMap.primaryKey] = i + 1;
            }
          }
        }
      }
    } else {
      if (this.data !== undefined) {
        if (this.data.length > 0) {
          this.columnMaps = Object.keys(this.data[0]).map((key) => {
            return {
              primaryKey: key,
              title:
                key.slice(0, 1).toUpperCase() + key.replace(/_/g, ' ').slice(1),
            };
          });
        }
      }
    }
  }

  lengthChangeMenu = (value: number) => {
    this.currentPage = 1;
    this.maxSize = value;
    if (
      this.searchText != '' &&
      (!this.filterColumn || this.filterColumn?.value == '')
    )
      this.filterArray();
    else if (
      this.configOption.filterColumn &&
      this.filterColumn != null &&
      this.filterColumn?.value != ''
    )
      this.searchHeader(this.filterColumn.value, this.filterColumn.column);
    else this.returnedArray = this.dataTemp.slice(0, value);
  };

  pageChanged(event: PageChangedEvent): void {
    if (this.configOption.serverSide) {
      this.paging.emit(event.page);
    } else {
      this.startItem = (event.page - 1) * event.itemsPerPage;
      this.endItem = event.page * event.itemsPerPage;
      this.returnedArray = this.dataTemp.slice(this.startItem, this.endItem);
    }
  }

  deactivateClick = (item: any) => {
    this.deactivate.emit(item);
  };

  editClick = (item: any) => {
    this.edit.emit(item);
  };

  searchHeader = (val: string, columnHeader: string) => {
    this.currentPage = 1;
    let _this = this;
    this.filterColumn = {
      value: val,
      column: columnHeader,
    };
    let dataFilter = this.data;

    if (this.configOption.serverSide) {
      this.filter.emit(this.filterColumn);
    } else if (
      this.searchText != '' &&
      (!this.filterColumn || this.filterColumn?.value == '')
    ) {
      this.filterArray();
    } else {
      if (this.filterColumn != null && this.filterColumn?.value != '') {
        dataFilter = this.data.filter((x) => {
          return (
            _this
              .removeAccents(x[columnHeader].toString())
              .toUpperCase()
              .indexOf(_this.removeAccents(val.toString()).toUpperCase()) > -1
          );
        });
      }

      let elem = null;
      let insertedContent = document.querySelector('.insertedContent');
      if (insertedContent) {
        elem = insertedContent.parentElement;
      }

      if (elem != null) {
        const sort = new Sort();
        const order = elem.getAttribute('data-order');
        const type = elem.getAttribute('data-type');
        const property = elem.getAttribute('data-name');

        this.returnedArray = dataFilter
          .sort(sort.startSort(property, order, type))
          .slice(0, this.maxSize);
      } else {
        this.returnedArray = dataFilter.slice(0, this.maxSize);
      }
      this.dataTemp = [...dataFilter];
      this.totalItems = dataFilter.length;
    }
    this.currentPage = 1;
  };

  selectDataClick = (record) => {
    this.localStorage.setJsonValue('RequestData', record);
    if (record.Id != null && record.Id != '') {
      this.router.navigate(['detail']);
    } else return;
  };

  sortData = (elem: any) => {
    let insertedContent = document.querySelector('.insertedContent');
    if (insertedContent) {
      elem = insertedContent.parentElement;
      insertedContent.parentNode.removeChild(insertedContent);
    }
    this.currentPage = 1;
    const sort = new Sort();
    let order = elem.getAttribute('data-order');
    const type = elem.getAttribute('data-type');
    const property = elem.getAttribute('data-name');

    if (order === 'desc') {
      elem.setAttribute('data-order', 'asc');
      order = 'asc';
      elem.insertAdjacentHTML(
        'beforeend',
        '<i class="fas fa-sort-up insertedContent"></i>'
      );
    } else {
      elem.setAttribute('data-order', 'desc');
      order = 'desc';
      elem.insertAdjacentHTML(
        'beforeend',
        '<i class="fas fa-caret-down insertedContent"></i>'
      );
    }

    if (
      this.searchText != '' &&
      (!this.filterColumn || this.filterColumn?.value == '')
    )
      this.filterArray();
    else if (this.filterColumn != null && this.filterColumn?.value != '') {
      this.searchHeader(this.filterColumn.value, this.filterColumn.column);
    } else {
      this.returnedArray = this.dataTemp
        .sort(sort.startSort(property, order, type))
        .slice(0, this.maxSize);
      this.totalItems = this.dataTemp.length;
    }
    this.currentPage = 1;
  };

  filterArray() {
    let _this = this;
    if (!this.data.length) {
      this.returnedArray = [];
      return;
    }

    let dataFilter;
    this.returnedArray = [];
    if (this.filterColumn != null && this.filterColumn?.value != '') {
      dataFilter = dataFilter.filter((x) => {
        return (
          _this
            .removeAccents(x[this.filterColumn.column].toString())
            .toUpperCase()
            .indexOf(
              _this
                .removeAccents(this.filterColumn.value.toString())
                .toUpperCase()
            ) > -1
        );
      });
    }

    dataFilter = this.data.filter((user) => {
      return this.headers.find((property) => {
        const valueString = this.removeAccents(
          (user[property.primaryKey] || '').toString().toLowerCase()
        );
        return valueString.includes(
          this.removeAccents(this.searchText.toLowerCase())
        );
      })
        ? user
        : null;
    });

    let elem = null;
    let insertedContent = document.querySelector('.insertedContent');
    if (insertedContent) {
      elem = insertedContent.parentElement;
    }

    if (elem != null) {
      const sort = new Sort();
      const order = elem.getAttribute('data-order');
      const type = elem.getAttribute('data-type');
      const property = elem.getAttribute('data-name');

      this.returnedArray = dataFilter
        .sort(sort.startSort(property, order, type))
        .slice(
          this.isClickPagination ? this.startItem : 0,
          this.isClickPagination ? this.endItem : this.maxSize
        );
    } else {
      this.returnedArray = dataFilter.slice(0, this.maxSize);
    }
    this.dataTemp = [...dataFilter];
    this.currentPage = 1;
    this.totalItems = dataFilter.length;
  }

  removeAccents = (str) => {
    return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
  };
}
