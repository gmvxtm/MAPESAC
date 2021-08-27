import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { retry, catchError } from 'rxjs/operators';
import { Mapesac, Path, Security } from '../../constant';
import { Observable } from 'rxjs';
import { AutorizacionService } from './autorizacion.service';
import { AccessResponse } from '../../models/response/authentication/authentication-response.interface';
import { UserEntityRequest } from '../../models/request/authentication/authentication-request.interface';

@Injectable({ providedIn: 'root' })
export class GeneralService {
  urlWebApi: string;

  constructor(
    private http: HttpClient,
    private autorizacionService: AutorizacionService
  ) {
    this.urlWebApi = environment.serverUriApi;
  }

  Login(userRequest: UserEntityRequest): Observable<any> {
    debugger
    return this.http
      .get<any>(
        this.urlWebApi + Path.Mapesac + Mapesac.Login,
        {
          observe: 'body',
          params: { userRequest: JSON.stringify(userRequest) },
        }
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  Access(): Observable<AccessResponse> {
    return this.http
      .get<AccessResponse>(this.urlWebApi + Path.Security + Security.Access)
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }
}
