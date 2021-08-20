using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Newtonsoft.Json;
using BaseArchitecture.Application.TransferObject.ExternalResponse;
using BaseArchitecture.Application.TransferObject.Request.Access;
using BaseArchitecture.Application.TransferObject.Request.External;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.IProxy.Siapp;

namespace BaseArchitecture.Repository.Proxy.Siapp
{
    public class Siapp : ISiapp
    {
        public async Task<ServerControlResponse> GetUserSiapp(LoginRequest loginRequest)
        {
            var paramKeyValuePairs = new List<KeyValuePair<string, string>>
            {
                new KeyValuePair<string, string>("DeviceId", loginRequest.Device)
            };
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(loginRequest.IdToken);
                var encodedContent = new FormUrlEncodedContent(string.IsNullOrEmpty(loginRequest.Device)
                    ? new List<KeyValuePair<string, string>>()
                    : paramKeyValuePairs);
                var resultJson = await client.PostAsync(AppSettingValue.UrlSiapps, encodedContent).Result.Content
                    .ReadAsStringAsync();
                var objServerControlResponse = JsonConvert.DeserializeObject<ServerControlResponse>(resultJson);
                return objServerControlResponse;
            }
        }

        public ProfileSiappsResponse SetUserProfileSiapp(ApplicationProfileRequest applicationProfileRequest)
        {
            var paramKeyValuePairs = new List<KeyValuePair<string, string>>
            {
                new KeyValuePair<string, string>("Search", applicationProfileRequest.Search),
                new KeyValuePair<string, string>("ClientId", applicationProfileRequest.ClientId),
                new KeyValuePair<string, string>("Action", applicationProfileRequest.Action),
                new KeyValuePair<string, string>("UserEdit", applicationProfileRequest.UserEdit),
                new KeyValuePair<string, string>("ProfileId", applicationProfileRequest.ProfileId)
            };
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue(applicationProfileRequest.Token);
                var encodedContent = new FormUrlEncodedContent(paramKeyValuePairs);
                var resultJson = client.PostAsync(AppSettingValue.UrlServiceUserProfile, encodedContent).Result.Content
                    .ReadAsStringAsync().Result;
                var objServerControlResponse = JsonConvert.DeserializeObject<ProfileSiappsResponse>(resultJson);
                return objServerControlResponse;
            }
        }
    }
}