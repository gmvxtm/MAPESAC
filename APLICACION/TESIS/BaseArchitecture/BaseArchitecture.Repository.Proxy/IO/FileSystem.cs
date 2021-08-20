using System.IO;
using BaseArchitecture.Repository.IProxy.IO;

namespace BaseArchitecture.Repository.Proxy.IO
{
    public class FileSystem : IFileSystem
    {
        public void CreateDirectory(string pathDirectory, string name)
        {
            var fullPath = $"{pathDirectory}{name}";
            if (!Directory.Exists(fullPath)) Directory.CreateDirectory(fullPath);
        }

        public void DeleteDirectory(string pathDirectory, string name)
        {
            var fullPath = $"{pathDirectory}{name}";
            if (Directory.Exists(fullPath)) Directory.Delete(fullPath);
        }

        public void CreateFile(string pathFile, string name, string extension)
        {
            var fullPath = $"{pathFile}{name}.{extension}";
            if (!File.Exists(fullPath)) File.Create(fullPath);
        }

        public void DeleteFile(string pathFile, string name, string extension)
        {
            var fullPath = $"{pathFile}{name}.{extension}";
            if (File.Exists(fullPath)) File.Delete(fullPath);
        }

        public byte[] GetBufferFile(string pathFile, string name, string extension)
        {
            var fullPath = $"{pathFile}{name}.{extension}";
            return File.Exists(fullPath) ? File.ReadAllBytes(fullPath) : new byte[] { };
        }
    }
}