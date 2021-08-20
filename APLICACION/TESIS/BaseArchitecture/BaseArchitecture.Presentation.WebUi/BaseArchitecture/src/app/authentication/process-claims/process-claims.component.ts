import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { HttpErrorResponse } from '@angular/common/http';
import { createGuidRandom, showError } from 'src/app/shared/util';
import { environment } from 'src/environments/environment';
import { LoginRequest } from 'src/app/shared/models/request/authentication/authentication-request.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import {
  Login,
  LoginResponse,
} from 'src/app/shared/models/response/authentication/authentication-response.interface';
import {
  AccessResponse,
  Option,
} from 'src/app/shared/models/response/authentication/authentication-response.interface';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'process-claims-component',
  templateUrl: 'process-claims.component.html',
})
export class ProcessClaimsComponent implements OnInit {
  loginModel: LoginRequest;
  perfilOption$: any[] = [];

  constructor(
    private root: Router,
    private generalService: GeneralService,
    private spinner: NgxSpinnerService,
    private localStorage: LocalService,
    private toastr: ToastrService
  ) {}

  ngOnInit() {
    this.loginModel = this.localStorage.getJsonValue('loginBaseArchitecture');
    if (!this.localStorage.getJsonValue('deviceBaseArchitecture')) {
      this.localStorage.setJsonValue('deviceBaseArchitecture', createGuidRandom());
    }
    // this.loginModel.Device = this.localStorage.getJsonValue('deviceBaseArchitecture');

    this.login();
  }

  login = async () => {
    this.spinner.show();
    this.generalService.Login(this.loginModel).subscribe(
      (data: any) => {
        if (data.State === 409) {
          this.spinner.hide();
          showError('Obtención de claves secretas de aws');
          setTimeout(() => {
            window.location.replace(environment.urlLogin);
          }, 4000);
        } else {
          const userModel: Login = new Login();
          userModel.User = data.Value.User;
          userModel.UserEdit = data.Value.UserEdit;
          userModel.AwsSessionToken = data.Value.AwsSessionToken;
          userModel.AwsAccessKey = data.Value.AwsAccessKey;
          userModel.AwsSecretKey = data.Value.AwsSecretKey;
          userModel.ProfileId = data.Value.ProfileId;

          this.localStorage.setJsonValue('tokenBaseArchitecture', data.Value.Token);
          this.localStorage.setJsonValue('userBaseArchitecture', userModel);

          // this.Access();
          this.root.navigate(['/welcome']);
        }
      },
      (error: HttpErrorResponse) => {
        this.spinner.hide();

        if (error.status === 409) {
          showError(
            'Obtención de claves secretas de aws ' +
              error.error.UniqueIdentifier
          );
          setTimeout(() => {
            window.location.replace(environment.urlLogin);
          }, 4000);
        } else {
          this.toastr.error('error' + ' ' + error.error.UniqueIdentifier || '');
          console.log(error);
          setTimeout(() => {
            window.location.replace(environment.urlLogin);
          }, 4000);
        }
      }
    );
  };

  Access = () => {
    this.generalService.Access().subscribe(
      (data: AccessResponse) => {
        let menu: Option[] = new Array<Option>();

        // data.Value.Profile.forEach((element) => {
        //   element.Option.forEach((option) => {
        //     menu.push(option);
        //   });
        // });

        this.localStorage.setJsonValue('menuBaseArchitecture', menu);
        this.root.navigate(['/']);
      },
      (error: HttpErrorResponse) => {
        this.spinner.hide();
        this.localStorage.clearKey('tokenBaseArchitecture');
        this.localStorage.clearKey('userBaseArchitecture');
        console.log(error);
        this.toastr.error('error' + ' ' + error.error.UniqueIdentifier || '');
      }
    );
  };
}
