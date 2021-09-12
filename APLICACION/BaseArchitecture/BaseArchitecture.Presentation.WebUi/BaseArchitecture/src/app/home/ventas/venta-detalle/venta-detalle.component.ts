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
  selector: 'ventaDetalle',
  templateUrl: './venta-detalle.component.html',
  styleUrls: ['./venta-detalle.component.css'],
})

export class VentaDetalleComponent implements OnInit {
  public labelJson: ResponseLabel = new ResponseLabel();
  codeOrder: string;
  orderBD : any;
  customerEntity: any;
  listOrderDetail: any [] = [];
  actualLocation: any;
  constructor(
    private generalService: GeneralService,
    private spinner: NgxSpinnerService,
    private localStorage: LocalService,
    private router: Router,
  ) {}

  ngOnInit() {
      this.codeOrder = this.localStorage.getJsonValue("codeOrderSend");
      this.loadPedido();
      this.actualLocation = MTUbicacion.EncargadoVentas;
  }

      // CustomerEntity:
    // Department: "LIMA"
    // District: "LIMA"
    // DocumentNumber: "47481410"
    // Email: "betito@gmail.com"
    // FirstName: "betito"
    // IdCustomer: "fa5f0a3b-151a-4b5d-9694-96948f7abf8a"
    // IdDepartment: "15"
    // IdDistrict: "1251"
    // IdProvince: "127"
    // LastName: "alcarraz"
    // PhoneNumber: "987632123"
    // Province: "LIMA"
    // RecordStatus: "A"

    // ListOrderDetail: Array(3)
    // 0:
    // Description: "Modelo A"
    // IdOrder: "42faf6ea-88e6-4472-b6ec-5a3a70367f6f"
    // IdOrderDetail: "031dbe70-09fc-4786-88fc-38476d1e14e9"
    // IdProduct: "4fecb6ff-0508-45c2-a2c2-84c2f51514f6"
    // Quantity: 1
    // RecordStatus: "A"
    // UnitPrice
    // SubTotal: 3
    
    // 1: {IdOrderDetail: 'e048bb1a-bfbb-4355-83c5-a8432ea46d86', IdOrder: 'd77d2729-f9ff-4bc8-8302-2aa2de4c5054', IdProduct: 'abd7c103-7799-405a-bd90-9b0cffd6a82a', Description: '', Quantity: 3, …}
    // 2: {IdOrderDetail: '141faa5f-21bf-4d0b-b6fc-ab84d60eadfa', IdOrder: 'd77d2729-f9ff-4bc8-8302-2aa2de4c5054', IdProduct: '4fecb6ff-0508-45c2-a2c2-84c2f51514f6', Description: '', Quantity: 2, …}

  loadPedido = () => {
      let orderEntity = new OrderEntity();
      orderEntity.CodeOrder = this.codeOrder;
      this.generalService.GetOrderByCodeOrder(orderEntity).subscribe(
        (data: any) => {
          console.log(data)
          this.orderBD=data.Value;
          this.customerEntity = data.Value.CustomerEntity;
          this.listOrderDetail = data.Value.ListOrderDetail;
        },
        (error: HttpErrorResponse) => {
        this.spinner.hide();
        console.log(error);
        }
    );
  }

  SendAnswer =(answer: any) =>{
    debugger
    let respuesta="";
    if(answer===1)
      respuesta = MTRespuesta.Aprobado;
    else if(answer===2)
      respuesta = MTRespuesta.Rechazado;      
     let prueba  = answer;

     let orderRequest = new OrderEntity();
     orderRequest.IdOrder =this.orderBD.IdOrder ;
     orderRequest.LocationOrder =MTUbicacion.EncargadoVentas;
     orderRequest.Answer = respuesta;

     this.generalService.UpdOrderFlow(orderRequest).subscribe(
         (data: any) => {
            
            orderRequest = new OrderEntity();
            orderRequest.IdOrder =this.orderBD.IdOrder ;
            orderRequest.LocationOrder =MTUbicacion.AreaCorte;
            orderRequest.Answer = MTRespuesta.Pendiente;
            
            this.generalService.UpdOrderFlow(orderRequest).subscribe(
              (data: any) => {

                  
                  this.router.navigate(['ventas']);
                  showSuccess("Se actualizo correctamente la orden");
              },
              (error: HttpErrorResponse) => {
                this.spinner.hide();
                console.log(error);
                }
            );
             //setTimeout(() => {
                 //this.localStorage.clearKey('catalogListSelectedModal');
                //  this.router.navigate(['catalogo']);
             //}, 2);
         },
         (error: HttpErrorResponse) => {
         this.spinner.hide();
         console.log(error);
         }
     ); 


  }

}
