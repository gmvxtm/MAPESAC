import { DatePipe } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import {
  Component,
  OnInit,
} from '@angular/core';
import { FormGroup } from '@angular/forms';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { NgxSpinnerService } from 'ngx-spinner';
import { Subject } from 'rxjs';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { OrderEntity } from 'src/app/shared/models/request/authentication/authentication-request.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { LocalService } from 'src/app/shared/services/general/local.service';

@Component({
  selector: 'ventaDetalle',
  templateUrl: './venta-detalle.component.html',
  styleUrls: ['./venta-detalle.component.css'],
})

export class VentaDetalleComponent implements OnInit {
  public labelJson: ResponseLabel = new ResponseLabel();
  codeOrder: string;
  customerEntity: any;

  constructor(
    private generalService: GeneralService,
    private spinner: NgxSpinnerService,
    private localStorage: LocalService,
  ) {}

  ngOnInit() {
      this.codeOrder = this.localStorage.getJsonValue("codeOrderSend");
      this.loadPedido();
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
    // Description: ""
    // IdOrder: "d77d2729-f9ff-4bc8-8302-2aa2de4c5054"
    // IdOrderDetail: "6ce25492-3a46-41f6-a191-a501d8db8e85"
    // IdProduct: "76d5f7f6-2bd4-4718-9bef-2f21a381cb9f"
    // Quantity: 4
    // RecordStatus: "A"
    // [[Prototype]]: Object
    // 1: {IdOrderDetail: 'e048bb1a-bfbb-4355-83c5-a8432ea46d86', IdOrder: 'd77d2729-f9ff-4bc8-8302-2aa2de4c5054', IdProduct: 'abd7c103-7799-405a-bd90-9b0cffd6a82a', Description: '', Quantity: 3, …}
    // 2: {IdOrderDetail: '141faa5f-21bf-4d0b-b6fc-ab84d60eadfa', IdOrder: 'd77d2729-f9ff-4bc8-8302-2aa2de4c5054', IdProduct: '4fecb6ff-0508-45c2-a2c2-84c2f51514f6', Description: '', Quantity: 2, …}

  loadPedido = () => {
    let orderEntity = new OrderEntity();
      orderEntity.CodeOrder = this.codeOrder;
      this.generalService.GetOrderByCodeOrder(orderEntity).subscribe(
        (data: any) => {
          console.log(data)
          this.customerEntity = data.Value.CustomerEntity;
          let obj = data.Value.ListOrderStatus;
        },
        (error: HttpErrorResponse) => {
        this.spinner.hide();
        console.log(error);
        }
    );
  }

}
