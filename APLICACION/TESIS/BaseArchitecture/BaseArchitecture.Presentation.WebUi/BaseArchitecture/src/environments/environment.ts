// This file can be replaced during build by using the `fileReplacements` array.
// `ng build --prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.

export const environment = {
  production: false,
  serverUriApi: 'http://localhost:11805/api/',
  userNetwork:
    'https://{0}/oauth2/authorize?identity_provider={1}&redirect_uri={2}&response_type=TOKEN&client_id={3}&scope=aws.cognito.signin.user.admin openid profile',
  userActiveDirectory:
    'https://{0}/oauth2/authorize?identity_provider={1}&redirect_uri={2}&response_type=token&client_id={3}&scope=aws.cognito.signin.user.admin openid profile',
  cognitoDomain: 'minem-siscose',
  authCognito: '.auth.us-east-1.amazoncognito.com',
  identityProviderAzure: 'AzureAD',
  clientUrl: 'http://localhost:64238/Security/Process',
  clientId: '3nbtfusnskug0m7hu9gvh0sduo',
  clientIdAzure: '3nbtfusnskug0m7hu9gvh0sduo',
  awsClientSecret: 'kg4a89464581ta60e7n8fr8hgh7plp31k7hqqlm9t6itgtjjnja',
  awsIdentityPool: 'us-east-1:c6e71b26-6b54-4240-805b-a4f757c13e68',
  urlLogin: 'http://localhost:64238/ProyectoBase/login',  
  BucketSite:'antamina-site-dev/',
  Bucket: 'ProyectoBase',
  size: 8,
  lastKeyEncrypt : "4NT4D1G1",
  publickey: 'BMLArLMBbj_bhGJFOodwhUME4Pxna6Ax3QRu1RBw44zUZqpK9Xh_FS_133KGVB9TBQB32vBck0L8HO2YEevitxo',
};

/*
 * For easier debugging in development mode, you can import the following file
 * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
 *
 * This import should be commented out in production mode because it will have a negative impact
 * on performance if an error is thrown.
 */
// import 'zone.js/dist/zone-error';  // Included with Angular CLI.
