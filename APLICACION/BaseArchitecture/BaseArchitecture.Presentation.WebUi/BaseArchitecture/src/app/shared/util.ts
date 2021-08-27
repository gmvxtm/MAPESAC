import { environment } from 'src/environments/environment';
import * as CryptoJS from 'crypto-js';
import { LogoutType } from './constant';
export const SECRET_KEY = 'pwa';

declare var iziToast: any;

var urlLogout = FormatString('https://antamina.awsapps.com/start#/signout');

let urlLogoutAzure = FormatString(
  'https://{0}/logout?client_id={1}&logout_uri=https://login.microsoftonline.com/common/oauth2/logout',
  environment.cognitoDomain,
  environment.clientIdAzure
);

export function FormatString(str: string, ...val: string[]) {
  for (let index = 0; index < val.length; index++) {
    str = str.replace(`{${index}}`, val[index]);
  }
  return str;
}

export function SignOff(): void {
  if (localStorage.getItem('errorBaseArchitecture')) {
    if (Number(localStorage.getItem('errorBaseArchitecture')) > 0) {
      return;
    }
  }

  let typeSession = Number(localStorage.getItem('typeSessionSig'));

  let urlSession = urlLogout;
  if (typeSession === LogoutType.azure) urlSession = urlLogoutAzure;

  var win = window.open(
    urlSession,
    '_blank',
    'toolbar=no,status=no,menubar=no,scrollbars=no,resizable=no,left=10000, top=10000, width=10, height=10, visible=none'
  );
  Sleep(win);
}

export function Sleep(win: any): void {
  var sleep = new Promise(function (resolve, reject) {
    setTimeout(function () {
      resolve();
    }, 8000);
  });
  sleep.then(function () {
    win.close();
    localStorage.removeItem('tokenBaseArchitecture');
    localStorage.removeItem('userBaseArchitecture');
    localStorage.removeItem('loginBaseArchitecture');
    localStorage.removeItem('menuBaseArchitecture');
    localStorage.removeItem('deviceBaseArchitecture');
    localStorage.removeItem('typSessionSig');
    localStorage.removeItem('errorBaseArchitecture');
    window.location.replace(environment.urlLogin);
  });
}

export function showError(ParamMsg) {
  iziToast.error({
    title: 'Error',
    message: ParamMsg || 'Error en transacción',
    position: 'bottomCenter',
    zindex: 14000,
    timeout: 10000,
  });
}

export function showWarning(ParamMsg) {
  iziToast.warning({
    title: 'Validación',
    message: ParamMsg,
    position: 'topCenter',
    zindex: 10000,
    transitionOut: 'fadeOutDown',
  });
}

export function showSuccess(ParamMsg) {
  iziToast.success({
    title: 'Listo!',
    message: ParamMsg,
    position: 'topCenter',
    timeout: 10000,
    zindex: 11000,
    transitionOut: 'fadeOutDown',
  });
}

export function showInfo(ParamMsg) {
  iziToast.info({
    class: 'infoToast',
    title: 'Info',
    message: ParamMsg,
    position: 'bottomRight',
    close: false,
    zindex: 14000,
    timeout: 10000,
    displayMode: 2,
  });
}

export function createGuidRandom(): any {
  return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    var r = (Math.random() * 16) | 0,
      v = c == 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

export function encrypt(data): any {
  data = CryptoJS.AES.encrypt(data, SECRET_KEY);
  data = data.toString();
  return data;
}

export function decrypt(data): any {
  data = CryptoJS.AES.decrypt(data, SECRET_KEY);
  data = data.toString(CryptoJS.enc.Utf8);
  return data;
}

export function sumarDias(fecha, dias): Date {
  fecha.setDate(fecha.getDate() + dias);
  return fecha;
}

export function isEmail(email: string): boolean {
  let mailSuccess = false;
  var EMAIL_REGEX = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; ///^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;

  if (email.match(EMAIL_REGEX)) {
    mailSuccess = true;
  }
  return mailSuccess;
}
