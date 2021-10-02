export const Path = {
  Authentication: 'Authentication/',
  Demo: 'Demo/',
  Security: 'Security/',
  Mapesac: 'Mapesac/',
};

export const Authentication = {
  Login: 'Login',
};

export const Security = {
  Access: 'Access',
};

export const Mapesac = {
  Login: 'Login',
  
};

export const NameServiceApi ={
  ListProduct:'ListProduct',
  MergeOrder:'MergeOrder',
  ListUbi:'ListUbi',
  ListOrder:'ListOrder',
  GetOrderByCodeOrder: 'GetOrderByCodeOrder',
  ListOrderByLocation: 'ListOrderByLocation',
  UpdOrderFlow:'UpdOrderFlow',
  ListSubOrderByLocation:'ListSubOrderByLocation',
  UpdSubOrderFlow: 'UpdSubOrderFlow'
}

export const Demo = {
  ListMasterTableByValue: 'ListMasterTableByValue',
  ListMasterTable: 'ListMasterTable',
  GetPersonById: 'GetPersonById',
  ListPersonAll: 'ListPersonAll',
  UpdPersonState: 'UpdPersonState',
  RegPerson: 'RegPerson',
  GetMasterById: 'GetMasterById',
};

export const TableMaster = {
  EstadoPedido: '00100',
  Ubicacion: '00100',
  Perfil: '00100',
  Prioridades: '00100',
  UnidadMedida: '00100',
  Respuesta: '00100'
};

export const MTEstadoPedido = {
  Pendiente: '00101',
  EnProceso: '00102',
  Terminado: '00103'
};
export const MTUbicacion = {
  EncargadoVentas: '00201',
  AreaCorte: '00202',
  AreaCostura: '00203',
  AreaLavanderia: '00204',
  AreaAcabados: '00205',
  AreaDespacho: '00206',
  EntregadoCliente: '00207'
};
export const MTPerfil = {
  DNI: '00101',
};
export const MTPrioridades = {
  DNI: '00101',
};
export const MTUnidadMedida = {
  DNI: '00101',
};
export const MTRespuesta = {
  Pendiente: '00601',
  Aprobado: '00602',
  Rechazado: '00603',
  EnProceso: '00604',
  Culminado: '00605',
  Entregado: '00606',
};


export const TypeDocument = {
  DNI: '00101',
};
export const LogoutType = {
  cognito: 1,
  azure: 2,
};

export const RecordStatus = {
  Activate: 'A',
  Desactivate: 'D',
};

export const Pagination = {
  CurrentPage: 1,
  RowsPerPage: 10,
  ColumnOrder: 'Name',
  TypeOrder: 'desc',
};
