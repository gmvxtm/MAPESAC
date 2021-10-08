import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { NgxSpinnerService } from 'ngx-spinner';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { HeadersInterface } from 'src/app/shared/models/request/common/headers-request.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { HttpErrorResponse } from '@angular/common/http';
import { THIS_EXPR } from '@angular/compiler/src/output/output_ast';
import { BuySupplyEntity, OrderEntity } from 'src/app/shared/models/request/authentication/authentication-request.interface';
import { MTUbicacion } from 'src/app/shared/constant';
import { filterByValue } from 'src/app/shared/util';

@Component({
  selector: 'app-almacen',
  templateUrl: './almacen.component.html',
  styleUrls: ['./almacen.component.css']
})
export class AlmacenComponent implements OnInit {

    public labelJson: ResponseLabel = new ResponseLabel();
    deviceType: string;
    selectedEmployee: string;
    listEmployee: any [] = [];
    itemType: string;
    totalItems: number;
    configTable: {};
    listRisk: any[] = [];
    headers: HeadersInterface[] = new Array<HeadersInterface>();
    ListSuppliesEntity: any[] = [];
    ListSuppliesEntityOriginal: any[] = [];
    nameSupplies: string;
    code: string="";
    description: string="";

    constructor(
      private spinner: NgxSpinnerService,
      private router: Router,
      private localStorage: LocalService,
      private serviceProyecto: GeneralService
    ) { }
  
    ngOnInit(): void {
      this.spinner.show();
      this.createHeadersTable();
      this.loadStart();
      this.loadData();
      
    }

    loadData = () => {
     
      this.serviceProyecto.ListSupplies().subscribe(
        (data: any) => {
          this.ListSuppliesEntity = data.Value;
          this.ListSuppliesEntityOriginal = data.Value;          
          this.totalItems = this.ListSuppliesEntityOriginal.length;
          this.spinner.hide();
        },
        (error: HttpErrorResponse) => {
        this.spinner.hide();
        console.log(error);
        }
      );
    }

    buscarSupplies = () => {
      var filter = {
        CodeSupply: this.code,
        Name: this.description
      };
      this.ListSuppliesEntity= this.ListSuppliesEntityOriginal.filter(function(item) {
        for (var key in filter) {
          if (item[key] === undefined || !item[key].includes(filter[key]))
            return false;
        }
        return true;
      });
      this.totalItems = this.ListSuppliesEntity.length;
      this.code = "";
      this.description = "";
      
    }

    verDetalle = (item) => {
      // debugger
      // this.localStorage.setJsonValue("itemSubOrder",item);  
      // this.router.navigate(['costura/detalle']);
    }

    // filterRisks = () =>{

    //   let filter = this.code.toUpperCase();
    //   let table = (<HTMLTableElement>document.getElementById("myTable"));  
    //   let trs = table.tBodies[0].getElementsByTagName("tr");
    
    //   for (var i = 0; i < trs.length; i++) {
    //     var tds = trs[i].getElementsByTagName("td");
    //     trs[i].style.display = "none";
    //     for (var i2 = 0; i2 < tds.length; i2++) {
    //       if (tds[i2].innerHTML.toUpperCase().indexOf(filter) > -1) {
    //         trs[i].style.display = "";
    //         continue;
    //       }
    //     }
    //   }
    // }
  
    loadStart = () => {
      this.configTable = {
        paging: true,
        searching: false,
        ordering: true,
        lengthChange: true,
        lengthMenu: [5, 10, 15, 20, 25],
        serverSide: false,
        filterColumn: false
      };
    }
  



    createHeadersTable = () => {
      this.headers = [
        {
          primaryKey: 'CodeSupply',
          title: 'Código',
        },
        {
          primaryKey: 'Name',
          title: 'Descripción',
        },
        {
          primaryKey: 'MeasureUnit',
          title: 'Unidad',
        },
        {
          primaryKey: 'Stock',
          title: 'Stock',
        },
        {
          primaryKey: 'DateUpdate',
          title: 'Fec_Act',
        },
        // {
        //   primaryKey: '',
        //   title: 'Acciones',
        //   property: 'button',
        //   buttons: [
        //   {
        //     type: 'edit',
        //     icon: 'fas fa-search',
        //     tooltip: 'Consultar'
        // }
        //   ]
        // }
      ];
    };

 
}
