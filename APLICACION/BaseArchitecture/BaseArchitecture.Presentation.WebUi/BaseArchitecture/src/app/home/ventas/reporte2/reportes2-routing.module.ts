import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { Reportes2Component } from './reportes2.component';

const routes: Routes = [
    {
      path: '',
      component: Reportes2Component
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class Reportes2RoutingModule { }