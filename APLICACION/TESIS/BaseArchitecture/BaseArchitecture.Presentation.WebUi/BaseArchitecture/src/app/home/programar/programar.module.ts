import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { ProgramarRoutingModule } from './programar-routing.module';
import { ProgramarComponent } from './programar.component';

@NgModule({
    declarations: [
        ProgramarComponent
    ],
    imports: [
      CommonModule,
      ProgramarRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class ProgramarModule { }