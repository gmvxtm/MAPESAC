import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { NgxSpinnerService } from 'ngx-spinner';
import { GeneralLabel } from 'src/app/shared/models/general/label.interface';
import { Profile } from 'src/app/shared/models/response/authentication/authentication-response.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { SignOff, createGuidRandom } from 'src/app/shared/util';
import { general } from 'src/assets/label.json';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'user-info',
  templateUrl: './user-info.component.html',
})
export class UserInfoComponent implements OnInit {
  @Input() isTopBar: boolean;
  @Output() topBar: EventEmitter<boolean> = new EventEmitter<boolean>();
  name: string = '';
  email: string = '';
  profileName: string ='';
  labelGeneral: GeneralLabel = new GeneralLabel();
  listProfile: Profile[] = Array<Profile>();
  profileActual: string = '';
  

  constructor(
    private localService: LocalService,
    private spinner: NgxSpinnerService
  ) {}

  ngOnInit() {
    debugger
    this.labelGeneral = general;
    // this.name = this.localService.getJsonValue('userBaseArchitecture').User;
    // this.email = this.localService.getJsonValue('userBaseArchitecture').Email;

    let pathMenu =  this.localService.getJsonValue('profileBase');
    this.name= pathMenu.UserEntity.Username;
    this.profileName= pathMenu.UserEntity.ProfileName;
    
    //this.listProfile = this.localService.getJsonValue('profileBase');
    //this.profileActual = this.localService.getJsonValue('profileBaseArchitecture');
  }

  closeTopBar = () => {
    this.isTopBar = !this.isTopBar;
    this.topBar.emit(this.isTopBar);
  }

  signOff = () => {
    this.spinner.show();
    this.localService.setJsonValue('errorBaseArchitecture', 0);
    SignOff();
  }

  refreshProfile = () => {
    this.localService.setJsonValue('deviceBaseArchitecture', createGuidRandom());
    this.localService.setJsonValue('profileBaseArchitecture', this.profileActual);
    window.location.reload();
  }
}
