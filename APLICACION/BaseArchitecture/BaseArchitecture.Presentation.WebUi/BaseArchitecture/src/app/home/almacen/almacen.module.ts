import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { AlmacenRoutingModule } from './almacen-routing.module';
import { AlmacenComponent } from './almacen.component';

@NgModule({
    declarations: [
        AlmacenComponent
    ],
    imports: [
      CommonModule,
      AlmacenRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class AlmacenModule { }