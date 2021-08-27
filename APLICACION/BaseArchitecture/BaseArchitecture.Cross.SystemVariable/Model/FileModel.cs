namespace BaseArchitecture.Cross.SystemVariable.Model
{
    public class FileModel
    {
        public FileModel(string nameFile, string pathFile, byte[] buffer)
        {
            NameFile = nameFile;
            PathFile = pathFile;
            Buffer = buffer;
        }

        public FileModel(string nameFile, string nameFileSmall, string pathFile, byte[] buffer)
        {
            NameFile = nameFile;
            NameFileSmall = nameFileSmall;
            PathFile = pathFile;
            Buffer = buffer;
        }

        public string NameFile { get; set; }
        public string NameFileSmall { get; set; }
        public string PathFile { get; set; }
        public string Extension { get; set; }
        public byte[] Buffer { get; set; }
    }
}