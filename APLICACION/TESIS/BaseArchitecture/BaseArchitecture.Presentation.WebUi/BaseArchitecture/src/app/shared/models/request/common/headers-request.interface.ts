export class ButtonsInterface {
  type: string;
  icon?: string;
  tooltip?: string;
}

export class HeadersInterface {
  primaryKey: string;
  title?: string;
  property?: string;
  esEdit?: boolean;
  buttons?: ButtonsInterface[];
  filter?: boolean;
  sort?: boolean;

  constructor() {
    this.filter = false;
  }
}
