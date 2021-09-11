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
    listTotalOrderEntityOriginal: any[] = [];
    listTotalOrderEntity: any[] = [];
    listOrderEntity: any[] = [];
    SinceDate: string;
    UntilDate: string;
  
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
        lengthChange: false,
        lengthMenu: [5, 10, 15, 20, 25],
        serverSide: false,
        filterColumn: false
      };
    }

    loadVentas = () => {
      let orderEntity = new OrderEntity();
      orderEntity.LocationOrder = "00201";
      this.serviceProyecto.ListOrderByLocation(orderEntity).subscribe(
        (data: any) => {
          this.listTotalOrderEntity = data.Value.ListTotalOrderEntity;
          this.listTotalOrderEntityOriginal = data.Value.ListOrderEntity;
          this.listOrderEntity = data.Value.ListOrderEntity;
          this.totalItems = this.listOrderEntity.length;
        },
        (error: HttpErrorResponse) => {
        this.spinner.hide();
        console.log(error);
        }
    );
    }

    buscarFechas = () => {
      let startDate = new Date(this.SinceDate);
      let endDate = new Date(this.UntilDate);
      this.listOrderEntity = this.listTotalOrderEntityOriginal.filter( x => new Date(x.DateOrder) >= startDate && new Date(x.DateOrder) <= endDate)
    }

    limpiar = () => {
      this.SinceDate = "";
      this.UntilDate = "";
      this.listOrderEntity = this.listTotalOrderEntityOriginal;
    }

    createHeadersTable = () => {
      this.headers = [
        {
          primaryKey: 'CodeOrder',
          title: 'N° Pedido',
        },
        {
          primaryKey: 'FirstName',
          title: 'Nombres',
        },
        {
          primaryKey: 'LastName',
          title: 'Apellidos',
        },
        {
          primaryKey: 'Email',
          title: 'Correo',
        },
        {
          primaryKey: 'PhoneNumber',
          title: 'Telefono',
        },
        {
          primaryKey: 'DateOrderString',
          title: 'Fecha',
        },
        {
          primaryKey: 'LocationOrderName',
          title: 'Estado',
        },
        {
          primaryKey: '',
          title: 'Ver',
          property: 'button',
          buttons: [
          {
            type: 'edit',
            icon: 'fas fa-search',
          }
          ]
        }
      ];
    };

 
}
