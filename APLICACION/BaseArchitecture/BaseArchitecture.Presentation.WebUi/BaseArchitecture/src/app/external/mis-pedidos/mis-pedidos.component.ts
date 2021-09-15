import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { NgxSpinnerService } from 'ngx-spinner';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { HeadersInterface } from 'src/app/shared/models/request/common/headers-request.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { HttpErrorResponse } from '@angular/common/http';
import { ProductEntity } from 'src/app/shared/models/general/table.interface';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { Subject } from 'rxjs';
import { OrderEntity } from 'src/app/shared/models/request/authentication/authentication-request.interface';
import { MTRespuesta } from 'src/app/shared/constant';

var $: any;

@Component({
  selector: 'app-mis-pedidos',
  templateUrl: './mis-pedidos.component.html',
  styleUrls: ['./mis-pedidos.component.css']
})
export class MisPedidosComponent implements OnInit {

    public labelJson: ResponseLabel = new ResponseLabel();
    bsModalRefP: BsModalRef;
    dtTrigger: Subject<any> = new Subject();
    deviceType: string;
    selectedEmployee: string;
    listEmployee: any [] = [];
    itemType: string;
    totalItems: number;
    configTable: {};
    listRisk: any[] = [];
    headers: HeadersInterface[] = new Array<HeadersInterface>();
    catalogInitList: any[] = [];
    catalogInitProductEntity : any[] = [];
    countCart = 0;
    catalogListSelected: any[] = [];
    catalogListSelectedModal: any[] = [];
    codeOrder: string;
    listOrderStatus: any[] = [];
    orderBD: any;
    flagVisible : boolean;
    flagRechazado: boolean;
    name:string;
    constructor(
      private spinner: NgxSpinnerService,
      private router: Router,
      private localStorage: LocalService,
      private generalService: GeneralService
    ) { }
  
    ngOnInit(): void {
      
    }

    buscarPedido = () => {
      this.flagVisible  = false ;
      this.flagRechazado= false;
      let orderEntity = new OrderEntity();
      orderEntity.CodeOrder = this.codeOrder;
      this.generalService.GetOrderByCodeOrder(orderEntity).subscribe(
        (data: any) => {
          this.flagVisible  = true ;
          this.orderBD = data.Value;
          this.name = this.orderBD.CustomerEntity.FirstName + ' ' +this.orderBD.CustomerEntity.LastName; 
          this.listOrderStatus = data.Value.ListOrderStatus;
          if(this.orderBD.ListOrderStatus.find(x=> x.Answer === MTRespuesta.Rechazado) === undefined)
          this.flagRechazado=true;
        },
        (error: HttpErrorResponse) => {
        this.spinner.hide();
        console.log(error);
        }
    );
    }


}
