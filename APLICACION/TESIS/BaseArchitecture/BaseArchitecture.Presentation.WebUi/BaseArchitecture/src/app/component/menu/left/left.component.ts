import { DOCUMENT } from '@angular/common';
import {
  Component,
  ElementRef,
  Inject,
  Input,
  OnInit,
  ViewChild,
} from '@angular/core';
import { Router } from '@angular/router';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { Option, Profile } from 'src/app/shared/models/response/authentication/authentication-response.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { createGuidRandom, SignOff } from 'src/app/shared/util';
import { general } from 'src/assets/label.json';

@Component({
  selector: 'menu-left',
  templateUrl: './left.component.html',
  styleUrls: ['./left.component.css']
})
export class MenuLeftComponent implements OnInit {
  @Input() menu: Option[] = new Array<Option>();
  isHoverMenu: boolean = false;
  nameUser: string;
  public labelJson: ResponseLabel = new ResponseLabel();

  listProfile: Profile[] = Array<Profile>();
  profileActual: string = '';

  @ViewChild('buttonAside', { static: true }) buttonAside: ElementRef;
  @ViewChild('scrollMenu', { static: true }) scrollMenu: ElementRef;
  

  constructor(
    @Inject(DOCUMENT) private document: Document,
    private localService: LocalService,
    private router: Router,
    ) {}

  ngOnInit() {
    this.labelJson.general = general;
    // this.nameUser = this.localService.getJsonValue('userBaseArchitecture').User;
    this.listProfile = this.localService.getJsonValue('roleBaseArchitecture');
    this.profileActual = this.localService.getJsonValue('profileBaseArchitecture');
  }

  signOff = () => {
    this.router.navigate(['/login']);
    // SignOff();
  };

  mouseOverMenu = (isHover: boolean) => {
    this.isHoverMenu = !this.isHoverMenu;
    if (
      isHover &&
      this.isHoverMenu &&
      this.document.body.classList.contains('aside-minimize')
    )
      this.document.body.classList.add('aside-minimize-hover');
    else this.document.body.classList.remove('aside-minimize-hover');
  };

  refreshProfile = () => {
    this.localService.setJsonValue('deviceBaseArchitecture', createGuidRandom());
    this.localService.setJsonValue('profileBaseArchitecture', this.profileActual);
    window.location.reload();
  }

}
