import { Component, OnInit } from '@angular/core';
import { FormatString } from 'src/app/shared/util';
import { environment } from 'src/environments/environment';
import { LogoutType } from 'src/app/shared/constant';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { general, sessionLogin } from 'src/assets/label.json';
import { NgxSpinnerService } from 'ngx-spinner';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { Router } from '@angular/router';
import { THIS_EXPR } from '@angular/compiler/src/output/output_ast';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent implements OnInit {
  logoutType = LogoutType;
  usuario: string;
  password: string;
  public labelJson: ResponseLabel = new ResponseLabel();
  
  constructor(
    private spinner: NgxSpinnerService,
    private localService: LocalService,
    private router: Router
  ) {}

  ngOnInit() {
    this.spinner.hide();
    this.labelJson.general = general;
    this.labelJson.login = sessionLogin;
  }

  beginSession = () => {
    this.router.navigate(['cartera'])
  }
}
