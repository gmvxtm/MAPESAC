import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { Reportes5RoutingModule } from './reportes5-routing.module';
import { Reportes5Component } from './reportes5.component';

@NgModule({
    declarations: [
      Reportes5Component
    ],
    imports: [
      CommonModule,
      Reportes5RoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class Reportes5Module { }