import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { DespachoDetalleComponent } from './despacho-detalle.component';

const routes: Routes = [
    {
      path: '',
      component: DespachoDetalleComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DespachoDetalleRoutingModule { }