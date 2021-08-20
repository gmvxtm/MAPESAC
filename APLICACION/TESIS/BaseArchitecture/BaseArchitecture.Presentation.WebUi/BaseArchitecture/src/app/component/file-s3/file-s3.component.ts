import {
  Component,
  OnInit,
  Output,
  EventEmitter,
  ViewChild,
  ElementRef,
  Input,
  OnChanges,
  AfterViewChecked,
  AfterViewInit,
} from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { UploadValidate } from 'src/app/shared/constant';
import { LocalService } from 'src/app/shared/services/general/local.service';
import { ParamS3, ParamsBucket } from 'src/app/shared/util';
import { environment } from 'src/environments/environment';

declare var fileS3: any;

@Component({
  selector: 'file-s3',
  templateUrl: './file-s3.component.html',
  styleUrls: ['./file-s3.component.css'],
})
export class FileS3Component implements OnChanges {
  @Input() data?: any = '';
  @Input() parmasBucket: any = null;
  @Input() button?: any;
  @Input() accept?: string = null;
  @Input() isIcon: boolean = false;
  @Input() position?: number = 99999999999;
  @Input() label?: string = '';

  @Output()
  upload: EventEmitter<any> = new EventEmitter<any>();
  @Output()
  progressBar: EventEmitter<any> = new EventEmitter<any>();
  @ViewChild('inputFile') inputFile: ElementRef;

  normalPB: boolean;
  stripedPB: boolean;
  animatedPB: boolean;
  progress: number;

  file: any;
  progressBarTemp: any = {};

  constructor(
    private toastr: ToastrService,
    private localStorage: LocalService
  ) {}

  ngOnChanges() {
    if (this.parmasBucket != null) {
      this.showProgressBar(3);
      this.fileUpload();
      this.inputFile.nativeElement.value = '';
    }
  }

  validateFile = (event: any): boolean => {
    const validateFile = UploadValidate.find(
      (x) => x.ppt === event.target.files.item(0).type
    );

    if (!validateFile) {
      this.toastr.info('El archivo no es un ppt. o pptx.');
      this.inputFile.nativeElement.value = '';
      return false;
    }
    return true;
  };

  handleUpload = (event: any, record: any) => {
    if (this.accept != null && !this.validateFile(event)) return false;
    this.file = event.target.files;
    let fileTemp = {
      file: event.target.files,
      idTemp: record.idTemp,
    };
    this.upload.emit(fileTemp);
  };

  showProgressBar = (value: number) => {
    this.normalPB = false;
    this.stripedPB = false;
    this.animatedPB = false;
    value == 1
      ? (this.normalPB = true)
      : value == 2
      ? (this.stripedPB = true)
      : (this.animatedPB = true);

    this.progressBarTemp = {
      normalPB: this.normalPB,
      stripedPB: this.stripedPB,
      animatedPB: this.animatedPB,
      progress: 0,
      event: null,
      isUpload: false,
    };
    this.progressBar.emit(this.progressBarTemp);
  };

  fileUpload = async () => {
    if (this.inputFile.nativeElement.value != '') {
      let _this = this;
      let params = fileS3.ParamsBucket(
        environment.Bucket.concat(
          '/',
          this.parmasBucket.codeSystemCase,
          '/',
          this.parmasBucket.fileS3
        ),
        this.parmasBucket.nameFile,
        this.parmasBucket.file
      );

      fileS3
        .UploadS3(params, (err, data) => {
          if (err) {
            this.progressBarTemp = {
              progress: 0,
              event: null,
              error: true,
              animatedPB: false,
              isUpload: true,
            };
            this.progressBar.emit(this.progressBarTemp);
            return false;
          } else return true;
        })
        .on('httpUploadProgress', (event) => {
          _this.progressBarTemp.progress = Math.round(
            (event.loaded / event.total) * 100
          );
          _this.progressBar.emit(_this.progressBarTemp);

          if (event.loaded === event.total) {
            _this.progressBarTemp.animatedPB = false;
            _this.progressBarTemp.progress = 0;
            _this.progressBarTemp.event = event;
            _this.progressBarTemp.error = false;
            _this.progressBarTemp.isUpload = true;
            _this.progressBar.emit(_this.progressBarTemp);
          }
        });
    }
  };
}
