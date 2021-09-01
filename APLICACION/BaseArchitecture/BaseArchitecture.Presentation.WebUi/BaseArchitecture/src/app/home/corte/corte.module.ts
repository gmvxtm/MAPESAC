import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { CorteRoutingModule } from './corte-routing.module';
import { CorteComponent } from './corte.component';

@NgModule({
    declarations: [
        CorteComponent
    ],
    imports: [
      CommonModule,
      CorteRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class CorteModule { }