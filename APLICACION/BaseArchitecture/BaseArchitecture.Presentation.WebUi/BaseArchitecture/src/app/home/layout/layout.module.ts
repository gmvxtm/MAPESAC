import { CommonModule } from '@angular/common';
import {
  NgModule,
} from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ComponentsModule } from 'src/app/component/component.module';
import { SharedModule } from 'src/app/shared/shared.module';
import { IndexModule } from '../index/index.module';
import { LayoutRoutingModule } from './layout-routing.module';
import { LayoutComponent } from './layout.component';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    LayoutRoutingModule,
    IndexModule,
    ComponentsModule,
    SharedModule,
  ],
  declarations: [LayoutComponent],
})
export class LayoutModule {}
