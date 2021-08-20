using System.Collections.Generic;

namespace BaseArchitecture.Application.TransferObject.Response.Access
{
    public class ProfileResponse

    {
        public ProfileResponse(string profileId, string profileName, string type, string replaceName,
            string replaceRole)
        {
            ProfileId = profileId;
            ProfileName = profileName;
            Type = type;
            ReplaceName = replaceName;
            ReplaceRole = replaceRole;
        }

        public string ProfileId { get; set; }
        public string ProfileName { get; set; }
        public string Type { get; set; }
        public string ReplaceName { get; set; }
        public string ReplaceRole { get; set; }
        public List<OptionResponse> Option { get; set; }
    }
}