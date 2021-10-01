import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { CosturaDetalleRoutingModule } from './costura-detalle-routing.module';
import { CosturaDetalleComponent } from './costura-detalle.component';

@NgModule({
    declarations: [
      CosturaDetalleComponent
    ],
    imports: [
      CommonModule,
      CosturaDetalleRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class CosturaDetalleModule { }