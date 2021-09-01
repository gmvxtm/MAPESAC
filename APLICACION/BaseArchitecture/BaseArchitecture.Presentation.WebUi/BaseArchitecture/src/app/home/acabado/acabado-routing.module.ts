import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { AcabadoComponent } from './acabado.component';

const routes: Routes = [
    {
      path: '',
      component: AcabadoComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AcabadoRoutingModule { }