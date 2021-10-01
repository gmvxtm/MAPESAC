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
import { Subject } from 'rxjs';
import { MTRespuesta, MTUbicacion } from 'src/app/shared/constant';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { OrderEntity } from 'src/app/shared/models/request/authentication/authentication-request.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { showSuccess } from 'src/app/shared/util';

@Component({
  selector: 'lavanderiaDetalle',
  templateUrl: './lavanderia-detalle.component.html',
  styleUrls: ['./lavanderia-detalle.component.css'],
})

export class LavanderiaDetalleComponent implements OnInit {
  public labelJson: ResponseLabel = new ResponseLabel();
  codeOrder: string;
  orderBD : any;
  customerEntity: any;
  listOrderDetail: any [] = [];
  actualLocation: any;
  rechazado:boolean;
  total: 0;
  codeSubOrderSend: string;
  Status: string;
  statusSubOrderMT: string;
  
  constructor(
    private generalService: GeneralService,
    private spinner: NgxSpinnerService,
    private localStorage: LocalService,
    private router: Router,
  ) {}

  ngOnInit() {
    this.codeOrder = this.localStorage.getJsonValue("codeOrderSend");
    this.codeSubOrderSend = this.localStorage.getJsonValue("codeSubOrderSend");
    this.statusSubOrderMT = this.localStorage.getJsonValue("statusSubOrderMT");
    this.Status="";
    this.loadPedido();
  }

  SendAnswer =() =>{
    let orderRequest = new OrderEntity();
    orderRequest.CodeOrder = this.codeSubOrderSend;
    orderRequest.Status = this.Status;
    this.generalService.UpdSubOrderFlow(orderRequest).subscribe(
        (data: any) => {
            if(data != null){
              this.router.navigate[('/lavanderia')];
            }
        },
        (error: HttpErrorResponse) => {
        this.spinner.hide();
        console.log(error);
        }
    ); 
 }


  loadPedido = () => {
    let orderEntity = new OrderEntity();
    orderEntity.CodeOrder = this.codeOrder;
    this.generalService.GetOrderByCodeOrder(orderEntity).subscribe(
      (data: any) => {
        console.log(data)
        this.orderBD=data.Value;
        this.customerEntity = data.Value.CustomerEntity;
        this.listOrderDetail = data.Value.ListOrderDetail;
        this.rechazado = false;
        if(MTRespuesta.Rechazado === this.orderBD.ListOrderStatus.find(x=> x.IdMasterTable === MTUbicacion.EncargadoVentas).Answer)
        {
          this.rechazado = true;
        }
        this.total=this.orderBD.Total;
      },
      (error: HttpErrorResponse) => {
      this.spinner.hide();
      console.log(error);
      }
  );
}
}
