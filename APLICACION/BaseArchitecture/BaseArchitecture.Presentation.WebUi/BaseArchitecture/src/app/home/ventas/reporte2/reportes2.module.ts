import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { Reportes2RoutingModule } from './reportes2-routing.module';
import { Reportes2Component } from './reportes2.component';

@NgModule({
    declarations: [
      Reportes2Component
    ],
    imports: [
      CommonModule,
      Reportes2RoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class Reportes2Module { }