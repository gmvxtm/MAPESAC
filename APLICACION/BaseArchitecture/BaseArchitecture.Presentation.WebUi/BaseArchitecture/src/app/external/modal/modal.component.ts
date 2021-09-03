import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { NgxSpinnerService } from 'ngx-spinner';
import { Subject } from 'rxjs';
import { ResponseLabel } from 'src/app/shared/models/general/label.interface';
import { GeneralService } from 'src/app/shared/services/general/general.service';
import { IndexdDBService } from 'src/app/shared/services/general/indexDB.service';
import { decrypt, showError } from 'src/app/shared/util';
import { general } from 'src/assets/label.json';

@Component({
  selector: 'modal',
  templateUrl: './modal.component.html',
  styleUrls: ['./modal.component.css'],
})
export class ModalComponent implements OnInit {

  public labelJson: ResponseLabel = new ResponseLabel();
  public onClose: Subject<any>;
  item: any;
  catalogListSelectedModal: [] = [];

  constructor(
    public bsModalRefP: BsModalRef,
    private oGeneralService: GeneralService,
    private spinner: NgxSpinnerService,
  ) {}

  ngOnInit() {
    debugger
    this.onClose = new Subject();
    this.labelJson.general = general;
    this.catalogListSelectedModal = this.item.lista;
    console.log(this.catalogListSelectedModal)
  }

  redirect = () =>{
    this.onClose.next(true);
  }


}
