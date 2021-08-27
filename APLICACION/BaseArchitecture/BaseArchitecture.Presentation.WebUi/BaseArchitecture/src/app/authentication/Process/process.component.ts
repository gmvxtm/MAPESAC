import { Component, OnInit } from '@angular/core';

import { NgxSpinnerService } from 'ngx-spinner';
import { LoginRequest } from 'src/app/shared/models/request/authentication/authentication-request.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';


@Component({
  selector: 'process-component',
  templateUrl: 'process.component.html',
})
export class ProcessComponent implements OnInit {
  loginModel: LoginRequest = new LoginRequest();

  constructor(
    private spinner: NgxSpinnerService,
    private localStorage: LocalService
  ) {
    this.localStorage.clearKey('tokenBaseArchitecture');
    this.localStorage.clearKey('userBaseArchitecture');
    this.localStorage.clearKey('errorBaseArchitecture');
  }

  ngOnInit() {
    this.spinner.show();
    setTimeout(() => {
      let hash = window.location.hash.substr(1);

      var resp = hash.split('&').reduce(function (result, item) {
        
        var parts = item.split('=');
        
        result[
          parts[0]
            .replace('_', ' ')
            .replace(/\b./g, (c) => c.toUpperCase())
            .replace(' ', '')
        ] = parts[1];
        
        return result;
      }, {});

      this.localStorage.setJsonValue('loginBaseArchitecture', resp);

      const url =
        window.location.origin +
        window.location.pathname.replace('Process', 'Access');
      this.spinner.hide();
      window.location.replace(url);
    }, 5000);
  }
}
