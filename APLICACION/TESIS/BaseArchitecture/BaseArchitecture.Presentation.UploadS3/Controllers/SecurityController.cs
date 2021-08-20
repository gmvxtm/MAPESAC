using BaseArchitecture.Presentation.UploadS3.Models;
using FW.Cognito.Integration.Controllers;
using FW.Cognito.Integration.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace BaseArchitecture.Presentation.UploadS3.Controllers
{
    public class SecurityController : BaseWebController
    {
        // GET: Security
        public ActionResult Process()
        {
            return View();
        }

        public string GetApiUrl()
        {
            return ConfigurationManager.AppSettings["WEP_API_URL"];
        }

        public ActionResult ProcessClaims(string id_token, string access_token, string type, string expires_in, string mail_token)
        {
            var oauth = new CognitoOAuth();
            var user = oauth.LoginFederationClaims(id_token, access_token);
            Session[ConfigurationManager.AppSettings["SESSIONCOGNITO_NAME"]] = user;
            Session["user_complex_Info"] = JsonConvert.SerializeObject(user);
            Session["user_field_FullName"] = user.Name + " " + user.LastName;
            Session["user_field_Name"] = user.Name;
            try
            {
                LoginRequest loginRequest = new LoginRequest();
                loginRequest.IdToken = id_token;
                loginRequest.AccessToken = access_token;
                loginRequest.ExpiresIn = expires_in;


                Session["id_token"] = id_token;
                string serviceUrl = $"{ConfigurationManager.AppSettings.Get("URL_WEB_API")}/api/Authentication/Login";
                StringContent content = new StringContent(JsonConvert.SerializeObject(loginRequest), Encoding.UTF8, "application/json");
                HttpClient client = new HttpClient();
                HttpResponseMessage response = client.PostAsync(serviceUrl, content).Result;

                if (response.IsSuccessStatusCode)
                {
                    var respString = response.Content.ReadAsStringAsync().Result;
                    Session["user_base_project"] = respString;
                    var action = "Index";
                    var controller = "Home";
                    var area = "";

                    return RedirectToAction(action, controller, new { Area = area });

                }
            }
            catch (Exception e)
            {
                throw;
            }
            return null;
        }

        private ActionResult GetPermission(string token, string mail_token)
        {
            var action = "Index";
            var controller = "Bienvenido";
            var area = "Base";

            var client = new HttpClient();
            client.DefaultRequestHeaders.Add("Authorization", token);
            try
            {
                var response = GetPermissionApplication(token);

                if (response.EnsureSuccessStatusCode().IsSuccessStatusCode)
                {
                    var resultJson = response.Content.ReadAsStringAsync().Result;
                    var permission = JsonConvert.DeserializeObject<Permiso>(resultJson);
                    Session["user_field_EmployeeID"] = permission.Resultado.Info[0].EmployeeId == "" ? "X" : permission.Resultado.Info[0].EmployeeId;
                    var user = JsonConvert.DeserializeObject<UserModel>(Session["user_complex_Info"].ToString());
                    var userLocal = new UsuarioLogin
                    {
                        Codigo = permission.Resultado.Info[0].EmployeeId,
                        EsInterno = true,
                        Nombres = user.Name,
                        Apellidos = user.LastName,
                        Correo = permission.Resultado.Info[0].Email,
                        TelefonoCorporativo = permission.Resultado.Info[0].TelephoneNumber
                    };

                    Session["user_field_CodigoEmpleado"] = userLocal.Codigo;

                    var profileId = "";
                    var profileName = "";
                    var items = permission.Resultado.Perfiles;

                    if (items != null)
                    {
                        foreach (var item in items)
                        {
                            userLocal.Profile_Id = item.Profile_Id;
                            userLocal.Profile_Name = item.Profile_Name;
                            
                            profileId = $"{profileId}{item.Profile_Id}, ";
                            profileName = $"{profileName}{item.Profile_Name}, ";
                        }
                    }

                    userLocal.Profile_Id = profileId.TrimEnd(',');
                    userLocal.Profile_Name = profileName.TrimEnd(',');
                    Session["user_field_Codigo"] = userLocal.Codigo;
                    
                    Session["user_field_IdUsuario"] = userLocal.IdUsuario;
                    Session["user_complex_Security"] = resultJson;



                }
            }
            catch (Exception)
            {
                
                throw;
            }

            return RedirectToAction(action, controller, new { Area = area });
        }

       
        private static HttpResponseMessage GetPermissionApplication(string Token)
        {
            var client = new HttpClient();
            var serviceUrl = ConfigurationManager.AppSettings["PERMISOS_URL"];
            var codeApplication = ConfigurationManager.AppSettings["CODIGO_APLICACION"];
            client.DefaultRequestHeaders.Add("Authorization", Token);
            var response = client.PostAsync($"{serviceUrl}/{codeApplication}", null).Result;
            return response;
        }

       
    }
}