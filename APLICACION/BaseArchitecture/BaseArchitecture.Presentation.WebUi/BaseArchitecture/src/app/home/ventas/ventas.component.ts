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
import { Subject } from 'rxjs';
import { MTRespuesta, MTUbicacion } from 'src/app/shared/constant';

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
      private serviceProyecto: GeneralService,
      private generalService: GeneralService,
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

    filterStatus = (item) => {
      let pr = item;
      if(item.IdMasterTable.trim() ==="0")
        {this.listOrderEntity = this.listTotalOrderEntityOriginal;}
      else 
        {this.listOrderEntity = this.listTotalOrderEntityOriginal.filter(x=> x.Answer === item.IdMasterTable);}
       

    }

    loadVentas = () => {
      let orderEntity = new OrderEntity();
      orderEntity.LocationOrder = MTUbicacion.EncargadoVentas;
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
      if(this.SinceDate === undefined && this.UntilDate=== undefined)      
      {
        this.listOrderEntity = this.listTotalOrderEntityOriginal
      }
      else
      {
        let startDate = new Date(this.SinceDate);      
        let endDate = new Date(this.UntilDate);
        startDate.setHours(0,0,0,0);
        endDate.setHours(0,0,0,0);
        this.listOrderEntity = this.listTotalOrderEntityOriginal.filter( x => new Date(x.DateOrder) >= startDate && new Date(x.DateOrder) <= endDate)
      }

    }

    limpiar = () => {
      this.SinceDate = "";
      this.UntilDate = "";
      this.listOrderEntity = this.listTotalOrderEntityOriginal;
    }

    verDetalle = (item) => {
      let codeOrder = item.CodeOrder;
      this.localStorage.setJsonValue("codeOrderSend", codeOrder)
      this.router.navigate(['ventas/detalle']);
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
          primaryKey: 'AnswerName',
          title: 'Respuesta',
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
