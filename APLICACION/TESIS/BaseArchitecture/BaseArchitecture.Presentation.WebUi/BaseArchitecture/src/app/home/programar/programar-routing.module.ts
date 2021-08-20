import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { ProgramarComponent } from './programar.component';

const routes: Routes = [
    {
      path: '',
      component: ProgramarComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProgramarRoutingModule { }