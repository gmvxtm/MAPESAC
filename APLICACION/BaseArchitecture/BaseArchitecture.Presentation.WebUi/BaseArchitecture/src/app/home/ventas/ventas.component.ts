import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { NgxSpinnerService } from 'ngx-spinner';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { HeadersInterface } from 'src/app/shared/models/request/common/headers-request.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { HttpErrorResponse } from '@angular/common/http';
import { THIS_EXPR } from '@angular/compiler/src/output/output_ast';
import { OrderEntity } from 'src/app/shared/models/request/authentication/authentication-request.interface';

@Component({
  selector: 'app-ventas',
  templateUrl: './ventas.component.html',
  styleUrls: ['./ventas.component.css']
})
export class VentasComponent implements OnInit {

    public labelJson: ResponseLabel = new ResponseLabel();
    deviceType: string;
    selectedEmployee: string;
    listEmployee: any [] = [];
    itemType: string;
    totalItems: number;
    configTable: {};
    listRisk: any[] = [];
    headers: HeadersInterface[] = new Array<HeadersInterface>();
    listTotalOrderEntity: any[] = [];
  
    constructor(
      private spinner: NgxSpinnerService,
      private router: Router,
      private localStorage: LocalService,
      private serviceProyecto: GeneralService
    ) { }
  
    ngOnInit(): void {
      this.createHeadersTable();
      this.loadStart();
      this.loadVentas();
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

    loadVentas = () => {
      let orderEntity = new OrderEntity();
      orderEntity.LocationOrder = "00201";
      this.serviceProyecto.ListOrderByLocation(orderEntity).subscribe(
        (data: any) => {
          this.listTotalOrderEntity = data.Value.ListTotalOrderEntity
          console.log(data)
        },
        (error: HttpErrorResponse) => {
        this.spinner.hide();
        console.log(error);
        }
    );
    }
  



    createHeadersTable = () => {
      this.headers = [
        {
          primaryKey: 'Codigo',
          title: 'Código',
        },
        {
          primaryKey: 'InversionDescripcion',
          title: 'Tipo de Inversión',
        },
        {
          primaryKey: 'CicloDescripcion',
          title: 'Ciclo de Inversión',
        },
        {
          primaryKey: 'NaturalezaDescripcion',
          title: 'Naturaleza',
        },
        {
          primaryKey: 'Nombre',
          title: 'Nombre',
        },
        {
          primaryKey: 'Departamento',
          title: 'Departamento',
        },
        {
          primaryKey: 'Costo',
          title: 'Costo',
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

 
}
