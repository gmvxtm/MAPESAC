import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthCallbackComponent } from './authentication/auth-callback/auth-callback.component';
import { AuthGuardSesion } from './core/core.guard';


const routes: Routes = [
  {
    path: '',
    loadChildren: () => import('./authentication/login/login.module').then(m => m.LoginModule)
  },
  {
    path: 'Security',
    loadChildren: () => import('./authentication/account.module').then(m => m.AccountModule)
  },
  {
    path: 'login',
    component: AuthCallbackComponent,
    loadChildren: () => import('./authentication/login/login.module').then(m => m.LoginModule)
    //, canActivate: [AuthGuardSesion]
  },
  {
    path: 'catalogo',
    loadChildren: () =>
      import('src/app/external/pedido/pedido.module').then(
        (m) => m.PedidoModule
      ),
  },
  {
    path: 'compra',
    loadChildren: () =>
      import('src/app/external/compra/compra.module').then(
        (m) => m.CompraModule
      ),
  },
  {
    path: 'mispedidos',
    loadChildren: () =>
      import('src/app/external/mis-pedidos/mis-pedidos.module').then(
        (m) => m.MisPedidosModule
      ),
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
