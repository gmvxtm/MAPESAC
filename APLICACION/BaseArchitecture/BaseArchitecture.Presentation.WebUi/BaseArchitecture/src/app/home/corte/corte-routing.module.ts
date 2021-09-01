import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { CorteComponent } from './corte.component';

const routes: Routes = [
    {
      path: '',
      component: CorteComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CorteRoutingModule { }