import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { NgxSpinnerService } from 'ngx-spinner';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { HeadersInterface } from 'src/app/shared/models/request/common/headers-request.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { HttpErrorResponse } from '@angular/common/http';
import { ProductEntity } from 'src/app/shared/models/general/table.interface';
import { CustomerEntity, OrderDetailEntity, OrderEntity } from 'src/app/shared/models/request/authentication/authentication-request.interface';
import { createGuidRandom } from 'src/app/shared/util';

@Component({
  selector: 'app-compra',
  templateUrl: './compra.component.html',
  styleUrls: ['./compra.component.css']
})
export class CompraComponent implements OnInit {

    public labelJson: ResponseLabel = new ResponseLabel();
    catalogListSelectedModal: any[] = [];
    ListDepartmentEntity: any[] = [];
    ListDistrictEntity: any[] = [];
    ListProvinceEntity: any[] = [];
    ListProvinceEntityOriginal: any[] = [];
    ListDistrictEntityOriginal: any[] = [];
    orderDetailEntity:  OrderDetailEntity [] = [];
    customerEntity = new CustomerEntity();
    Departamento: string;
    Provincia: string;
    Distrito: string;
    visibleFactura: boolean;
    razonSocial: string;
    ruc: string;

    constructor(
      private spinner: NgxSpinnerService,
      private router: Router,
      private localStorage: LocalService,
      private generalService: GeneralService
    ) { }
  
    ngOnInit(): void {
        this.Departamento = "";
        this.Provincia = "";
        this.Distrito = "";
        this.visibleFactura = false;
        this.catalogListSelectedModal = this.localStorage.getJsonValue('catalogListSelectedModal');
        this.loadUbigeo();
    }

    loadUbigeo = () => {
        this.generalService.ListUbi().subscribe(
            (data: any) => {
            if(data != null){
                this.ListDepartmentEntity = data.Value.ListDepartmentEntity;
                this.ListProvinceEntityOriginal = data.Value.ListProvinceEntity;
                this.ListDistrictEntityOriginal = data.Value.ListDistrictEntity;
            }
            },
            (error: HttpErrorResponse) => {
            this.spinner.hide();
            console.log(error);
            }
        );
    };

    loadProvince = (item) => {
        this.ListProvinceEntity = this.ListProvinceEntityOriginal.filter(x => x.IdDepartment == item);
    }

    loadDistrict = (item) => {
        this.ListDistrictEntity = this.ListDistrictEntityOriginal.filter(x => x.IdProvince == item);
    }

    changeStatus = (item) => {
        if(item.target.checked) {
            this.visibleFactura = true;
        }
        else {
            this.visibleFactura = false;
        }
    }

    sendOrder = () => {

        let orderRequest = new OrderEntity();
        orderRequest.IdOrder = createGuidRandom();
        orderRequest.DateOrder = Date();
        orderRequest.Total = "5000";
        orderRequest.IdCustomer = "3533873D-82E4-4871-B4DE-8A5BC9F41C73";    
        orderRequest.Status = "00101"
        orderRequest.RecordStatus = "A";  
        orderRequest.BusinessName = this.razonSocial;  
        orderRequest.BusinessNumber = this.ruc;  
        orderRequest.CustomerEntity = this.customerEntity;
        orderRequest.CustomerEntity.IdDistrict = this.Distrito;
        orderRequest.ListOrderDetail = this.catalogListSelectedModal;

        debugger
        this.generalService.MergeOrder(orderRequest).subscribe(
            (data: any) => {
                debugger
            },
            (error: HttpErrorResponse) => {
            this.spinner.hide();
            console.log(error);
            }
        );
    }
}
