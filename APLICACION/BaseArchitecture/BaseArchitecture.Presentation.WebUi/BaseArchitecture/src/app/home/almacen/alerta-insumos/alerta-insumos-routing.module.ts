import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { AlertaInsumosComponent } from './alerta-insumoscomponent';

const routes: Routes = [
    {
      path: '',
      component: AlertaInsumosComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AlertaInsumosRoutingModule { }