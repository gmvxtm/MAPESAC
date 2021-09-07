import { Injectable } from '@angular/core';
import {
  Router,
  CanActivate,
  ActivatedRouteSnapshot,
  RouterStateSnapshot,
} from '@angular/router';
import { LocalService } from '../shared/services/general/local.service';

@Injectable()
export class AuthGuardSesion implements CanActivate {
  constructor(private router: Router, private localStorage: LocalService) {}

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): boolean {
    debugger
    let token = this.localStorage.getJsonValue('profileBase');
    if (!token) {
      return true;
    }
    this.router.navigate(['/']);
    return false;
  }
}
