import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { ProyectoRoutingModule } from './proyecto-routing.module';
import { ProyectoComponent } from './proyecto.component';

@NgModule({
    declarations: [
        ProyectoComponent
    ],
    imports: [
      CommonModule,
      ProyectoRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class ProyectoModule { }