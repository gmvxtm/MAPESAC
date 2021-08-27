using System.Collections.Generic;

namespace BaseArchitecture.Repository.IProxy.Office
{
    public interface IPowerPoint
    {
        void GeneratePresentationFromCopy(List<string> listNamePresentation, string namePresentation,
            string pathFileInformation, string pathFilePresentation);
    }
}