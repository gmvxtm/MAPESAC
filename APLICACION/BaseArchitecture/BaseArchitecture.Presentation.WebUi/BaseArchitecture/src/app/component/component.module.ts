import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { SharedModule } from '../shared/shared.module';
import { MenuHeaderComponent } from './menu/header/header.component';
import { MenuResponsiveComponent } from './menu/responsive/responsive.component';
import { MenuDesktopComponent } from './menu/desktop/desktop.component';
import { MenuLeftComponent } from './menu/left/left.component';
import { TableComponent } from './table/table.component';
import { FooterComponent } from './footer/footer.component';
import { UserInfoComponent } from './user-info/user-info.component';
import { MenuOptionComponent } from './menu/option/option.component';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    RouterModule,
    SharedModule,
    ReactiveFormsModule,
  ],
  declarations: [
    MenuResponsiveComponent,
    MenuDesktopComponent,
    MenuHeaderComponent,
    FooterComponent,
    MenuOptionComponent,
    MenuLeftComponent,
    UserInfoComponent,
    TableComponent,
  ],
  exports: [
    MenuResponsiveComponent,
    MenuDesktopComponent,
    MenuHeaderComponent,
    FooterComponent,
    MenuOptionComponent,
    MenuLeftComponent,
    UserInfoComponent,
    TableComponent,
  ],
  entryComponents: [],
  providers: [],
})
export class ComponentsModule {}
