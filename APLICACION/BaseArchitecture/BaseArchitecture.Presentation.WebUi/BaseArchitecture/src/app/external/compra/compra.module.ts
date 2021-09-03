import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { CompraRoutingModule } from './compra-routing.module';
import { CompraComponent } from './compra.component';

@NgModule({
    declarations: [
        CompraComponent
    ],
    imports: [
      CommonModule,
      CompraRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class CompraModule { }