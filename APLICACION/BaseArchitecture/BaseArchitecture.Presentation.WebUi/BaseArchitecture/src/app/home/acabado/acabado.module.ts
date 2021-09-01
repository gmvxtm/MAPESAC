import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { AcabadoRoutingModule } from './acabado-routing.module';
import { AcabadoComponent } from './acabado.component';

@NgModule({
    declarations: [
      AcabadoComponent
    ],
    imports: [
      CommonModule,
      AcabadoRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class AcabadoModule { }