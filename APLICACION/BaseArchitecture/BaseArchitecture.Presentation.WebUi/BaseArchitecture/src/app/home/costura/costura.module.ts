import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { CosturaRoutingModule } from './costura-routing.module';
import { CosturaComponent } from './costura.component';

@NgModule({
    declarations: [
      CosturaComponent
    ],
    imports: [
      CommonModule,
      CosturaRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class CosturaModule { }