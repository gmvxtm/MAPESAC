import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { PedidoRoutingModule } from './pedido-routing.module';
import { PedidoComponent } from './pedido.component';

@NgModule({
    declarations: [
        PedidoComponent
    ],
    imports: [
      CommonModule,
      PedidoRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class PedidoModule { }