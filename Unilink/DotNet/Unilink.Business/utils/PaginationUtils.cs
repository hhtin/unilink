using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntityFrameworkPaginateCore;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Entity;

namespace Unilink.Business
{
    public class PaginationUtils
    {
        public List<String> filterList(String className)
        {
            List<string> classNameList = new List<string>();
            switch (className)
            {
                case "Party":
                    {
                        classNameList.Add("Name");
                        classNameList.Add("Id");
                        classNameList.Add("Maximum");
                        classNameList.Add("CreateDate");
                        classNameList.Add("MajorId");
                        break;
                    }
                case "Member":
                    {
                        classNameList.Add("FirstName");
                        classNameList.Add("LastName");
                        classNameList.Add("Id");
                        classNameList.Add("Phone");
                        classNameList.Add("Email");
                        classNameList.Add("DOB");
                        classNameList.Add("Gender");
                        classNameList.Add("Address");
                        classNameList.Add("RoleId");
                        classNameList.Add("UniversityId");
                        break;
                    }
                case "Major":
                    {
                        classNameList.Add("Name");
                        classNameList.Add("Id");
                        break;
                    }
                case "Skill":
                    {
                        classNameList.Add("Name");
                        classNameList.Add("Id");
                        break;
                    }
                case "University":
                    {
                        classNameList.Add("Name");
                        classNameList.Add("Id");
                        break;
                    }
                case "Topic":
                    {
                        classNameList.Add("Title");
                        classNameList.Add("Id");
                        classNameList.Add("CreateDate");
                        classNameList.Add("PartyId");
                        break;
                    }
                case "Post":
                    {
                        classNameList.Add("Title");
                        classNameList.Add("Id");
                        classNameList.Add("CreateDate");
                        classNameList.Add("TopicId");
                        classNameList.Add("CreateBy");
                        break;
                    }
            };
            return classNameList;

        }

        public PaginationRequestDTO validatePaginationParam(PaginationRequestDTO searchDTO, string className)
        {
            int pageSize = searchDTO.pageSize;
            int pageIndex = searchDTO.curPage;
            string sortType = searchDTO.sortType;
            string sortBy = searchDTO.sortBy;
            string searchText = searchDTO.searchText;
            List<string> sortByListAvail = new PaginationUtils().filterList(className);

            if (searchText == null)
            {
                searchText = "";
            }
            if (pageSize < 1)
            {
                pageSize = 10;
            }
            if (pageIndex < 1)
            {
                pageIndex = 1;
            }
            if (sortBy == null || !sortByListAvail.Contains(sortBy))
            {
                sortBy = sortByListAvail[0];
            }
            if (sortType == null || !sortType.Equals("dsc"))
            {
                sortType = "asc";
            }
            return new PaginationRequestDTO(searchText, pageSize, pageIndex, sortBy, sortType);
        }
    }
}
