import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { LavanderiaComponent } from './lavanderia.component';

const routes: Routes = [
    {
      path: '',
      component: LavanderiaComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class LavanderiaRoutingModule { }