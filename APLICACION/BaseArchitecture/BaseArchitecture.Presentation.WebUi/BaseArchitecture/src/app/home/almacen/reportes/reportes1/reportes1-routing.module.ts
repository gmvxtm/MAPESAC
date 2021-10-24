import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { Reportes1Component } from './reportes1.component';

const routes: Routes = [
    {
      path: '',
      component: Reportes1Component
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class Reportes1RoutingModule { }