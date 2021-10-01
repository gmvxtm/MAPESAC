import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { CorteDetalleComponent } from './corte-detalle.component';

const routes: Routes = [
    {
      path: '',
      component: CorteDetalleComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CorteDetalleRoutingModule { }