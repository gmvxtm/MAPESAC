import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { NgxSpinnerService } from 'ngx-spinner';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { TypeaheadMatch } from 'ngx-bootstrap/typeahead/public_api';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {
  public labelJson: ResponseLabel = new ResponseLabel();
  deviceType: string;
  selectedEmployee: string;
  listEmployee: any [] = [];
  itemType: string;

  constructor(
    private spinner: NgxSpinnerService,
    private router: Router,
    private localStorage: LocalService
  ) { }

  ngOnInit(): void {
    this.deviceType = ( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ) ? 'M':'D';

    this.listEmployee = [
      {
        type: 'RP',
        name: '123'
      },
      {
        type: 'RP',
        name: '456'
      },
      {
        type: 'RP',
        name: '789'
      },
      {
        type: 'RS',
        name: '159'
      },
      {
        type: 'RS',
        name: '369'
      }
    ]
  }

  typeaheadOnSelectEmployee = (e: TypeaheadMatch): void => {
    this.itemType = e.item.type;
  };
}
