namespace BaseArchitecture.Repository.IProxy.IO
{
    public interface IFileSystem
    {
        void CreateDirectory(string pathDirectory, string name);
        void DeleteDirectory(string pathDirectory, string name);
        void CreateFile(string pathFile, string name, string extension);
        void DeleteFile(string pathFile, string name, string extension);
        byte[] GetBufferFile(string pathFile, string name, string extension);
    }
}