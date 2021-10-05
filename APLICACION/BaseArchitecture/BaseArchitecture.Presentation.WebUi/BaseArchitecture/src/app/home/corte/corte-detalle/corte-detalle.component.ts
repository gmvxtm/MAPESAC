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
import { DecreaseEntity, OrderEntity } from 'src/app/shared/models/request/authentication/authentication-request.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { showSuccess } from 'src/app/shared/util';

@Component({
  selector: 'corteDetalle',
  templateUrl: './corte-detalle.component.html',
  styleUrls: ['./corte-detalle.component.css'],
})

export class CorteDetalleComponent implements OnInit {
  public labelJson: ResponseLabel = new ResponseLabel();
  codeOrder: string;
  codeSubOrderSend: string;
  idProducto:string;
  orderBD : any;
  customerEntity: any;
  listOrderDetail: any [] = [];
  actualLocation: any;
  rechazado:boolean;
  total: 0;
  merma:1;
  Status: string;
  statusSubOrderMT: string;

  constructor(
    private generalService: GeneralService,
    private spinner: NgxSpinnerService,
    private localStorage: LocalService,
    private router: Router,
  ) {}

  ngOnInit() {
    debugger
    this.codeOrder =  this.localStorage.getJsonValue("itemSubOrder").CodeOrder;
    this.codeSubOrderSend = this.localStorage.getJsonValue("itemSubOrder").CodeSubOrder;
    this.statusSubOrderMT = this.localStorage.getJsonValue("itemSubOrder").StatusSubOrderMT;
    this.idProducto =  this.localStorage.getJsonValue("itemSubOrder").IdProduct;
    this.Status="";
    this.merma=1;
    this.loadPedido();
  }

  SendAnswer =() =>{

    
    let decreaseEntity = new DecreaseEntity();
    decreaseEntity.IdOrderDetail = this.localStorage.getJsonValue("itemSubOrder").IdOrderDetail;
    decreaseEntity.CodeSubOrder =  this.codeSubOrderSend;
    decreaseEntity.QuantityDecrease = this.merma.toString();
    this.generalService.UpdDecrease(decreaseEntity).subscribe(
        (data: any) => {
            if(data != null){
              debugger
              let orderRequest = new OrderEntity();
              orderRequest.CodeOrder = this.codeSubOrderSend;
              orderRequest.Status = this.Status;
              this.generalService.UpdSubOrderFlow(orderRequest).subscribe(
                  (data: any) => {
                      if(data != null){
                        debugger
                        showSuccess("Se actualizo correctamente la orden");
                        this.router.navigate(['corte']);
                      }
                  },
                  (error: HttpErrorResponse) => {
                  this.spinner.hide();
                  console.log(error);
                  }
              ); 
              
              this.router.navigate(['corte']);
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
        debugger
        this.orderBD=data.Value;
        this.customerEntity = data.Value.CustomerEntity;
        this.listOrderDetail = data.Value.ListOrderDetail.filter(x=> x.IdProduct  === this.idProducto );
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
