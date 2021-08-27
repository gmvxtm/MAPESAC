import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthCallbackComponent } from './auth-callback/auth-callback.component';
import { AuthGuardSesion } from '../core/core.guard';
import { ProcessComponent } from './Process/process.component';
import { ProcessClaimsComponent } from './process-claims/process-claims.component';

const routes: Routes = [
  {
    path: 'Security'
    , component: AuthCallbackComponent
    , children: [
      {
        path: "Process"
        , component: ProcessComponent
        , canActivate: [AuthGuardSesion]
      },
      {
        path: "Access"
        , component: ProcessClaimsComponent
        , canActivate: [AuthGuardSesion]
      }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
  providers: []
})
export class AccountRoutingModule {

}
