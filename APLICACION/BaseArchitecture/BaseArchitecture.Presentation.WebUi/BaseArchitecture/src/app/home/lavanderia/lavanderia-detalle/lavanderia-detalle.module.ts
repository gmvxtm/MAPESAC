import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { LavanderiaDetalleRoutingModule } from './lavanderia-detalle-routing.module';
import { LavanderiaDetalleComponent } from './lavanderia-detalle.component';

@NgModule({
    declarations: [
      LavanderiaDetalleComponent
    ],
    imports: [
      CommonModule,
      LavanderiaDetalleRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class LavanderiaDetalleModule { }