import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthCallbackComponent } from './authentication/auth-callback/auth-callback.component';
import { AuthGuardSesion } from './core/core.guard';


const routes: Routes = [
  {
    path: '',
    loadChildren: () => import('./home/layout/layout.module').then(m => m.LayoutModule)
  },
  {
    path: 'Security',
    loadChildren: () => import('./authentication/account.module').then(m => m.AccountModule)
  },
  {
    path: 'login',
    component: AuthCallbackComponent,
    loadChildren: () => import('./authentication/login/login.module').then(m => m.LoginModule)
    , canActivate: [AuthGuardSesion]
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
