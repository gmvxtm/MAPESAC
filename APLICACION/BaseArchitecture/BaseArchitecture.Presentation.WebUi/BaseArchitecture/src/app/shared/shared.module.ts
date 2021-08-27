import {
  CUSTOM_ELEMENTS_SCHEMA,
  NgModule,
  NO_ERRORS_SCHEMA,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { ToastrModule } from 'ngx-toastr';
import { NgxSpinnerModule } from 'ngx-spinner';
import { ModalModule } from 'ngx-bootstrap/modal';
import { TypeaheadModule } from 'ngx-bootstrap/typeahead';
import {
  BsDatepickerConfig,
  BsDatepickerModule,
  BsLocaleService,
} from 'ngx-bootstrap/datepicker';
import { Ng2IziToastModule } from 'ng2-izitoast';
import { defineLocale, esLocale } from 'ngx-bootstrap/chronos';
import { CollapseModule } from 'ngx-bootstrap/collapse';
import { AccordionModule } from 'ngx-bootstrap/accordion';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { ProgressbarModule } from 'ngx-bootstrap/progressbar';
import { TabsetConfig, TabsModule } from 'ngx-bootstrap/tabs';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { BsDropdownModule } from 'ngx-bootstrap/dropdown';
import { PerfectScrollbarModule } from 'ngx-perfect-scrollbar';

  @NgModule({
    imports: [
      CommonModule,
      ToastrModule.forRoot({
        timeOut: 3000,
        positionClass: 'toast-bottom-right',
        preventDuplicates: true,
      }),
      NgxSpinnerModule,
      TypeaheadModule.forRoot(),
      ModalModule.forRoot(),
      Ng2IziToastModule,
      BsDatepickerModule.forRoot(),
      CollapseModule.forRoot(),
      AccordionModule.forRoot(),
      PaginationModule.forRoot(),
      ProgressbarModule.forRoot(),
      TabsModule.forRoot(),
      TooltipModule.forRoot(),
      BsDropdownModule.forRoot(),
      PerfectScrollbarModule
    ],
    declarations: [
      
    ],
    exports: [
      ToastrModule,
      NgxSpinnerModule,
      TypeaheadModule,
      ModalModule,
      Ng2IziToastModule,
      BsDatepickerModule,
      CollapseModule,
      AccordionModule,
      PaginationModule,
      ProgressbarModule,
      TabsModule,
      TooltipModule,
      BsDropdownModule,
      PerfectScrollbarModule
    ],
    providers: [
      BsLocaleService,
      BsDatepickerConfig,
      { provide: TabsetConfig, useFactory: getTabsetConfig },
    ],
    schemas: [NO_ERRORS_SCHEMA, CUSTOM_ELEMENTS_SCHEMA],
  })
  export class SharedModule {
    constructor(private _localeService: BsLocaleService) {
      esLocale.invalidDate = 'Fecha Inválida';
      defineLocale('es', esLocale);
      this._localeService.use('es');
    }
  }
  
  export function getTabsetConfig(): TabsetConfig {
    return Object.assign(new TabsetConfig(), {
      type: 'pills',
      isKeysAllowed: true,
    });
  }
  