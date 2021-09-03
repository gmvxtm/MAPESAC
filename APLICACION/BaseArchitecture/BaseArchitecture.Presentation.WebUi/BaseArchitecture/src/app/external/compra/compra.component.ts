import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { NgxSpinnerService } from 'ngx-spinner';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { HeadersInterface } from 'src/app/shared/models/request/common/headers-request.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { HttpErrorResponse } from '@angular/common/http';
import { ProductEntity } from 'src/app/shared/models/general/table.interface';

@Component({
  selector: 'app-compra',
  templateUrl: './compra.component.html',
  styleUrls: ['./compra.component.css']
})
export class CompraComponent implements OnInit {

    public labelJson: ResponseLabel = new ResponseLabel();

    constructor(
      private spinner: NgxSpinnerService,
      private router: Router,
      private localStorage: LocalService,
      private generalService: GeneralService
    ) { }
  
    ngOnInit(): void {

    }
 
}
