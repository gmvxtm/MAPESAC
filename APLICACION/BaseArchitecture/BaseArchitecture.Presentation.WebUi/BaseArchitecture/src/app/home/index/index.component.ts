import { Component, OnInit } from '@angular/core';
import { NgxSpinnerService } from 'ngx-spinner';
import { Router } from '@angular/router';

@Component({
  selector: 'index',
  templateUrl: './index.component.html',
  styleUrls: ['./index.component.css'],
})
export class IndexComponent implements OnInit {

  deviceType: string;
  listMenuOptions: any [] = [];
  
  constructor(
    public spinner: NgxSpinnerService,
    private router: Router
    ) {}

  ngOnInit() {
    this.spinner.hide();
    this.deviceType = ( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ) ? 'M':'D';
    this.listMenuOptions = [
      { 
        title: "Registrar Informe",
        icon: "fa fa-edit"
      },
      { 
        title: "Mis Proyectos",
        icon: "fa fa-folder-open"
      },
      { 
        title: "Consultas",
        icon: "fa fa-search"
      },
      { 
        title: "Reportes",
        icon: "fas fa-copy"
      },
      { 
        title: "Sincronizar Datos",
        icon: "fas fa-sync"
      },
    ]
  }

  redirect = () => {
    this.router.navigate(['/register'])
  }

}
