import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { DespachoDetalleRoutingModule } from './despacho-detalle-routing.module';
import { DespachoDetalleComponent } from './despacho-detalle.component';

@NgModule({
    declarations: [
      DespachoDetalleComponent
    ],
    imports: [
      CommonModule,
      DespachoDetalleRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class DespachoDetalleModule { }