import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { ReportesDespachoRoutingModule } from './reportes-routing.module';
import { ReportesDespachoComponent } from './reportes.component';

@NgModule({
    declarations: [
      ReportesDespachoComponent
    ],
    imports: [
      CommonModule,
      ReportesDespachoRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class ReportesDespachoModule { }