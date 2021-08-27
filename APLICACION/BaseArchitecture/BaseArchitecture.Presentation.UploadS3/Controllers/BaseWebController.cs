using Amazon.Runtime;
using FW.Cognito.Integration.Controllers;
using FW.Cognito.Integration.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BaseArchitecture.Presentation.UploadS3.Controllers
{
    public class BaseWebController : Controller
    {
        public Dictionary<string, string> AccesoCognito
        {
            get => (Dictionary<string, string>)Session[ConfigurationManager.AppSettings["SESSION_ACCESS_COGNITO"]];
            set => Session[ConfigurationManager.AppSettings["SESSION_ACCESS_COGNITO"]] = value;
        }
        // GET: BaseWeb
        public ActionResult Index()
        {
            return View();
        }

        public void CredencialCongnito(string id_token)
        {
            AWSCredentials credentials = new CognitoRoles().GetCognitoAWSCredentials(ConfigurationManager.AppSettings["IDENTITY_POOL"], id_token);
            Dictionary<string, string> dcCredencialesCognito = new Dictionary<string, string>();
            ImmutableCredentials iCredencial = credentials.GetCredentials();
            dcCredencialesCognito.Add("AccessKey", iCredencial.AccessKey);
            dcCredencialesCognito.Add("SecretKey", iCredencial.SecretKey);
            dcCredencialesCognito.Add("Token", iCredencial.Token);
            AccesoCognito = dcCredencialesCognito;
        }

    }
}