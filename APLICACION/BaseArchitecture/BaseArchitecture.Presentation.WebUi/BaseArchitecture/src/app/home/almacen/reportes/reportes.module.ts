import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { ReportesAlmacenRoutingModule } from './reportes-routing.module';
import { ReportesAlmacenComponent } from './reportes.component';

@NgModule({
    declarations: [
      ReportesAlmacenComponent
    ],
    imports: [
      CommonModule,
      ReportesAlmacenRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class ReportesAlmacenModule { }