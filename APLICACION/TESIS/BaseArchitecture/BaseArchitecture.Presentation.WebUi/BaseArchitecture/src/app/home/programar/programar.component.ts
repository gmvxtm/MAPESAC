import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { NgxSpinnerService } from 'ngx-spinner';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { TypeaheadMatch } from 'ngx-bootstrap/typeahead/public_api';
import { HeadersInterface } from 'src/app/shared/models/request/common/headers-request.interface';

@Component({
  selector: 'app-programar',
  templateUrl: './programar.component.html',
  styleUrls: ['./programar.component.css']
})
export class ProgramarComponent implements OnInit {
  public labelJson: ResponseLabel = new ResponseLabel();
  deviceType: string;
  selectedEmployee: string;
  listEmployee: any [] = [];
  itemType: string;
  totalItems: number;
  configTable: {};
  listRisk: any[] = [];
  headers: HeadersInterface[] = new Array<HeadersInterface>();

  constructor(
    private spinner: NgxSpinnerService,
    private router: Router,
    private localStorage: LocalService
  ) { }

  ngOnInit(): void {
    this.listRisk = [
        {
            CodeRisk: '123',
            DesCodeBusinessUnit: '1',
            RiskName: '1'
        },
        {
            CodeRisk: '456',
            DesCodeBusinessUnit: '1',
            RiskName: '1'
        },
        {
            CodeRisk: '789',
            DesCodeBusinessUnit: '1',
            RiskName: '1'
        },
        {
            CodeRisk: '159',
            DesCodeBusinessUnit: '1',
            RiskName: '1'
        },
        {
            CodeRisk: '1',
            DesCodeBusinessUnit: '1',
            RiskName: '1'
        },
    ]
    this.totalItems = this.listRisk.length;
    this.createHeadersTable();
    this.loadStart();
    this.deviceType = ( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ) ? 'M':'D';
    this.listEmployee = [
        {
          type: 'RP',
          name: '123'
        },
        {
          type: 'RP',
          name: '456'
        },
        {
          type: 'RP',
          name: '789'
        },
        {
          type: 'RS',
          name: '159'
        },
        {
          type: 'RS',
          name: '369'
        }
      ]
  }

  loadStart = () => {
    this.configTable = {
      paging: true,
      searching: false,
      ordering: true,
      lengthChange: true,
      lengthMenu: [2, 5, 6, 10, 15],
      serverSide: false,
      filterColumn: true
    };
  }

  createHeadersTable = () => {
    this.headers = [
      {
        primaryKey: 'CodeRisk',
        title: 'Código',
      },
      {
        primaryKey: 'DesCodeBusinessUnit',
        title: 'Área',
      },
      {
        primaryKey: 'RiskName',
        title: 'Riesgo',
      },
      {
        primaryKey: '',
        title: 'Acciones',
        property: 'button',
        buttons: [
        {
          type: 'edit',
          icon: 'fas fa-search',
          tooltip: 'Consultar'
      }
        ]
      }
    ];
  };

  typeaheadOnSelectEmployee = (e: TypeaheadMatch): void => {
    this.itemType = e.item.type;
  };
}
