import { DOCUMENT } from '@angular/common';
import {
  Component,
  ElementRef,
  Inject,
  Input,
  OnInit,
  QueryList,
  ViewChild,
  ViewChildren,
} from '@angular/core';
import { Router } from '@angular/router';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { Option } from 'src/app/shared/models/response/authentication/authentication-response.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { SignOff } from 'src/app/shared/util';
import { general } from 'src/assets/label.json';

@Component({
  selector: 'menu-desktop',
  templateUrl: './desktop.component.html',
  styleUrls: ['./desktop.component.css']
})
export class MenuDesktopComponent implements OnInit {
  @Input() menu: Option[] = new Array<Option>();
  isClickButton: boolean = false;
  isClickSubMenu: boolean = false;
  isHoverMenu: boolean = false;
  nameUser: string;
  public labelJson: ResponseLabel = new ResponseLabel();

  @ViewChild('buttonAside', { static: true }) buttonAside: ElementRef;
  @ViewChild('scrollMenu', { static: true }) scrollMenu: ElementRef;
  @ViewChildren('subMenu') subMenu: QueryList<any>;

  constructor(
    @Inject(DOCUMENT) private document: Document,
    private localStorage: LocalService,
    private router: Router,
    ) {}

  ngOnInit() {
    this.labelJson.general = general;
    // this.nameUser = this.localStorage.getJsonValue('userBaseArchitecture').User;
  }

  asideToggle = () => {
    this.isClickButton = !this.isClickButton;

    if (this.isClickButton) {
      this.buttonAside.nativeElement.classList.add('active');
      this.document.body.classList.add('aside-minimize');
    } else {
      this.buttonAside.nativeElement.classList.remove('active');
      this.document.body.classList.remove('aside-minimize');
    }
  };

  
  signOff = () => {
    SignOff();
  };

  subMenuClick = () => {
    this.isClickSubMenu = !this.isClickSubMenu;

    if (
      this.document.activeElement.parentElement.classList.contains(
        'menu-item-open'
      )
    ) {
      this.document.activeElement.parentElement.classList.remove(
        'menu-item-open'
      );
      return false;
    }

    this.subMenu.forEach((x: ElementRef) => {
      x.nativeElement.classList.remove('menu-item-open');
    });

    this.subMenu.forEach((x: ElementRef) => {
      if (this.document.activeElement === x.nativeElement.firstChild) {
        x.nativeElement.classList.add('menu-item-open');
      } else x.nativeElement.classList.remove('menu-item-open');
    });
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
}
