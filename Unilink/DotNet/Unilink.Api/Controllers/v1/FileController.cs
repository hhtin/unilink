using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Dto;
using static Unilink.Api.Config.ResponseFormat;

namespace Unilink.Api.Controllers
{
    [Route("api/v{version:apiVersion}/files")]
    [ApiController]
    [ApiVersion("1.0")]
    public class FileController : ControllerBase
    {
        public class FileModel
        {
            [MaxLength(250, ErrorMessage = "{0} length should not larger than {1}")]
            public string TypeGroup { get; set; }
            [MaxLength(250, ErrorMessage = "{0} length should not larger than {1}")]
            public string Type { get; set; }

            [Required(ErrorMessage = "Should attach your file in your request")]
            public IFormFile File { get; set; }
            public FileModel()
            {
                TypeGroup = "member";
                Type = "file";
                File = null;
            }
            public void _init()
            {
                if (TypeGroup.Equals(""))
                {
                    TypeGroup = "member";
                }
                if (Type.Equals(""))
                {
                    Type = "file";
                }
            }
        }
        private FileContentResult GetImageFile(string typeGroup, string identify, string fileName)
        {
            Byte[] b = FileUtil.GetFile(typeGroup, identify, "image", fileName);
            string fileType = fileName.Split(".")[1];
            return File(b, "image/" + fileType);
        }
        [HttpPost]
        public async Task<IActionResult> saveAnyFile([FromForm] FileModel fileModel)
        {
            // Getting Name
            fileModel._init();
            string type = fileModel.Type;
            var typeGroup = fileModel.TypeGroup;
            // Getting File
            var file = fileModel.File;
            // get user id
            var account = this.HttpContext.Items["User"];
            string accountId = account?.GetType().GetProperty("id")?.GetValue(account, null).ToString();
            // path of file
            string childPath = $"\\{typeGroup}\\{accountId}\\" + type + "";
            // get system path + file path
            string path = "";
            try
            {
                // Saving Image on Server
                FileReturnDTO fileReturn = new FileReturnDTO();
                fileReturn = FileUtil.GetStreamToSaveFile(childPath, file.FileName.ToString());
                if (fileReturn != null)
                {
                    // copy byte to stream;
                    await file.CopyToAsync(fileReturn.stream);
                    fileReturn.stream.Close();
                    // get host ip
                    string host = HttpContext.Request.Host.ToString();
                    // return url path for access to get file
                    path = FileUtil.SetPathForFile(host,"v1", typeGroup, accountId, type, file.FileName.ToString());
                }
            } catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
            return JsonResponse("Save file successfully !", 201, new { path = path });
        }
        [HttpGet("member/{id}/image/{imageName}")]
        public IActionResult getImageFileMember(string id, string imageName)
        {
            try
            {
                return GetImageFile("member", id, imageName);
            } catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }

        [HttpGet("common/{id}/image/{imageName}")]
        public IActionResult getImageFileCommon(string id, string imageName)
        {
            try
            {
                return GetImageFile("common", id, imageName);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }

        }
    }
}
