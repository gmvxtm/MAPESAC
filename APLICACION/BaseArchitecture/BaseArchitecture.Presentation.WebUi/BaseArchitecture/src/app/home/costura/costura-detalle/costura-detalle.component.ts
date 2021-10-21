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
import { DecreaseEntity, OrderEntity, SubOrderFlowDetailEntity } from 'src/app/shared/models/request/authentication/authentication-request.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { showSuccess } from 'src/app/shared/util';

@Component({
  selector: 'costuraDetalle',
  templateUrl: './costura-detalle.component.html',
  styleUrls: ['./costura-detalle.component.css'],
})

export class CosturaDetalleComponent implements OnInit {
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
  merma: number;
  Status: string;
  statusSubOrderMT: string;
  listSubOrderFlowDetailEntity: any [] = [];
  statusMerma = true;
  constructor(
    private generalService: GeneralService,
    private spinner: NgxSpinnerService,
    private localStorage: LocalService,
    private router: Router,
  ) {}

  ngOnInit() {
    this.codeOrder =  this.localStorage.getJsonValue("itemSubOrder").CodeOrder;
    this.codeSubOrderSend = this.localStorage.getJsonValue("itemSubOrder").CodeSubOrder;
    this.statusSubOrderMT = this.localStorage.getJsonValue("itemSubOrder").StatusSubOrderMT;
    this.idProducto =  this.localStorage.getJsonValue("itemSubOrder").IdProduct;
    this.Status="";
    this.merma= this.localStorage.getJsonValue("itemSubOrder").Merma;
    this.listSubOrderFlowDetailEntity = this.localStorage.getJsonValue("itemSubOrder").ListSubOrderFlowDetailEntity;
    this.loadPedido();
  }

  SendAnswer =() =>{
    debugger
    //merma de insumos
    this.listSubOrderFlowDetailEntity.forEach(element => {
      let subOrderFlowDetailEntity = new SubOrderFlowDetailEntity();
      subOrderFlowDetailEntity.IdSubOrderFlowDetail = element.IdSubOrderFlowDetail;    
      subOrderFlowDetailEntity.QuantityReturn = element.QuantityReturn.toString();
      this.generalService.UpdSubOrderFlowDetail(subOrderFlowDetailEntity).subscribe(
        (data: any) => {
          debugger
            if(data != null){

            }
          },
          (error: HttpErrorResponse) => {
          this.spinner.hide();
          console.log(error);
          }
      );      
    });
   
    //
    let decreaseEntity = new DecreaseEntity();
    decreaseEntity.IdOrderDetail = this.localStorage.getJsonValue("itemSubOrder").IdOrderDetail;
    decreaseEntity.CodeSubOrder =  this.codeSubOrderSend;
    decreaseEntity.QuantityDecrease = this.merma.toString();
    this.generalService.UpdDecrease(decreaseEntity).subscribe(
      (data: any) => {
          if(data != null){
            let orderRequest = new OrderEntity();
            orderRequest.CodeOrder = this.codeSubOrderSend;
            orderRequest.Status = this.Status;
            this.generalService.UpdSubOrderFlow(orderRequest).subscribe(
                (data: any) => {
                    if(data != null){
                      showSuccess("Se actualizo correctamente la orden");
                      this.router.navigate(['costura']);
                    }
                },
                (error: HttpErrorResponse) => {
                this.spinner.hide();
                console.log(error);
              }
              ); 
              
              
            }
        },
        (error: HttpErrorResponse) => {
        this.spinner.hide();
        console.log(error);
        }
    );
 }

 refreshStatusMerma = () => {
  if(this.Status === "00103")
  {
    this.statusMerma = false;
  }
  else
    this.statusMerma = true;
  
}

  loadPedido = () => {
    let orderEntity = new OrderEntity();
    orderEntity.CodeOrder = this.codeOrder;
    this.generalService.GetOrderByCodeOrder(orderEntity).subscribe(
      (data: any) => {
        this.orderBD=data.Value;
        this.customerEntity = data.Value.CustomerEntity;
        this.listOrderDetail = data.Value.ListOrderDetail.filter(x=> x.IdProduct  === this.idProducto );
        this.rechazado = false;
        this.Status = this.statusSubOrderMT;
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
