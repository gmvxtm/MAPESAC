import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SharedModule } from '../shared/shared.module';

import { AccountRoutingModule } from './account.routing-module';
import { AuthCallbackComponent } from './auth-callback/auth-callback.component';
import { AuthGuardSesion } from '../core/core.guard';

@NgModule({
  declarations: [
    AuthCallbackComponent
  ],
  providers: [AuthGuardSesion],
  imports: [
    CommonModule,
    FormsModule,
    AccountRoutingModule,
    SharedModule
  ]
})
export class AccountModule { }
