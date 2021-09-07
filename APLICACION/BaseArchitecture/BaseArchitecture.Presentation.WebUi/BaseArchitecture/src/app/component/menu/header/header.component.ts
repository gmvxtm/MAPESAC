import { Component, OnInit } from '@angular/core';
import { GeneralLabel, LoginLabel } from 'src/app/shared/models/general/label.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { general, sessionLogin } from 'src/assets/label.json';

@Component({
    selector: 'menu-header',
    templateUrl: './header.component.html'
})

export class MenuHeaderComponent implements OnInit {
    isTopBar: boolean = false;
    name: string = "";
    generalLabel: GeneralLabel = new GeneralLabel();
    sessionLabel: LoginLabel = new LoginLabel();
    nameUser:string = '';
    constructor(private localService: LocalService) { }

    ngOnInit() { 
        this.generalLabel = general;
        this.sessionLabel = sessionLogin;
        let pathMenu =  this.localService.getJsonValue('profileBase');
        this.nameUser= pathMenu.UserEntity.Username;
        // this.name = this.localService.getJsonValue('userBaseArchitecture').User;
    }

    topBarClick = (topBar: boolean)=>{
        this.isTopBar = topBar;
    }
}