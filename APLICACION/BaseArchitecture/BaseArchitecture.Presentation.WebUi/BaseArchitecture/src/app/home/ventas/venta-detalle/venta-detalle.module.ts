import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { VentaDetalleRoutingModule } from './venta-detalle-routing.module';
import { VentaDetalleComponent } from './venta-detalle.component';

@NgModule({
    declarations: [
      VentaDetalleComponent
    ],
    imports: [
      CommonModule,
      VentaDetalleRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class VentaDetalleModule { }