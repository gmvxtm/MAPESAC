import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { Reportes1RoutingModule } from './reportes1-routing.module';
import { Reportes1Component } from './reportes1.component';

@NgModule({
    declarations: [
      Reportes1Component
    ],
    imports: [
      CommonModule,
      Reportes1RoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class Reportes1Module { }