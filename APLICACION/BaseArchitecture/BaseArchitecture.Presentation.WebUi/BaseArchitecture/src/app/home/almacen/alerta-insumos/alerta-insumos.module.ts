import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { AlertaInsumosRoutingModule } from './alerta-insumos-routing.module';
import { AlertaInsumosComponent } from './alerta-insumoscomponent';

@NgModule({
    declarations: [
      AlertaInsumosComponent
    ],
    imports: [
      CommonModule,
      AlertaInsumosRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class AlertaInsumosModule { }