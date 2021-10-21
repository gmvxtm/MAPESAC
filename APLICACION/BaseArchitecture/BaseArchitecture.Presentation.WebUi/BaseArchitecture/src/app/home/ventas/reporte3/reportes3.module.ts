import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { Reportes3RoutingModule } from './reportes3-routing.module';
import { Reportes3Component } from './reportes3.component';

@NgModule({
    declarations: [
      Reportes3Component
    ],
    imports: [
      CommonModule,
      Reportes3RoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class Reportes3Module { }