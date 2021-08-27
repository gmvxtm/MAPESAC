using System.Collections.Generic;
using Microsoft.Office.Core;
using BaseArchitecture.Repository.IProxy.Office;
using Ppt = Microsoft.Office.Interop.PowerPoint;

namespace BaseArchitecture.Repository.Proxy.Office
{
    public class PowerPoint : IPowerPoint
    {
        public void GeneratePresentationFromCopy(List<string> listNamePresentation, string namePresentation,
            string pathFileInformation, string pathFilePresentation)
        {
            var pptPresentation = new Ppt.Application
            {
                Visible = MsoTriState.msoCTrue
            };
            foreach (var name in listNamePresentation)
            {
                var pptOrigin = pptPresentation.Presentations.Open($"{pathFileInformation}{name}");
                var pptDestination = pptPresentation.Presentations.Open($"{pathFilePresentation}{namePresentation}");
                if (pptDestination.Slides.Count > 0)
                    pptDestination.Windows[1].View.GotoSlide(pptDestination.Slides.Count);
                for (var i = 1; i <= pptOrigin.Slides.Count; i++)
                {
                    pptOrigin.Slides[i].Copy();
                    pptDestination.Application.CommandBars.ExecuteMso("PasteSourceFormatting");
                }

                pptDestination.Save();
                pptDestination.Close();
                pptOrigin.Close();
            }

            pptPresentation.Quit();
        }
    }
}