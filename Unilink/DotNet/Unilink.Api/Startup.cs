using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ApiExplorer;
using Microsoft.AspNetCore.Mvc.Versioning;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using StackExchange.Redis;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Api.Config;
using Unilink.Business.Service;
using Unilink.Business.Service.Impl;
using Unilink.Data.Config;
using Unilink.Data.Repository;
using Unilink.Data.Repository.Impl;

namespace Unilink.Api
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //Configure other services up here
            initFireBase();

            services.AddStackExchangeRedisCache(options =>
            {
                options.Configuration = "127.0.0.1";
            });

            services.AddAuthentication(option=> {
                option.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                option.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(option =>
            {
                option.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = Configuration["Jwt:Issuer"],
                    ValidAudience = Configuration["Jwt:Issuer"],
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["Jwt:Key"]))
                };
            });
            services.AddDbContext<ApplicationDbContext>(options => {
                options.UseSqlServer(Configuration.GetConnectionString("MyConnection"));
                options.UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);
                },
             ServiceLifetime.Transient);
            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            services.AddScoped<IUserResolverService, UserResolverService>();
            services.AddScoped<ISkillRepository, SkillRepository>();
            services.AddScoped<ISkillService, SkillService>();

            services.AddScoped<IRoleRepository, RoleRepository>();
            services.AddScoped<IRoleService, RoleService>();

            services.AddScoped<IUniversityRepository, UniversityRepository>();
            services.AddScoped<IUniversityService, UniversityService>();

            services.AddScoped<IMajorRepository, MajorRepository>();
            services.AddScoped<IMajorService, MajorService>();

            services.AddScoped<IMemberRepository, MemberRepository>();
            services.AddScoped<IMemberService, MemberService>();

            services.AddScoped<IPartyRepository, PartyRepository>();
            services.AddScoped<IPartyService, PartyService>();

            services.AddScoped<IPostRepository, PostRepository>();
            services.AddScoped<IPostService, PostService>();

            services.AddScoped<ITopicRepository, TopicRepository>();
            services.AddScoped<ITopicService, TopicService>();

            services.AddScoped<IPartyInvitationRepository, PartyInvitationRepository>();
            services.AddScoped<IPartyInvitationService, PartyInvitationService>();

            services.AddScoped<IPartyRequestRepository, PartyRequestRepository>();
            services.AddScoped<IPartyRequestService, PartyRequestService>();

            services.AddScoped<ICommentRepository, CommentRepository>();
            services.AddScoped<ICommentService, CommentService>();

            services.AddScoped<IPartyMemberRepository, PartyMemberRepository>();
            services.AddScoped<IMemberMajorRepository, MemberMajorRepository>();
            services.AddScoped<IMemberSkillRepository, MemberSkillRepository>();
            services.AddScoped<IMajorSkillRepository, MajorSkillRepository>();

            services.AddScoped<IFirebaseMessageTokenRepository, FirebaseMessageTokenRepository>();
            services.AddScoped<IFirebaseMessageTokenService, FirebaseMessageTokenService>();

            services.AddCors();
            services.AddControllers().AddNewtonsoftJson(options =>
                 options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
            );
            services.AddApiVersioning(options => {
                options.AssumeDefaultVersionWhenUnspecified = true;
                options.DefaultApiVersion = ApiVersion.Default;
                options.ReportApiVersions = true;
                //options.ApiVersionReader = ApiVersionReader.Combine(
                //    new HeaderApiVersionReader("unilink-api-version"),
                //    new MediaTypeApiVersionReader("unilink-api-version")
                //);

            });
            services.AddVersionedApiExplorer(options => {
                options.SubstituteApiVersionInUrl = true;
            });
            services.AddSwaggerGen(swagger =>
            {
                swagger.SwaggerDoc("1.0", new OpenApiInfo { Title = "Unilink.Api", Version = "1.0" });
                swagger.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
                {
                    Name = "X-Unilink-Token",
                    Type = SecuritySchemeType.ApiKey,
                    Scheme = "Bearer",
                    BearerFormat = "JWT",
                    In = ParameterLocation.Header,
                    Description = "JWT Authorization header using the Bearer scheme. \r\n\r\n Enter 'Bearer' [space] and then your token in the text input below.\r\n\r\nExample: \"Bearer 12345abcdef\"",
                });
                swagger.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                          new OpenApiSecurityScheme
                            {
                                Reference = new OpenApiReference
                                {
                                    Type = ReferenceType.SecurityScheme,
                                    Id = "Bearer"
                                }
                            },
                            new string[] {}
                    }
                });
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IApiVersionDescriptionProvider provider)
        {
            if (env.IsDevelopment()||env.IsProduction()||env.IsStaging())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => { 
                    foreach(var des in provider.ApiVersionDescriptions)
                    {
                        c.SwaggerEndpoint($"/swagger/{des.GroupName}/swagger.json", des.GroupName.ToUpperInvariant());
                    }
                });
            }
            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseCors(x => x
                .SetIsOriginAllowed(origin => true)
                .AllowAnyMethod()
                .AllowAnyHeader()
                .AllowCredentials());

            app.UseAuthentication();

            app.UseAuthorization();

            app.UseMiddleware<JWTMiddlewareConfig>();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
        public FirebaseApp initFireBase()
        {
            return FirebaseApp.Create(new AppOptions()
            {
                Credential = GoogleCredential.FromFile("private_key.json")
            });
        }
    }
  
}
