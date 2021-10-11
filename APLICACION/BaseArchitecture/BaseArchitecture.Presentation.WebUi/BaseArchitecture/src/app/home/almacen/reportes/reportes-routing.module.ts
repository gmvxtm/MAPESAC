import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { ReportesAlmacenComponent } from './reportes.component';

const routes: Routes = [
    {
      path: '',
      component: ReportesAlmacenComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ReportesAlmacenRoutingModule { }