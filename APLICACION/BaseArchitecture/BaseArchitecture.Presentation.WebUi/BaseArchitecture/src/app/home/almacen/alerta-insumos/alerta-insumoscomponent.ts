import { DatePipe } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import {
  Component,
  OnInit,
} from '@angular/core';
import { FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { NgxSpinnerService } from 'ngx-spinner';
import { HeadersInterface } from 'src/app/shared/models/request/common/headers-request.interface';
import { Subject } from 'rxjs';
import { MTRespuesta, MTUbicacion } from 'src/app/shared/constant';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { OrderEntity } from 'src/app/shared/models/request/authentication/authentication-request.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { showSuccess } from 'src/app/shared/util';
import { filterByValue } from 'src/app/shared/util';

@Component({
  selector: 'AlertaInsumos',
  templateUrl: './alerta-insumos.component.html',
  styleUrls: ['./alerta-insumos.component.css'],
})

export class AlertaInsumosComponent implements OnInit {
  public labelJson: ResponseLabel = new ResponseLabel();
  deviceType: string;
  selectedEmployee: string;
  listEmployee: any [] = [];
  itemType: string;
  totalItems: number;
  configTable: {};
  listRisk: any[] = [];
  headers: HeadersInterface[] = new Array<HeadersInterface>();
  ListSuppliesEntity: any[] = [];
  ListSuppliesEntityOriginal: any[] = [];
  nameSupplies: string;

  constructor(
    private generalService: GeneralService,
    private spinner: NgxSpinnerService,
    private localStorage: LocalService,
    private router: Router,
    private serviceProyecto: GeneralService
  ) {}

  ngOnInit(): void {
    this.createHeadersTable();
    this.loadStart();
    this.loadData();
    
  }

  loadData = () => {
   
    this.serviceProyecto.ListSupplies().subscribe(
      (data: any) => {
        debugger
        this.ListSuppliesEntity = data.Value.filter(x=>x.IndicateAlert === true);
        this.ListSuppliesEntityOriginal = data.Value.filter(x=>x.IndicateAlert === true);          
        this.totalItems = this.ListSuppliesEntityOriginal.length;
      },
      (error: HttpErrorResponse) => {
      this.spinner.hide();
      console.log(error);
      }
    );
  }

  buscarSupplies = () => {
    this.ListSuppliesEntity =filterByValue(this.ListSuppliesEntityOriginal,  this.nameSupplies );
    this.totalItems = this.ListSuppliesEntity.length;
  }

  verDetalle = (item) => {
    // debugger
    // this.localStorage.setJsonValue("itemSubOrder",item);  
    // this.router.navigate(['costura/detalle']);
  }

  loadStart = () => {
    this.configTable = {
      paging: true,
      searching: false,
      ordering: true,
      lengthChange: true,
      lengthMenu: [5, 10, 15, 20, 25],
      serverSide: false,
      filterColumn: true
    };
  }




  createHeadersTable = () => {
    this.headers = [
      {
        primaryKey: 'CodeSupply',
        title: 'Código',
      },
      {
        primaryKey: 'Name',
        title: 'Descripción',
      },
      {
        primaryKey: 'MinimumStock',
        title: 'Stock Minimo',
      },
      {
        primaryKey: 'Stock',
        title: 'Stock Disponible',
      },     
      {
        primaryKey: '',
        title: 'Acciones',
        property: 'button',
        buttons: [
        {
          type: 'edit',
          icon: 'fas fa-store-alt',
          tooltip: 'Solicitar'
      }
        ]
      }
    ];
  };



}
