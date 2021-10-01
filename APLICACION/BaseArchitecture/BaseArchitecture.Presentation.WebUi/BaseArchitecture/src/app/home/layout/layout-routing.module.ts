import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthGuard } from 'src/app/core/auth.guard';
import { LayoutComponent } from './layout.component';

const routes: Routes = [
  {
    path: '',
    component: LayoutComponent,
    canActivate: [AuthGuard],
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
        path: 'ventas/detalle',
        loadChildren: () =>
          import('src/app/home/ventas/venta-detalle/venta-detalle.module').then(
            (m) => m.VentaDetalleModule
          ),
          // canActivate: [AuthGuard],
      },
      {
        path: 'corte/detalle',
        loadChildren: () =>
          import('src/app/home/corte/corte-detalle/corte-detalle.module').then(
            (m) => m.CorteDetalleModule
          ),
          // canActivate: [AuthGuard],
      },
      {
        path: 'acabado/detalle',
        loadChildren: () =>
          import('src/app/home/acabado/acabado-detalle/acabado-detalle.module').then(
            (m) => m.AcabadoDetalleModule
          ),
          // canActivate: [AuthGuard],
      },
      {
        path: 'lavanderia/detalle',
        loadChildren: () =>
          import('src/app/home/lavanderia/lavanderia-detalle/lavanderia-detalle.module').then(
            (m) => m.LavanderiaDetalleModule
          ),
          // canActivate: [AuthGuard],
      },
      {
        path: 'costura/detalle',
        loadChildren: () =>
          import('src/app/home/costura/costura-detalle/costura-detalle.module').then(
            (m) => m.CosturaDetalleModule
          ),
          // canActivate: [AuthGuard],
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
