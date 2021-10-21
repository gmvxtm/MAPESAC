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
        title: "Área de ventas",
        icon: "fa fa-folder-open",
        MenuChildren: [ {
          title: "Gestión de ventas",
          icon: "fa fa-folder-open",
          OptionUrl: "ventas",
        },
        {
          title: "Reporte Modelos",
          icon: "fa fa-folder-open",
          OptionUrl: "reportesVentas",
        },
        {
          title: "Reporte Pedido",
          icon: "fa fa-folder-open",
          OptionUrl: "reportes2",
        },
        {
          title: "Reporte Aprobado & Rechazado",
          icon: "fa fa-folder-open",
          OptionUrl: "reportes3",
        }
      ]
      },
      { 
        title: "Área de corte",
        icon: "fa fa-folder-open",
        OptionUrl: "/corte"
      },
      { 
        title: "Área de Costura",
        icon: "fa fa-folder-open",
        OptionUrl: "/costura"
      },
      { 
        title: "Área de Lavandería",
        icon: "fa fa-folder-open",
        OptionUrl: "/lavanderia"
      },
      { 
        title: "Área de Acabado",
        icon: "fa fa-folder-open",
        OptionUrl: "/acabado"
      },
      { 
        title: "Área de Despacho",
        icon: "fa fa-folder-open",
        MenuChildren: [ {
          title: "Despacho",
          icon: "fa fa-folder-open",
          OptionUrl: "despacho",
        },
        {
          title: "Reportes",
          icon: "fa fa-folder-open",
          OptionUrl: "reportesDespacho",
        }]
      },
      { 
        title: "Área de almacén",
        icon: "fa fa-folder-open",
        MenuChildren: [ {
          title: "Inventario",
          icon: "fa fa-folder-open",
          OptionUrl: "almacen",
        },
        {
          title: "Alerta de Insumos",
          icon: "fa fa-folder-open",
          OptionUrl: "almacen/alerta",
        },
        {
          title: "Reportes",
          icon: "fa fa-folder-open",
          OptionUrl: "reportesAlmacen",
        }
      ]
      },
    ]
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
