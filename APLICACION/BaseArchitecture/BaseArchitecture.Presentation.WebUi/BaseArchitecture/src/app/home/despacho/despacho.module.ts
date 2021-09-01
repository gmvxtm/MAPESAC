import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { DespachoRoutingModule } from './despacho-routing.module';
import { DespachoComponent } from './despacho.component';

@NgModule({
    declarations: [
      DespachoComponent
    ],
    imports: [
      CommonModule,
      DespachoRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class DespachoModule { }