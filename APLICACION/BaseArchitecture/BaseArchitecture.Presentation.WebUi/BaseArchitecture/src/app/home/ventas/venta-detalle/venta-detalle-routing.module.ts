import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { VentaDetalleComponent } from './venta-detalle.component';

const routes: Routes = [
    {
      path: '',
      component: VentaDetalleComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class VentaDetalleRoutingModule { }