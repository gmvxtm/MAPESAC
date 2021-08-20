using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using Newtonsoft.Json;
using BaseArchitecture.Application.TransferObject.Request.Base;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Cross.Security.InvokePetition
{
    public class InvokeWebApi
    {
        protected InvokeWebApi()
        {
        }

        public static List<T> InvokeGetList<T>(string urlApi, string token)
        {
            using (var client = new WebClient())
            {
                client.Headers.Add(HttpRequestHeader.Authorization, token);
                client.Encoding = Encoding.UTF8;
                var lcResult = client.DownloadString(urlApi);
                var lstResult = JsonConvert.DeserializeObject<List<T>>(lcResult);
                return lstResult;
            }
        }

        public static T InvokeGet<T>(string urlApi, string token)
        {
            using (var client = new WebClient())
            {
                client.Headers.Add(HttpRequestHeader.Authorization, token);
                client.Encoding = Encoding.UTF8;
                var lcResult = client.DownloadString(urlApi);
                return JsonConvert.DeserializeObject<T>(lcResult);
            }
        }

        public static T InvokePostEntity<T>(string urlApi, string token, string postData)
        {
            var responseString = InvokePostString(urlApi, token, postData);
            return JsonConvert.DeserializeObject<T>(responseString);
        }

        public static T InvokePostHeaderEntity<T>(string urlApi, BaseRequest baseRequest, string postData)
        {
            var request = WebRequest.Create(urlApi);
            request.Method = "POST";
            request.UseDefaultCredentials = true;
            request.PreAuthenticate = true;
            request.Credentials = CredentialCache.DefaultCredentials;
            request.Headers.Add(HttpRequestHeader.Authorization, baseRequest.Token);
            request.Headers.Add("UserEdit", baseRequest.UserEdit);
            request.Headers.Add("AccessDevice", baseRequest.AccessDevice);
            request.Headers.Add("AwsAccessKey", baseRequest.AwsAccessKey);
            request.Headers.Add("AwsSecretKey", baseRequest.AwsSecretKey);
            request.Headers.Add("AwsSessionToken", baseRequest.AwsSessionToken);
            request.Headers.Add("ProfileId", baseRequest.ProfileId);

            var byteArray = Encoding.UTF8.GetBytes(postData);
            request.ContentType = MediaType.ContentTypeJson;
            request.ContentLength = byteArray.Length;
            var dataStream = request.GetRequestStream();
            dataStream.Write(byteArray, 0, byteArray.Length);
            dataStream.Close();
            var ws = request.GetResponse();
            var responseString = GetStream(ws);
            return JsonConvert.DeserializeObject<T>(responseString);
        }

        public static T InvokePostAnonymousEntity<T>(string urlApi, string postData)
        {
            var request = WebRequest.Create(urlApi);
            request.Method = "POST";
            request.UseDefaultCredentials = true;
            request.PreAuthenticate = true;
            request.Credentials = CredentialCache.DefaultCredentials;
            var byteArray = Encoding.UTF8.GetBytes(postData);
            request.ContentType = MediaType.ContentTypeJson;
            request.ContentLength = byteArray.Length;
            var dataStream = request.GetRequestStream();
            dataStream.Write(byteArray, 0, byteArray.Length);
            dataStream.Close();
            var ws = request.GetResponse();
            var responseString = GetStream(ws);
            return JsonConvert.DeserializeObject<T>(responseString);
        }

        public static string InvokePostString(string urlApi, string token, string postData)
        {
            var request = WebRequest.Create(urlApi);
            request.Method = "POST";
            request.UseDefaultCredentials = true;
            request.PreAuthenticate = true;
            request.Credentials = CredentialCache.DefaultCredentials;
            request.Headers.Add(HttpRequestHeader.Authorization, token);
            var byteArray = Encoding.UTF8.GetBytes(postData);
            request.ContentType = MediaType.ContentTypeJson;
            request.ContentLength = byteArray.Length;
            var dataStream = request.GetRequestStream();
            dataStream.Write(byteArray, 0, byteArray.Length);
            dataStream.Close();
            var ws = request.GetResponse();

            return GetStream(ws);
        }

        private static string GetStream(WebResponse ws)
        {
            using (var stream = ws.GetResponseStream())
            {
                var reader = new StreamReader(stream ?? throw new InvalidOperationException(), Encoding.UTF8);
                var responseString = reader.ReadToEnd();
                return responseString;
            }
        }
    }
}