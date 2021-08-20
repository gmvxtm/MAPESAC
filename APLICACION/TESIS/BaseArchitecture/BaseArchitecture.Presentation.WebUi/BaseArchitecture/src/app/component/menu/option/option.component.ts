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
import { general } from 'src/assets/label.json';

@Component({
  selector: 'menu-option',
  templateUrl: './option.component.html',
})
export class MenuOptionComponent implements OnInit {
  @Input() menu: Option[] = new Array<Option>();
  isClickButton: boolean = false;
  isClickSubMenu: boolean = false;
  isHoverMenu: boolean = false;
  nameUser: string;
  public labelJson: ResponseLabel = new ResponseLabel();
  listMenuOptions: any [] = [];

  @ViewChild('buttonAside', { static: true }) buttonAside: ElementRef;
  @ViewChild('scrollMenu', { static: true }) scrollMenu: ElementRef;
  @ViewChildren('subMenu') subMenu: QueryList<any>;

  constructor(
    @Inject(DOCUMENT) private document: Document,
    private localStorage: LocalService,
    private router: Router
  ) {}

  ngOnInit() {
    this.labelJson.general = general;
    this.listMenuOptions = [
      { 
        title: "Cartera de Proyectos",
        icon: "fa fa-folder-open",
        OptionUrl: "cartera"
      },
      { 
        title: "Programar Visita",
        icon: "far fa-address-book",
        OptionUrl: "programar"
      },
      { 
        title: "Registrar Informe",
        icon: "fa fa-edit",
        OptionUrl: "register"
      },
      { 
        title: "Mis Proyectos",
        icon: "fas fa-tasks"
      },
      // { 
      //   title: "Consultas",
      //   icon: "fa fa-search"
      // },
      { 
        title: "Reportes",
        icon: "fas fa-copy"
      },
      // { 
      //   title: "Sincronizar Datos",
      //   icon: "fas fa-sync"
      // },
    ]
    // this.nameUser = this.localStorage.getJsonValue('userBaseArchitecture').User;
  }

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

  

  routerLink = (url: string) => {
    // this.localStorage.clearKey('BaseArchitectureSelect');
    this.router.navigate(['/' + url]);
  };
}
