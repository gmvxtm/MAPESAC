import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { NgxSpinnerService } from 'ngx-spinner';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { HeadersInterface } from 'src/app/shared/models/request/common/headers-request.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { HttpErrorResponse } from '@angular/common/http';
import { ProductEntity } from 'src/app/shared/models/general/table.interface';
import { BsModalRef, BsModalService } from 'ngx-bootstrap/modal';
import { Subject } from 'rxjs';
import { ModalComponent } from '../modal/modal.component';

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
    countCart = 0;
    catalogListSelected: any[] = [];
    catalogListSelectedModal: any[] = [];
    constructor(
      private spinner: NgxSpinnerService,
      private router: Router,
      private modalService: BsModalService,
      private localStorage: LocalService,
      private generalService: GeneralService
    ) { }
  
    ngOnInit(): void {
      this.createHeadersTable();
      this.loadStart();
      this.createCatalog();
    }
  
    loadStart = () => {
      this.configTable = {
        paging: true,
        searching: false,
        ordering: true,
        lengthChange: true,
        lengthMenu: [5, 10, 15, 20, 25],
        serverSide: false,
        filterColumn: true
      };
    }
  
    createCatalog = () => {

      // this.generalService.ListProduct().subscribe(
      //   (data: any) => {
      //     if(data != null){
      //       this.catalogInitProductEntity = data.Value;
      //     }
      //   },
      //   (error: HttpErrorResponse) => {
      //     this.spinner.hide();
      //     console.log(error);
      //   }
      // );

      this.catalogInitProductEntity = [
        {
          IdProduct:"4fecb6ff-0508-45c2-a2c2-84c2f51514f6",
          Name:"Modelo A",
          PathFile:"../../../assets/media/jean.png",
          PriceUnit:3,
          RecordStatus:"A",
          Quantity:0
          },
          {
          IdProduct:"abd7c103-7799-405a-bd90-9b0cffd6a82a",
          Name:"Modelo B",
          PathFile:"../../../assets/media/jean.png",
          PriceUnit:1,
          RecordStatus:"A",
          Quantity:0
          },
      ]
    }


    addProduct = (item) => {
      if(this.catalogListSelected.filter(x=> x.IdProduct === item.IdProduct).length ===1)
      {
        var listaCatalogo = this.catalogListSelected.filter(x=>x.IdProduct === item.IdProduct);
        listaCatalogo[0].Quantity =Number(listaCatalogo[0].Quantity)+1;// item.Quantity;
        var listaSinCatalogo = this.catalogListSelected.filter(x=>x.IdProduct != item.IdProduct);
        listaSinCatalogo.push(listaCatalogo[0]);
        this.catalogListSelected=listaSinCatalogo;
      }
      else
      {
        item.Quantity = 1;
        this.catalogListSelected.push(item)
      }
      this.countCart = this.catalogListSelected.length;
      this.catalogListSelectedModal = this.catalogListSelected.filter(x => x);
    }


    openModal = () =>{
      this.bsModalRefP = this.modalService.show(ModalComponent, {
        initialState: {
          item: <any>{   
            lista: this.catalogListSelectedModal
          },
        },
        backdrop: 'static',
        keyboard: false,
      });
  
      (<ModalComponent>this.bsModalRefP.content).onClose.subscribe(
        (result: any) => {
          if (result) {
  
          }
          this.bsModalRefP.hide();
        }
      );
      this.bsModalRefP.content.closeBtnName = 'Close';
    }

    redirectCompra = () => {
      this.router.navigate(['compra']);
    }

    createHeadersTable = () => {
      this.headers = [
        {
          primaryKey: 'Codigo',
          title: 'Código',
        },
        {
          primaryKey: 'InversionDescripcion',
          title: 'Tipo de Inversión',
        },
        {
          primaryKey: 'CicloDescripcion',
          title: 'Ciclo de Inversión',
        },
        {
          primaryKey: 'NaturalezaDescripcion',
          title: 'Naturaleza',
        },
        {
          primaryKey: 'Nombre',
          title: 'Nombre',
        },
        {
          primaryKey: 'Departamento',
          title: 'Departamento',
        },
        {
          primaryKey: 'Costo',
          title: 'Costo',
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