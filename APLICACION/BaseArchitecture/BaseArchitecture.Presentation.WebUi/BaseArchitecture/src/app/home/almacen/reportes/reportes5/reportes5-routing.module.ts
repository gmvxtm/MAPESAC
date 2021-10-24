import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { Reportes5Component } from './reportes5.component';

const routes: Routes = [
    {
      path: '',
      component: Reportes5Component
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class Reportes5RoutingModule { }