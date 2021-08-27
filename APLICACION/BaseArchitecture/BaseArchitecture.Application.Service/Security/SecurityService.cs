using Newtonsoft.Json;
using BaseArchitecture.Application.IService.Security;
using BaseArchitecture.Application.TransferObject.ExternalResponse;
using BaseArchitecture.Application.TransferObject.Request.Access;
using BaseArchitecture.Application.TransferObject.Request.Base;
using BaseArchitecture.Application.TransferObject.Response.Access;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.LoggerTrace;
using BaseArchitecture.Cross.Security.Aws;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.IProxy.Siapp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;

namespace BaseArchitecture.Application.Service.Security
{
    public class SecurityService : ISecurityService
    {
        public ISiapp Siapp { get; set; }
        public AwsHelper AwsHelper { get; set; }

        public Trace TraceLogger =>
            (Trace) GlobalConfiguration.Configuration.DependencyResolver.GetService(typeof(Trace));

        public async Task<Response<LoginResponse>> GetUserAccess(LoginRequest loginRequest)
        {
            try
            {
                var objectUser = AwsHelper.GetAccessCognito(loginRequest.IdToken, string.Empty);
                if (objectUser == null) return null;
                //var serverControlResponse = await Siapp.GetUserSiapp(loginRequest);

                List<Opcion> opciones = new List<Opcion>();
                var opcion01 = new Opcion
                {
                    Option_Url = "/welcome",
                    Option_Name = "Bienvenido",
                    Option_Id_Parent = "001"
                };
                var opcion02= new Opcion
                {
                    Option_Url = "/welcome",
                    Option_Name = "Bienvenido",
                    Option_Id_Parent = "001"
                };
                opciones.Add(opcion01);
                opciones.Add(opcion02);

                var perfil01 = new PerfilUsuario
                {
                    Permisos = opciones,
                    Profile_Id = "ADM",
                    Profile_Name = "Administrador",
                };

                var serverControlResponse = new ServerControlResponse();

                serverControlResponse.Resultado = new Resultado(){
                        resultado = 1,
                        Msg = "ok",
                        //Info = ,
                        //Perfiles = perfil01
                };
                serverControlResponse.Status = "OK";
                //serverControlResponse.Resultado.Perfiles = new List<PerfilUsuario> {
                //   perfil01
                //};

                if (serverControlResponse.Status != "OK") return null;
                //loginRequest.PreferredUser = string.IsNullOrEmpty(objectUser.PreferredUser)
                //    ? serverControlResponse.Resultado.Info[0].SamAccountName
                //    : objectUser.PreferredUser;
                var loginResponse = TranslateLoginObject(serverControlResponse, loginRequest);
                if (loginResponse == null) return null;

                var result = new Response<LoginResponse>
                {
                    Value = loginResponse
                };
                return result;
            }
            catch (Exception e)
            {
                await TraceLogger.RegisterExceptionDemandAsync(JsonConvert.SerializeObject(e));
                var result = new Response<LoginResponse>
                {
                    State = (int) HttpStatusCode.Conflict,
                    Value = new LoginResponse(),
                    Status = false
                };
                return result;
            }
        }

        public async Task<Response<AccessResponse>> GetProfileSiapp(BaseRequest baseRequest)
        {
            var loginRequest = new LoginRequest
            {
                IdToken = baseRequest.Token
            };
            var serverControlResponse = await Siapp.GetUserSiapp(loginRequest);
            if (serverControlResponse.Status != "OK") return null;
            var accessResponse = TranslateObject(serverControlResponse);
            var result = new Response<AccessResponse>
            {
                Value = accessResponse
            };
            return result;
        }

        private LoginResponse TranslateLoginObject(ServerControlResponse serverControlResponse,
            LoginRequest loginRequest)
        {
            //var credentials =
            //    AwsHelper.GetAwsCredentials(loginRequest.IdToken, IncomeTraceConfigureAws.AwsIdentityPool)
            //        .GetCredentials();

            var loginResponse = new LoginResponse
            {
                Token = loginRequest.IdToken,
                User = loginRequest.PreferredUser,
                //UserEdit = serverControlResponse.Resultado.Info[0].CodTra,
                //EmployeeId = serverControlResponse.Resultado.Info[0].EmployeeId,
                //Title = serverControlResponse.Resultado.Info[0].Title,
                //AwsSessionToken = credentials.Token,
                //AwsAccessKey = credentials.AccessKey,
                //AwsSecretKey = credentials.SecretKey,
                //ProfileId = serverControlResponse.Resultado.Perfiles.FirstOrDefault()?.Profile_Id
            };
            return loginResponse;
        }

        private AccessResponse TranslateObject(ServerControlResponse serverControlResponse)
        {
            var accessResponse = new AccessResponse
            {
                Profile = new List<ProfileResponse>()
            };
            foreach (var profile in serverControlResponse.Resultado.Perfiles)
            {
                var profileResponse = new ProfileResponse(
                    profile.Profile_Id
                    , profile.Profile_Name
                    , profile.Tipo
                    , profile.Reemplazado_Nombre
                    , profile.Reemplazado_Cargo
                )
                {
                    Option = new List<OptionResponse>()
                };

                foreach (var option in profile.Permisos)
                {
                    var optionResponse = new OptionResponse
                    {
                        OptionId = option.Option_Id,
                        OptionName = option.Option_Name,
                        OptionUrl = option.Option_Url,
                        OptionIdParent = option.Option_Id_Parent,
                        OptionIcon = option.Option_Icon,
                        OptionDescription = option.Option_Description,
                        OptionColor1 = option.Option_Color1,
                        OptionColor2 = option.Option_Color2,
                        Process = new List<ProcessResponse>()
                    };
                    foreach (var process in option.Process)
                    {
                        var processResponse = new ProcessResponse(
                            process.Process_Id
                            , process.Process_Name
                            , process.Process_OnlyRead.ToString()
                        );
                        optionResponse.Process.Add(processResponse);
                    }

                    profileResponse.Option.Add(optionResponse);
                }

                accessResponse.Profile.Add(profileResponse);
            }

            return accessResponse;
        }
    }
}