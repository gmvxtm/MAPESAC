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
import { createGuidRandom, showInfo, showSuccess } from 'src/app/shared/util';

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
        debugger
        this.catalogListSelectedModal.forEach(element => {
            element.Total =element.Quantity*element.PriceUnit;
        });
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

        if( this.customerEntity.FirstName === undefined ||  this.customerEntity.FirstName.trim() === "" )
        {   showInfo("Se debe registrar los Nombres"); return; }
        if( this.customerEntity.LastName === undefined || this.customerEntity.LastName.trim() === "" )
        {   showInfo("Se debe registrar los Apellidos"); return; }
        if(this.customerEntity.Email === undefined ||  this.customerEntity.Email.trim() === "" )
        {   showInfo("Se debe registrar el correo"); return; }
        if( this.customerEntity.PhoneNumber === undefined || this.customerEntity.PhoneNumber.trim() === "" )
        {   showInfo("Se debe registrar el Telefono"); return;}
        if(this.customerEntity.DocumentNumber === undefined || this.customerEntity.DocumentNumber.trim() === "" )
        {   showInfo("Se debe registrar DNI"); return; }
        if(this.Departamento=== undefined ||  this.Departamento.trim() === "" )
        {   showInfo("Se debe seleccionar Departamento"); return; }
        if( this.Provincia === undefined || this.Provincia.trim() === "" )
        {   showInfo("Se debe seleccionar Provincia"); return; }
        if( this.Distrito === undefined || this.Distrito.trim() === "" )
        {   showInfo("Se debe seleccionar Distrito"); return; }
        if(this.visibleFactura === true)
        {
            if( this.ruc === undefined || this.ruc.trim() === "" )
            {   showInfo("Se debe registrar Ruc"); return; }    
            if( this.razonSocial === undefined || this.razonSocial === null )
            {   showInfo("Se debe selecciregistrar  Razon Social"); return; }
        }

        let orderRequest = new OrderEntity();
        orderRequest.IdOrder = createGuidRandom();
        orderRequest.DateOrder = Date();
        orderRequest.Total = "5000";
        orderRequest.IdCustomer = createGuidRandom();    
        orderRequest.StatusOrder = "00101";        
        orderRequest.RecordStatus = "A";  
        orderRequest.BusinessName = this.razonSocial=== null ? "":this.razonSocial;  
        orderRequest.BusinessNumber = this.ruc=== null ? "":this.ruc;  
        orderRequest.CustomerEntity = this.customerEntity;
        orderRequest.CustomerEntity.IdDistrict = this.Distrito;
        orderRequest.CustomerEntity.IdCustomer=  orderRequest.IdCustomer;
        orderRequest.CustomerEntity.RecordStatus = "A"; 
        orderRequest.ListOrderDetail = this.catalogListSelectedModal;

        this.generalService.MergeOrder(orderRequest).subscribe(
            (data: any) => {
                var codeOrder =data.Value;
                showSuccess("Se registro la orden: " + codeOrder);
                setTimeout(() => {
                    this.localStorage.clearKey('catalogListSelectedModal');
                    this.router.navigate(['catalogo']);
                }, 2);
            },
            (error: HttpErrorResponse) => {
            this.spinner.hide();
            console.log(error);
            }
        );
    }
}
