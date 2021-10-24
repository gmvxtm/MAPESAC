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
  templateUrl: './reportes1.component.html',
  styleUrls: ['./reportes1.component.css']
})
export class Reportes1Component implements OnInit {

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
      this.serviceProyecto.RptListSuppliesMostUsedByMonth().subscribe(
        (data: any) => {
          debugger
          data.Value.forEach(element => {
            var obj = [
              element.DateGroup,
              element.QuantityUsed,
            ]
            this.reporteData.push(obj);
          });
          var chart = anychart.bar();
          var series = chart.bar(this.reporteData);
          series.normal().fill("#00cc99", 0.3);
          chart.title("MOST");
          chart.xAxis().title("Mes");
          chart.yAxis().title("Cantidad");
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
