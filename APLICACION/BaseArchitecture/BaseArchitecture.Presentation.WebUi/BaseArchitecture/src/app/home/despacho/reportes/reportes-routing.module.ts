import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { ReportesDespachoComponent } from './reportes.component';

const routes: Routes = [
    {
      path: '',
      component: ReportesDespachoComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ReportesDespachoRoutingModule { }