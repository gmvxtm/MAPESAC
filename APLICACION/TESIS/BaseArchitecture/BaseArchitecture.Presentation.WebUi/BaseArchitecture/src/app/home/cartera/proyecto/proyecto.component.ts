import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { NgxSpinnerService } from 'ngx-spinner';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { HttpErrorResponse } from '@angular/common/http';
import { Proyecto } from 'src/app/shared/models/response/core/proyecto.interface';

declare var anychart: any;

@Component({
  selector: 'app-proyecto',
  templateUrl: './proyecto.component.html',
  styleUrls: ['./proyecto.component.css']
})
export class ProyectoComponent implements OnInit {

    public labelJson: ResponseLabel = new ResponseLabel();
    proyecto = new Proyecto();
    proyectoResponse = new Proyecto();

    constructor(
      private spinner: NgxSpinnerService,
      private router: Router,
      private localStorage: LocalService,
      private serviceProyecto: GeneralService
    ) { }
  
    ngOnInit(): void {
        this.spinner.show();
        this.proyecto = this.localStorage.getJsonValue('RequestProyecto');
        this.GetProyectoById(this.proyecto);
        

    }

    GetProyectoById = (proyecto) => {
      
      this.serviceProyecto.GetProyectoById(proyecto).subscribe(
        (data: any) => {
          this.spinner.hide();
          this.proyectoResponse = data.Value;
          var IdDepartamento = this.proyectoResponse.IdDepartamento;
          this.LoadMap(IdDepartamento);
        },
        (error: HttpErrorResponse) => {
          this.spinner.hide();
        }
      );
    }

    LoadMap = (IdDepartamento) => {
      anychart.onDocumentReady(()=> {

        debugger
        // create map
        var map = anychart.map();      

        // create data set
        var dataSet = anychart.data.set(
            [
            {"id":"PE.3341","value":0},
            {"id":"PE.AM","value":1},
            {"id":"PE.AN","value":2},
            {"id":"PE.AP","value":3},
            {"id":"PE.AR","value":4},
            {"id":"PE.AY","value":5},
            {"id":"PE.CJ","value":6},
            {"id":"PE.LR","value":7},
            {"id":"PE.CS","value":8},
            {"id":"PE.HV","value":9},
            {"id":"PE.HC","value":10},
            {"id":"PE.IC","value":11},
            {"id":"PE.JU","value":12},
            {"id":"PE.LL","value":13},
            {"id":"PE.LB","value":14},
            {"id":"PE.148","value":15},
            {"id":"PE.LO","value":16},
            {"id":"PE.MD","value":17},
            {"id":"PE.MQ","value":18},
            {"id":"PE.PA","value":19},
            {"id":"PE.PI","value":20},
            {"id":"PE.CL","value":21},
            {"id":"PE.SM","value":22},
            {"id":"PE.TA","value":23},
            {"id":"PE.TU","value":24},
            {"id":"PE.UC","value":25}
            ]);
      
        dataSet.mc.forEach(element => {
          if(element.value == IdDepartamento){
            debugger
            dataSet.mc[IdDepartamento].fill = '#addd8e'
            console.log("1 coincidencia")
          }
        });

      console.log(dataSet)
        // create choropleth series
       var series = map.choropleth(dataSet);

       map.unboundRegions().fill('#eee');
      
        // set geoIdField to 'id', this field contains in geo data meta properties
        series.geoIdField('id');
      
        // set map color settings
        // series.colorScale(anychart.scales.linearColor('#deebf7', '#3182bd'));
        series.hovered().fill('#addd8e');
        
      
        // set geo data, you can find this map in our geo maps collection
        // https://cdn.anychart.com/#maps-collection
        map.geoData(anychart.maps['peru']);
      
        //set map container id (div)
        map.container('container');
      
        //initiate map drawing
        map.draw();
      });
    }

    
}
