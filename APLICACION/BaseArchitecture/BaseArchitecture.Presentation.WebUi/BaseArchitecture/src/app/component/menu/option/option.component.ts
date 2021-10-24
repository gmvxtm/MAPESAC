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
  urlOptionUrl : string;
  NameFatherOption : string;
  @ViewChild('buttonAside', { static: true }) buttonAside: ElementRef;
  @ViewChild('scrollMenu', { static: true }) scrollMenu: ElementRef;
  @ViewChildren('subMenu') subMenu: QueryList<any>;

  constructor(
    @Inject(DOCUMENT) private document: Document,
    private localStorage: LocalService,
    private router: Router
  ) {}

  ngOnInit() {
    console.log(document.location.href);
    this.urlOptionUrl = document.location.href.split("/")[4];
    this.labelJson.general = general;
    
    this.listMenuOptions = [ 
      { 
        title: "Área de ventas",
        icon: "fa fa-folder-open",
        MenuChildren: [ {
          title: "Gestión de ventas",
          icon: "fa fa-folder-open",
          OptionUrl: "ventas",
          father:"Área de ventas"
        },
        {
          title: "Reporte Modelos",
          icon: "fa fa-folder-open",
          OptionUrl: "reportesVentas",
          father:"Área de ventas"
        },
        {
          title: "Reporte Pedido",
          icon: "fa fa-folder-open",
          OptionUrl: "reportes2",
          father:"Área de ventas"
        },
        {
          title: "Reporte Aprobado & Rechazado",
          icon: "fa fa-folder-open",
          OptionUrl: "reportes3",
          father:"Área de ventas"
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
          father:"Área de Despacho"
        },
        {
          title: "Reportes",
          icon: "fa fa-folder-open",
          OptionUrl: "reportesDespacho",
          father:"Área de Despacho"
        }]
      },
      { 
        title: "Área de almacén",
        icon: "fa fa-folder-open",
        MenuChildren: [ {
          title: "Inventario",
          icon: "fa fa-folder-open",
          OptionUrl: "almacen",
          father:"Área de almacén"
        },
        {
          title: "Alerta de Insumos",
          icon: "fa fa-folder-open",
          OptionUrl: "almacen/alerta",
          father:"Área de almacén"
        },
        {
          title: "Reportes",
          icon: "fa fa-folder-open",
          OptionUrl: "reportesAlmacen",
          father:"Área de almacén"
        }
        ,
        {
          title: "Reporte Most",
          icon: "fa fa-folder-open",
          OptionUrl: "reportes1",
          father:"Área de almacén"
        }
        ,
        {
          title: "Reporte Decrease",
          icon: "fa fa-folder-open",
          OptionUrl: "reportes5",
          father:"Área de almacén"
        }
      ]
      },
    ]

    this.listMenuOptions.forEach(element => {
      if(element.MenuChildren  != undefined)
      {
        element.MenuChildren.forEach(elementChildren => {
          if( elementChildren.OptionUrl== this.urlOptionUrl)
          {
            this.NameFatherOption = elementChildren.father;
            return;
          }
        });
      }
    });
    console.log(this.NameFatherOption);
  }

  subMenuClick = () => {
    debugger
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

    // this.subMenu.forEach((x: ElementRef) => {
    //   x.nativeElement.classList.remove('menu-item-open');
    // });

    this.subMenu.forEach((x: ElementRef) => {
      if (this.document.activeElement === x.nativeElement.firstChild) {
        this.NameFatherOption =x.nativeElement.innerText;
        x.nativeElement.classList.add('menu-item-open');

      }
      
      //else x.nativeElement.classList.remove('menu-item-open');
    });



  };

  

  routerLink = (url: string) => {
    // this.localStorage.clearKey('BaseArchitectureSelect');
    debugger
    this.urlOptionUrl = "";
    if(url=== undefined) return;
    this.router.navigate(['/' + url]);

    this.listMenuOptions.forEach(element => {
      if(element.MenuChildren  != undefined)
      {
        element.MenuChildren.forEach(elementChildren => {
          if( elementChildren.OptionUrl== url)
          {
            this.urlOptionUrl = url;
            this.NameFatherOption = elementChildren.father;
            return;
          }
        });
      }
    });
    
  };
}
