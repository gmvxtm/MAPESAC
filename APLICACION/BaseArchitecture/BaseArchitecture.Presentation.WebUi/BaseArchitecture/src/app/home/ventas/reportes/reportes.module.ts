import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { ReportesRoutingModule } from './reportes-routing.module';
import { ReportesComponent } from './reportes.component';

@NgModule({
    declarations: [
      ReportesComponent
    ],
    imports: [
      CommonModule,
      ReportesRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class ReportesModule { }