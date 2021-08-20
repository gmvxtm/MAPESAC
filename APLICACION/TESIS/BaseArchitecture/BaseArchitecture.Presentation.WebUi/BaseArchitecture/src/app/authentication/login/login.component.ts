import { Component, OnInit } from '@angular/core';
import { FormatString } from 'src/app/shared/util';
import { environment } from 'src/environments/environment';
import { LogoutType } from 'src/app/shared/constant';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { general, sessionLogin } from 'src/assets/label.json';
import { NgxSpinnerService } from 'ngx-spinner';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent implements OnInit {
  logoutType = LogoutType;
  public labelJson: ResponseLabel = new ResponseLabel();
  
  constructor(
    private spinner: NgxSpinnerService,
    private localService: LocalService,
    private router: Router
  ) {}

  urlLogin = FormatString(
    environment.userActiveDirectory,
    environment.cognitoDomain.concat(environment.authCognito),
    environment.identityProviderAzure,
    environment.clientUrl,
    environment.clientIdAzure
  );

  ngOnInit() {
    this.spinner.hide();
    // if (environment.production) window.location.replace(environment.urlLogin);

    let email = this.localService.getJsonValue('emailBaseArchitecture');
    localStorage.clear();
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker
        .getRegistrations()
        .then((registrations) => {
          for (let registration of registrations) {
            registration.unregister();
          }
        })
        .catch((err) => {
          console.log('Service Worker registration failed: ', err);
        });
    }

    this.labelJson.general = general;
    this.labelJson.login = sessionLogin;
  }

  beginSession = (typeSession: number, session: string) => {
    localStorage.setItem('typeSessionSig', typeSession.toString());
    window.location.replace(session);
  };
}
