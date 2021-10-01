import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { AcabadoDetalleComponent } from './acabado-detalle.component';

const routes: Routes = [
    {
      path: '',
      component: AcabadoDetalleComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AcabadoDetalleRoutingModule { }