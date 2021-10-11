import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { NgxSpinnerService } from 'ngx-spinner';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { HeadersInterface } from 'src/app/shared/models/request/common/headers-request.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { HttpErrorResponse } from '@angular/common/http';
import { THIS_EXPR } from '@angular/compiler/src/output/output_ast';
import { OrderEntity } from 'src/app/shared/models/request/authentication/authentication-request.interface';
import { Subject } from 'rxjs';
import { MTRespuesta, MTUbicacion } from 'src/app/shared/constant';

declare var anychart: any;

@Component({
  selector: 'app-reportes',
  templateUrl: './reportes.component.html',
  styleUrls: ['./reportes.component.css']
})
export class ReportesComponent implements OnInit {

    public labelJson: ResponseLabel = new ResponseLabel();
    reporteData: any [] = [];

    constructor(
      private spinner: NgxSpinnerService,
      private router: Router,
      private localStorage: LocalService,
      private serviceProyecto: GeneralService,
      private generalService: GeneralService,
    ) { }
  
    ngOnInit(): void {
      this.spinner.show();
      this.loadReport();
   
}
    loadReport = () => {
      this.serviceProyecto.RptListProductQuantity().subscribe(
        (data: any) => {
          data.Value.forEach(element => {
            var obj = [
              element.Name,
              element.Quantity
            ]
            this.reporteData.push(obj);
          });
          var chart = anychart.bar();
          var series = chart.bar(this.reporteData);
          chart.container("container");
          chart.draw();
          this.spinner.hide();
        },
        (error: HttpErrorResponse) => {
        this.spinner.hide();
        console.log(error);
        }
    );
    }

  


 
}
