import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { CosturaDetalleComponent } from './costura-detalle.component';

const routes: Routes = [
    {
      path: '',
      component: CosturaDetalleComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CosturaDetalleRoutingModule { }