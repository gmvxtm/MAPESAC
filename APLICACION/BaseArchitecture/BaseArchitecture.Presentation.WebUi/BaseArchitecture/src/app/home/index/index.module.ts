import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IndexComponent } from './index.component';
import { IndexRoutingModule } from './index-routing.module';
import { FormsModule } from '@angular/forms';
import { SharedModule } from 'src/app/shared/shared.module';
import { ComponentsModule } from 'src/app/component/component.module';

@NgModule({
    imports: [
        CommonModule,
        IndexRoutingModule,
        FormsModule,
        ComponentsModule,
        SharedModule,
    ],
    declarations: [
        IndexComponent
    ]
})
export class IndexModule {

}
