import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { retry, catchError } from 'rxjs/operators';
import { Authentication, Path, Security,Siscose } from '../../constant';
import { Observable } from 'rxjs';
import { AutorizacionService } from './autorizacion.service';
import { LoginRequest } from '../../models/request/authentication/authentication-request.interface';
import { LoginResponse } from '../../models/response/authentication/authentication-response.interface';
import { AccessResponse } from '../../models/response/authentication/authentication-response.interface';
import { Proyecto } from '../../models/response/core/proyecto.interface';

@Injectable({ providedIn: 'root' })
export class GeneralService {
  urlWebApi: string;

  constructor(
    private http: HttpClient,
    private autorizacionService: AutorizacionService
  ) {
    this.urlWebApi = environment.serverUriApi;
  }

  Login(loginModel: LoginRequest): Observable<LoginResponse> {
    return this.http
      .get<LoginResponse>(
        this.urlWebApi + Path.Authentication + Authentication.Login,
        {
          observe: 'body',
          params: { loginRequest: JSON.stringify(loginModel) },
        }
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  Access(): Observable<AccessResponse> {
    return this.http
      .get<AccessResponse>(this.urlWebApi + Path.Security + Security.Access)
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  ListProyectos(): Observable<any> {
    return this.http
      .get<any>(
        this.urlWebApi + Path.Siscose + Siscose.ListProyectos
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  GetProyectoById(proyecto): Observable<Proyecto> {
    return this.http
      .get<Proyecto>(
        this.urlWebApi + Path.Siscose + Siscose.GetProyectoById,
        {
          observe: 'body',
          params: { proyectoRequest: JSON.stringify(proyecto) },
        }
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }
}
