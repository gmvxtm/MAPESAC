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
        // canActivate: [AuthGuard],
      },
      {
        path: 'register',
        loadChildren: () =>
          import('src/app/home/register/register.module').then(
            (m) => m.RegisterModule
          ),
      },
      {
        path: 'programar',
        loadChildren: () =>
          import('src/app/home/programar/programar.module').then(
            (m) => m.ProgramarModule
          ),
      },
      {
        path: 'cartera',
        loadChildren: () =>
          import('src/app/home/cartera/cartera.module').then(
            (m) => m.CarteraModule
          ),
      },
      {
        path: 'cartera/detail',
        loadChildren: () =>
          import('src/app/home/cartera/proyecto/proyecto.module').then(
            (m) => m.ProyectoModule
          ),
      }
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class LayoutRoutingModule {}
