import { Injectable } from '@angular/core';
import {
  HttpInterceptor,
  HttpEvent,
  HttpHandler,
  HttpRequest,
  HttpErrorResponse,
} from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { map, catchError } from 'rxjs/operators';
import { NgxSpinnerService } from 'ngx-spinner';
import { showError, showInfo } from '../../util';
import { LocalService } from './local.service';

@Injectable()
export class TokenInterceptor implements HttpInterceptor {
  constructor(
    private spinner: NgxSpinnerService,
    private localStorage: LocalService
  ) {}

  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    let token = this.localStorage.getJsonValue('tokenBaseArchitecture');

    if (token) {
      request = request.clone({
        headers: request.headers.set('Authorization', token),
      });
    }

    // const userEdit = this.localStorage.getJsonValue('userBaseArchitecture');

    // if (userEdit) {
    //   request = request.clone({
    //     headers: request.headers.set('UserEdit', userEdit.UserEdit),
    //   });
    //   request = request.clone({
    //     headers: request.headers.set(
    //       'AccessDevice',
    //       this.localStorage.getJsonValue('deviceBaseArchitecture')
    //     ),
    //   });
    //   request = request.clone({
    //     headers: request.headers.set('AwsSecretKey', userEdit.AwsSecretKey),
    //   });
    //   request = request.clone({
    //     headers: request.headers.set('AwsAccessKey', userEdit.AwsAccessKey),
    //   });
    //   request = request.clone({
    //     headers: request.headers.set('ProfileId', userEdit.ProfileId),
    //   });
    //   request = request.clone({
    //     headers: request.headers.set(
    //       'AwsSessionToken',
    //       userEdit.AwsSessionToken
    //     ),
    //   });
    // }

    request = request.clone({
      headers: request.headers.set('Accept', 'application/json'),
    });
    request = request.clone({
      headers: request.headers.set('Cache-Control', 'no-cache'),
    });
    request = request.clone({
      headers: request.headers.set('Pragma', 'no-cache'),
    });

    return next.handle(request).pipe(
      map((event: HttpEvent<any>) => {
        return event;
      }),
      catchError((error: HttpErrorResponse) => {
        this.spinner.hide();
        if (error.statusText === 'Unknown Error' || error.status == 504) {
          if (navigator.onLine) showError('No se encuentra el servicio');
          else
            showInfo(
              'Se encuentra sin conexión a internet, todo lo que registre no se visualizará. Terminará el registro una vez se conecte a internet.'
            );
        }
        return throwError(error);
      })
    );
  }
}
