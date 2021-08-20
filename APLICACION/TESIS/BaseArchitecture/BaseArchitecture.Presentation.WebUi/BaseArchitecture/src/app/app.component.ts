import { Component } from '@angular/core';
import { SwUpdate } from '@angular/service-worker';

declare var iziToast: any;

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
})
export class AppComponent {
  title = 'BaseArchitecture';

  constructor(private update: SwUpdate) {
    this.updateClient();
  }

  updateClient() {
    const _this = this;

    if (!this.update.isEnabled) {
      console.log('Not Enabled');
      return;
    }
    this.update.available.subscribe((event) => {
      console.log(`current`, event.current, `available`, event.available);
      iziToast.question({
        timeout: 20000,
        close: false,
        overlay: true,
        overlayColor: 'rgba(255, 255, 255, 0.57)',
        //toastOnce: true,
        displayMode: 'once',
        id: 'question',
        zindex: 1052,
        title: 'Confirmar',
        message:
          'Actualización disponible para la aplicación, por favor confirmar',
        position: 'center',
        buttons: [
          [
            '<button><b>SI</b></button>',
            function (instance, toast) {
              instance.hide({ transitionOut: 'fadeOut' }, toast, 'button');

              _this.update.activateUpdate().then(() => location.reload());
            },
            true,
          ],
          [
            '<button>NO</button>',
            function (instance, toast) {
              instance.hide({ transitionOut: 'fadeOut' }, toast, 'button');
            },
            false,
          ],
        ],
        onClosing: function (instance, toast, closedBy) {
          _this.update.activateUpdate().then(() => location.reload());
        },
        onClosed: function (instance, toast, closedBy) {
          _this.update.activateUpdate().then(() => location.reload());
        },
      });
    });
  }
}
