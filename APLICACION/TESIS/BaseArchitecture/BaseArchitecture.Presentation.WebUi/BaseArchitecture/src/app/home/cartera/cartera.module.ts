import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { ComponentsModule } from "src/app/component/component.module";
import { SharedModule } from "src/app/shared/shared.module";
import { CarteraRoutingModule } from './cartera-routing.module';
import { CarteraComponent } from './cartera.component';

@NgModule({
    declarations: [
        CarteraComponent
    ],
    imports: [
      CommonModule,
      CarteraRoutingModule,
      FormsModule,
      ComponentsModule,
      SharedModule,
    ]
  })
  export class CarteraModule { }