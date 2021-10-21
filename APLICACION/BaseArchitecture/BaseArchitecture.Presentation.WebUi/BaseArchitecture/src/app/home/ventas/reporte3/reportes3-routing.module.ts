import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { Reportes3Component } from './reportes3.component';

const routes: Routes = [
    {
      path: '',
      component: Reportes3Component
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class Reportes3RoutingModule { }