export const environment = {
  production: true,
  SERVER_URL_API: 'https://dev.antamina.com/proyectobaseapi/api/',
  USUARIO_RED:
    'https://{0}/oauth2/authorize?identity_provider={1}&redirect_uri={2}&response_type=TOKEN&client_id={3}&scope=aws.cognito.signin.user.admin openid profile',
  USUARIO_AD:
    'https://{0}/oauth2/authorize?identity_provider={1}&redirect_uri={2}&response_type=token&client_id={3}&scope=aws.cognito.signin.user.admin openid profile',
  COGNITO_DOMAIN: 'antamina-proyetobase-dev.auth.us-east-1.amazoncognito.com',
  IDENTITY_PROVIDER: 'Antamina',
  IDENTITY_PROVIDER_AZURE_AD: 'AzureAD',
  CLIENT_URL: 'https://dev.antamina.com/ProyectoBase/Security/Process',
  CLIENT_ID: '37es1gmfoo533883vj1iamkp2c',
  CLIENT_ID_AZURE_AD: '37es1gmfoo533883vj1iamkp2c',
  URL_LOGIN: 'https://dev.antamina.com/ProyectoBase/login',
};
