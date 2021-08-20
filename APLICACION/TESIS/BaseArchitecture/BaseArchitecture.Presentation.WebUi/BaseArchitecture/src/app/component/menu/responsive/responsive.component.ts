import { DOCUMENT } from '@angular/common';
import {
  Component,
  ElementRef,
  Inject,
  Input,
  OnInit,
  Renderer2,
  ViewChild,
} from '@angular/core';
import { BsModalRef, BsModalService } from 'ngx-bootstrap/modal';
import { GeneralLabel } from 'src/app/shared/models/general/label.interface';
import { general } from 'src/assets/label.json';
import { Option } from 'src/app/shared/models/response/authentication/authentication-response.interface';

@Component({
  selector: 'menu-responsive',
  templateUrl: './responsive.component.html',
  styleUrls: ['./responsive.component.css']
})
export class MenuResponsiveComponent implements OnInit {
  @Input() menu: Option[] = new Array<Option>();
  @ViewChild('mobileToggle', { static: true }) mobileToggle: ElementRef;
  isTopBar: boolean = false;
  openMenuClick: boolean = false;
  bsModalRefP: BsModalRef;
  public labelGeneral: GeneralLabel = new GeneralLabel();
  constructor(
    @Inject(DOCUMENT) private document: Document,
    private renderer: Renderer2,
    private modalService: BsModalService,
  ) {}

  ngOnInit() {
    this.labelGeneral = general;
  }

  topBarClick = (topBar: boolean) => {
    this.isTopBar = topBar;
  };

  openMenu = () => {
    this.openMenuClick = !this.openMenuClick;
    let aside = this.document.getElementById('kt_aside_mobile');

    if (this.openMenuClick) {
      this.mobileToggle.nativeElement.classList.add('mobile-toggle-active');
      aside.classList.add('aside-on');
    } else {
      this.mobileToggle.nativeElement.classList.remove('mobile-toggle-active');
      aside.classList.remove('aside-on');
    }
  };
}
