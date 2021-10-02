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
import { MTUbicacion } from 'src/app/shared/constant';

@Component({
  selector: 'app-acabado',
  templateUrl: './acabado.component.html',
  styleUrls: ['./acabado.component.css']
})
export class AcabadoComponent implements OnInit {

    public labelJson: ResponseLabel = new ResponseLabel();
    deviceType: string;
    selectedEmployee: string;
    listEmployee: any [] = [];
    itemType: string;
    totalItems: number;
    configTable: {};
    listOrder: any[] = [];
    headers: HeadersInterface[] = new Array<HeadersInterface>();
    ListSubOrderEntity: any[] = [];
    ListTotalOrderEntity: any[] = [];
    listTotalOrderEntityOriginal: any[] = [];
    listOrderEntity: any[] = [];
  
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

    loadVentas = () => {
      let orderEntity = new OrderEntity();
      orderEntity.LocationOrder = MTUbicacion.AreaAcabados;
      this.serviceProyecto.ListSubOrderByLocation(orderEntity).subscribe(
        (data: any) => {
          this.ListSubOrderEntity = data.Value.ListSubOrderEntity;
          this.ListTotalOrderEntity = data.Value.ListTotalOrderEntity;
          this.totalItems = this.ListSubOrderEntity.length;
        },
        (error: HttpErrorResponse) => {
        this.spinner.hide();
        console.log(error);
        }
      );
    }

    
    verDetalle = (item) => {
      let codeOrder = item.CodeOrder;
      let codeSubOrder = item.CodeSubOrder;
      this.localStorage.setJsonValue("codeOrderSend", codeOrder);
      this.localStorage.setJsonValue("codeSubOrderSend", codeSubOrder);
      this.router.navigate(['acabado/detalle']);
    }


    filterStatus = (item) => {
      if(item.IdMasterTable.trim() === "0")
        {this.listOrderEntity = this.listTotalOrderEntityOriginal;}
      else 
        {this.listOrderEntity = this.listTotalOrderEntityOriginal.filter(x=> x.Answer === item.IdMasterTable);}
    }

    loadStart = () => {
      this.configTable = {
        paging: true,
        searching: false,
        ordering: false,
        lengthChange: true,
        lengthMenu: [5, 10, 15, 20, 25],
        serverSide: false,
        filterColumn: false
      };
    }
  
    buscarPedido = () => {

    }

    createHeadersTable = () => {
      this.headers = [
        {
          primaryKey: 'CodeOrder',
          title: 'N° Pedido',
        },
        {
          primaryKey: 'CodeSubOrder',
          title: 'Orden trabajo',
        },
        {
          primaryKey: 'Quantity',
          title: 'Cantidad',
        },
        {
          primaryKey: 'StatusSubOrderName',
          title: 'Estado',
        },
        {
          primaryKey: 'DateSubOrder',
          title: 'Fecha Inicio',
        },
        {
          primaryKey: 'DateEndSubOrder',
          title: 'Fecha Fin',
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
