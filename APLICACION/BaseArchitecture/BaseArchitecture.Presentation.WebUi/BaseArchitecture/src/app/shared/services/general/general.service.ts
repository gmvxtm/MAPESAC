import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { retry, catchError } from 'rxjs/operators';
import { Mapesac, NameServiceApi, Path, Security } from '../../constant';
import { Observable } from 'rxjs';
import { AutorizacionService } from './autorizacion.service';
import { AccessResponse } from '../../models/response/authentication/authentication-response.interface';
import { BuySupplyEntity, DecreaseEntity, OrderEntity, SupplyEntity, UbiEntity, UserEntityRequest } from '../../models/request/authentication/authentication-request.interface';
import { ProductEntity } from '../../models/general/table.interface';

@Injectable({ providedIn: 'root' })
export class GeneralService {
  urlWebApi: string;

  constructor(
    private http: HttpClient,
    private autorizacionService: AutorizacionService
  ) {
    this.urlWebApi = environment.serverUriApi;
  }

  Login(userRequest: any): Observable<any> {
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

  ListProduct(): Observable<any>{
    return this.http
      .get<ProductEntity>(this.urlWebApi + Path.Mapesac + NameServiceApi.ListProduct)
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  MergeOrder(orderRequest: any): Observable<any> {
    return this.http
      .get<any>(
        this.urlWebApi + Path.Mapesac + NameServiceApi.MergeOrder,
        {
          observe: 'body',
          params: { orderRequest: JSON.stringify(orderRequest) },
        }
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  ListUbi(): Observable<any>{
    return this.http
      .get<UbiEntity>(this.urlWebApi + Path.Mapesac + NameServiceApi.ListUbi)
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  ListOrder(): Observable<any>{
    return this.http
      .get<UbiEntity>(this.urlWebApi + Path.Mapesac + NameServiceApi.ListOrder)
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  GetOrderByCodeOrder(orderEntity: OrderEntity): Observable<any>{
    return this.http
      .get<any>(this.urlWebApi + Path.Mapesac + NameServiceApi.GetOrderByCodeOrder,
        {
          observe: 'body',
          params: { orderRequest: JSON.stringify(orderEntity) },
        }
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  ListOrderByLocation(orderEntity: OrderEntity): Observable<any>{
    return this.http
      .get<any>(this.urlWebApi + Path.Mapesac + NameServiceApi.ListOrderByLocation,
        {
          observe: 'body',
          params: { orderRequest: JSON.stringify(orderEntity) },
        }
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  RptListProductQuantity(): Observable<any>{
    return this.http
      .get<any>(this.urlWebApi + Path.Mapesac + NameServiceApi.RptListProductQuantity,
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  RptListOrderQuantityStatusDelivery(): Observable<any>{
    return this.http
      .get<any>(this.urlWebApi + Path.Mapesac + NameServiceApi.RptListOrderQuantityStatusDelivery,
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  ListSubOrderByLocation(orderEntity: OrderEntity): Observable<any>{
    return this.http
      .get<any>(this.urlWebApi + Path.Mapesac + NameServiceApi.ListSubOrderByLocation,
        {
          observe: 'body',
          params: { orderRequest: JSON.stringify(orderEntity) },
        }
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  UpdOrderFlow(orderRequest: any): Observable<any>{
    return this.http
      .get<any>(this.urlWebApi + Path.Mapesac + NameServiceApi.UpdOrderFlow,
        {
          observe: 'body',
          params: { orderFlowRequest: JSON.stringify(orderRequest) },
        }
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }
  
  UpdSubOrderFlow(orderRequest: any): Observable<any>{
    return this.http
      .get<any>(this.urlWebApi + Path.Mapesac + NameServiceApi.UpdSubOrderFlow,
        {
          observe: 'body',
          params: { orderFlowRequest: JSON.stringify(orderRequest) },
        }
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  
  ListSupplies(): Observable<any>{
    return this.http
      .get<any>(this.urlWebApi + Path.Mapesac + NameServiceApi.ListSupplies)
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }
  

  ListSuppliersByIdSupply(supplyRequest: SupplyEntity): Observable<any>{
    return this.http
      .get<any>(this.urlWebApi + Path.Mapesac + NameServiceApi.ListSuppliersByIdSupply,
          {
            observe: 'body',
            params: { supplyRequest: JSON.stringify(supplyRequest) },
          }
        )
      
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  InsBuySupply(buySupplyRequest: BuySupplyEntity): Observable<any>{
    return this.http
      .get<any>(this.urlWebApi + Path.Mapesac + NameServiceApi.InsBuySupply,
          {
            observe: 'body',
            params: { buySupplyRequest: JSON.stringify(buySupplyRequest) },
          }
        )
      
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }
  
  UpdDecrease(decreaseRequest: DecreaseEntity): Observable<any>{
    return this.http
      .get<any>(this.urlWebApi + Path.Mapesac + NameServiceApi.UpdDecrease,
          {
            observe: 'body',
            params: { decreaseRequest: JSON.stringify(decreaseRequest) },
          }
        )
      
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

  UpdSubOrderFlowDetail(orderRequest: any): Observable<any>{
    return this.http
      .get<any>(this.urlWebApi + Path.Mapesac + NameServiceApi.UpdSubOrderFlowDetail,
        {
          observe: 'body',
          params: { subOrderFlowDetailRequest: JSON.stringify(orderRequest) },
        }
      )
      .pipe(retry(0), catchError(this.autorizacionService.errorHandl));
  }

}
