import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { VentasRoutingModule } from './ventas-routing.module';
import { VentasComponent } from './ventas.component';

@NgModule({
    declarations: [
      VentasComponent
    ],
    imports: [
      CommonModule,
      VentasRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class VentasModule { }