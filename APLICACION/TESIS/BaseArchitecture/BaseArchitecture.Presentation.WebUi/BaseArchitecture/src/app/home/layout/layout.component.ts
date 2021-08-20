import { Component, OnInit, HostListener, Inject } from '@angular/core';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { HttpErrorResponse } from '@angular/common/http';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import {
  AccessResponse,
  Option,
  Profile,
} from 'src/app/shared/models/response/authentication/authentication-response.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { IndexdDBService } from 'src/app/shared/services/general/indexDB.service';
import { general } from 'src/assets/label.json';
import { DOCUMENT } from '@angular/common';

declare var $: any;
declare var fileS3: any;
@Component({
  selector: 'app-index',
  templateUrl: './layout.component.html',
  styleUrls: ['./layout.component.css'],
})
export class LayoutComponent implements OnInit {
  appMenuTemporalP: Profile[];
  menu: Option[] = new Array<Option>();
  public labelJson: ResponseLabel = new ResponseLabel();
  listProfile: Profile[] = Array<Profile>();

  constructor(
    @Inject(DOCUMENT) private document: Document,
    private spinner: NgxSpinnerService,
    private generalService: GeneralService,
    private localService: LocalService,
    private oIndexdDBService: IndexdDBService,
  ) {}

  ngOnInit() {
    this.labelJson.general = general;
    // fileS3.ParamS3(
    //   this.localService.getJsonValue('userBaseArchitecture')
    // );
    // this.setTimeInactive();
    // this.obtenerMenu();
  }

  
  @HostListener('window:scroll', ['$event'])
  onWindowScroll($event: any): void {
    if (window.pageYOffset === 0)
      this.document.body.removeAttribute('data-scrolltop');
    else this.document.body.setAttribute('data-scrolltop', 'on');
  }

  scrollTopClick = () => {
    window.scrollTo({ left: 0, top: 0, behavior: 'smooth' });
  };


  // obtenerMenu = () => {
  //   this.spinner.show();
  //   this.generalService.Access().subscribe(
  //     (data: AccessResponse) => {
  //       this.appMenuTemporalP = data.Value.Profile;

  //       this.appMenuTemporalP.forEach((element) => {
  //         element.Option.forEach((option) => {
  //           this.menuHeader.push(option);
  //         });
  //       });

  //       let menu = {
  //         CodCia: 'GetMenu',
  //         body: this.menuHeader,
  //       };

  //       this.oIndexdDBService.addStore(menu).catch(console.log);

  //       this.localService.setJsonValue('menuBaseArchitecture', this.menuHeader);
  //       this.spinner.hide();
  //     },
  //     (error: HttpErrorResponse) => {
  //       this.spinner.hide();
  //       console.log(error);
  //     }
  //   );
  // };
}
