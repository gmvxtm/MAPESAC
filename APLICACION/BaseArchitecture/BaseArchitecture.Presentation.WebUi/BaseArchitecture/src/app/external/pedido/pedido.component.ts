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

var $: any;

@Component({
  selector: 'app-pedido',
  templateUrl: './pedido.component.html',
  styleUrls: ['./pedido.component.css']
})
export class PedidoComponent implements OnInit {

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
    catalogInitProductEntityOriginal : any[] = [];
    countCart = 0;
    catalogListSelected: any[] = [];
    catalogListSelectedModal: any[] = [];
    totalQuantity = 0;
    constructor(
      private spinner: NgxSpinnerService,
      private router: Router,
      private localStorage: LocalService,
      private generalService: GeneralService
    ) { }
  
    ngOnInit(): void {
      this.createCatalog();
    }
  
    createCatalog = () => {

      this.generalService.ListProduct().subscribe(
        (data: any) => {
          if(data != null){
            this.catalogInitProductEntityOriginal = data.Value;
            this.catalogInitProductEntity = this.catalogInitProductEntityOriginal;
          }
        },
        (error: HttpErrorResponse) => {
          this.spinner.hide();
          console.log(error);
        }
      );
    }


    addProduct = (item) => {

      this.catalogInitProductEntity.forEach( x => {
          if(x.IdProduct == item.IdProduct){
            x.indicador = 1;
          }
      })

      if(this.catalogListSelected.filter(x=> x.IdProduct === item.IdProduct).length ===1)
      {
        var listaCatalogo = this.catalogListSelected.filter(x=>x.IdProduct === item.IdProduct);
        if(listaCatalogo[0].Quantity  != item.Quantity)
        {
          listaCatalogo[0].Quantity =Number(listaCatalogo[0].Quantity)+item.Quantity;
          var listaSinCatalogo = this.catalogListSelected.filter(x=>x.IdProduct != item.IdProduct);
          listaSinCatalogo.push(listaCatalogo[0]);
          this.catalogListSelected=listaSinCatalogo;
        }
      }
      else
      {
        this.catalogListSelected.push(item)
      }
      this.countCart = this.catalogListSelected.length;
      this.catalogListSelectedModal = this.catalogListSelected.filter(x => x);

      this.totalQuantity = 0;
      this.catalogListSelectedModal.forEach(element => {        
        element.Total =element.Quantity*element.PriceUnit;
        this.totalQuantity =this.totalQuantity+ element.Total;
      });
    }

    redirectCompra = () => {
      this.localStorage.setJsonValue('catalogListSelectedModal',  this.catalogListSelectedModal);
      this.router.navigate(['compra']);
    }

    quantitychange =() => {
      this.totalQuantity = 0;
      this.catalogListSelectedModal.forEach(element => {        
        element.Total =element.Quantity*element.PriceUnit;
        this.totalQuantity =this.totalQuantity+ element.Total;
      });
      
    }

}
