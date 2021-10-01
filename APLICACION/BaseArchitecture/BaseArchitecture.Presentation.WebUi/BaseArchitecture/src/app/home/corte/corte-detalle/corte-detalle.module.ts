import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { CorteDetalleRoutingModule } from './corte-detalle-routing.module';
import { CorteDetalleComponent } from './corte-detalle.component';

@NgModule({
    declarations: [
      CorteDetalleComponent
    ],
    imports: [
      CommonModule,
      CorteDetalleRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class CorteDetalleModule { }