import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthGuard } from 'src/app/core/auth.guard';
import { LayoutComponent } from './layout.component';

const routes: Routes = [
  {
    path: '',
    component: LayoutComponent,
    children: [
      {
        path: 'welcome',
        loadChildren: () =>
          import('src/app/home/index/index.module').then((m) => m.IndexModule),
          canActivate: [AuthGuard],
      },
      {
        path: 'ventas',
        loadChildren: () =>
          import('src/app/home/ventas/ventas.module').then(
            (m) => m.VentasModule
          ),
          canActivate: [AuthGuard],
      },
      {
        path: 'almacen',
        loadChildren: () =>
          import('src/app/home/almacen/almacen.module').then(
            (m) => m.AlmacenModule
          ),
          canActivate: [AuthGuard],
      },
      {
        path: 'corte',
        loadChildren: () =>
          import('src/app/home/corte/corte.module').then(
            (m) => m.CorteModule
          ),
          canActivate: [AuthGuard],
      },
      {
        path: 'costura',
        loadChildren: () =>
          import('src/app/home/costura/costura.module').then(
            (m) => m.CosturaModule
          ),
          canActivate: [AuthGuard],
      },
      {
        path: 'lavanderia',
        loadChildren: () =>
          import('src/app/home/lavanderia/lavanderia.module').then(
            (m) => m.LavanderiaModule
          ),
          canActivate: [AuthGuard],
      },
      {
        path: 'acabado',
        loadChildren: () =>
          import('src/app/home/acabado/acabado.module').then(
            (m) => m.AcabadoModule
          ),
          canActivate: [AuthGuard],
      },
      {
        path: 'despacho',
        loadChildren: () =>
          import('src/app/home/despacho/despacho.module').then(
            (m) => m.DespachoModule
          ),
          canActivate: [AuthGuard],
      },

    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class LayoutRoutingModule {}
