using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto;

namespace Unilink.Business.Utils
{
    public class FileUtil
    {
        public static FileReturnDTO GetStreamToSaveFile(string childPath, string fileName)
        {
            try { 
                string basePath = Environment.GetFolderPath(Environment.SpecialFolder.Personal) + "\\unilink\\";
                if (!Directory.Exists(basePath))
                {
                    Directory.CreateDirectory(basePath);
                }
                var fullChildPath = basePath+ childPath;
                if (!Directory.Exists(fullChildPath))
                {
                    Directory.CreateDirectory(fullChildPath);
                }
                var createFile = Path.Combine(fullChildPath, fileName);
                FileInfo fileInfo = new(createFile);
                FileReturnDTO fileReturnDTO = new FileReturnDTO()
                {
                    stream = fileInfo.Open(FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.None),
                    path = createFile
                };
                return fileReturnDTO;
            } catch (Exception e)
            {
                // Custom log file below

                //
                throw new Exception(e.Message);
            }
        }
        public static string SetPathForFile(string host,string version,string typeGroup, string identify,string type, string fileName)
        {
            return host + "/api/"+version+"/files/" + typeGroup + "/"+ identify + "/" + type + "/" + fileName;
        }
        public static Byte[] GetFile(string typeGroup, string identify, string type, string fileName)
        {
            try
            {
                string basePath = Environment.GetFolderPath(Environment.SpecialFolder.Personal) + "\\unilink\\";
                string filePath = @basePath + "\\" + typeGroup + "\\" + identify + "\\" + type + "\\" + fileName;
                if (File.Exists(filePath))
                {
                    Byte[] b = File.ReadAllBytes(filePath);
                    return b;
                }
                throw new Exception("Not found file name !");
            } catch (Exception e)
            {
                // Custom log file below

                //
                throw new Exception(e.Message);
            }
        }
        
    }
}
