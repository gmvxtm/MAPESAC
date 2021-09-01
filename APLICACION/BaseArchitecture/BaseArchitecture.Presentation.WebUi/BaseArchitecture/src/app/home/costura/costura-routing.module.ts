import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { CosturaComponent } from './costura.component';

const routes: Routes = [
    {
      path: '',
      component: CosturaComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CosturaRoutingModule { }