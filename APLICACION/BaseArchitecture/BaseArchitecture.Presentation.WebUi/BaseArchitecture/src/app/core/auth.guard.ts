import { Injectable } from '@angular/core';
import {
  Router,
  CanActivate,
  ActivatedRouteSnapshot,
  RouterStateSnapshot,
} from '@angular/router';
import { LocalService } from '../shared/services/general/local.service';
import { environment } from 'src/environments/environment';
import { ToastrService } from 'ngx-toastr';
@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private router: Router,
    private localStorage: LocalService,
    private toastr: ToastrService
  ) {}

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    
    let existeRol: boolean = false;
    debugger
    let pathMenu = this.localStorage.getJsonValue('profileBase');
    
    if (pathMenu) {
      for (let index = 0; index < pathMenu.ListMenuProfile.length; index++) {
        const element = pathMenu.ListMenuProfile[index];
        let pathValidate = element.UrlName.split('/');

        let pathTemp: string =
          pathValidate.length > 1 ? pathValidate[1] : pathValidate[0];
        if (pathTemp === route.routeConfig['path']) {
          existeRol = true;
          break;
        }
      }

      if (existeRol) return true;
      this.toastr.error('No cuenta con accesos, para esa página');
      this.router.navigate(['/']);
      return false;
    } else {
      this.localStorage.clearKey('profileBase');
  

      window.location.replace(environment.urlLogin);
      return false;
    }
  }
}
