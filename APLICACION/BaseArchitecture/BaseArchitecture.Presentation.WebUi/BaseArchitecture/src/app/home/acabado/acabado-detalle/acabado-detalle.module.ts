import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { AcabadoDetalleRoutingModule } from './acabado-detalle-routing.module';
import { AcabadoDetalleComponent } from './acabado-detalle.component';

@NgModule({
    declarations: [
      AcabadoDetalleComponent
    ],
    imports: [
      CommonModule,
      AcabadoDetalleRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class AcabadoDetalleModule { }