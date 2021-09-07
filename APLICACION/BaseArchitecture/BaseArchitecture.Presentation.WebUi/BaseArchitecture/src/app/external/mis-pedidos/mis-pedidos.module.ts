import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { MisPedidosRoutingModule } from './mis-pedidos-routing.module';
import { MisPedidosComponent } from './mis-pedidos.component';

@NgModule({
    declarations: [
      MisPedidosComponent
    ],
    imports: [
      CommonModule,
      MisPedidosRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class MisPedidosModule { }