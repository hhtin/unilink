using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Entity;

namespace Unilink.Data.Config
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<PartyInvitation>()
                 .HasKey(nameof(PartyInvitation.PartyId), nameof(PartyInvitation.MemberId), nameof(PartyInvitation.CreatedDate));
            modelBuilder.Entity<PartyRequest>()
                 .HasKey(nameof(PartyRequest.PartyId), nameof(PartyRequest.MemberId), nameof(PartyRequest.CreatedDate));
            modelBuilder.Entity<PartyMember>()
                 .HasKey(nameof(PartyMember.PartyId), nameof(PartyMember.MemberId), nameof(PartyMember.JoinDate));
            modelBuilder.Entity<MemberMajor>()
                 .HasKey(nameof(MemberMajor.MemberId), nameof(MemberMajor.MajorId));
            modelBuilder.Entity<MemberSkill>()
                 .HasKey(nameof(MemberSkill.MemberId), nameof(MemberSkill.SkillId));

            modelBuilder.Entity<Major>()
           .HasMany(p => p.Skills)
           .WithMany(p => p.Majors)
           .UsingEntity<MajorSkill>(
               j => j
                   .HasOne(pt => pt.Skill)
                   .WithMany(t => t.MajorSkills)
                   .HasForeignKey(pt => pt.SkillId),
               j => j
                   .HasOne(pt => pt.Major)
                   .WithMany(p => p.MajorSkills)
                   .HasForeignKey(pt => pt.MajorId),
               j =>j.HasKey(t => new { t.MajorId, t.SkillId })
               );
            modelBuilder.Entity<Party>()
                .HasMany(p => p.Skills)
                .WithMany(p => p.Parties)
                .UsingEntity<PartySkill>(
                j => j
                   .HasOne(pt => pt.Skill)
                   .WithMany(t => t.PartySkills)
                   .HasForeignKey(pt => pt.SkillId),
               j => j
                   .HasOne(pt => pt.Party)
                   .WithMany(p => p.PartySkills)
                   .HasForeignKey(pt => pt.PartyId),
               j => j.HasKey(t => new { t.PartyId, t.SkillId })
                );
        }

        public DbSet<University> Universities { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<Skill> Skills { get; set; }
        public DbSet<Major> Majors { get; set; }
        public DbSet<Member> Members { get; set; }
        public DbSet<Party> Parties { get; set; }
        public DbSet<Post> Posts { get; set; }
        public DbSet<Topic> Topics { get; set; }
        public DbSet<PartyInvitation> PartyInvitations { get; set; }
        public DbSet<PartyRequest> PartyRequests { get; set; }
        public DbSet<Comment> Comments{ get; set;}
        public DbSet<PartyMember> PartyMembers { get; set; }
        public DbSet<MajorSkill> MajorSkills { get; set; }
        public DbSet<PartySkill> PartySkills { get; set; }
        public DbSet<MemberMajor> MemberMajors
        {
            get; set;
        }
        public DbSet<MemberSkill> MemberSkills
        {
            get; set;
        }
        public DbSet<FirebaseMessageToken> FirebaseMessageTokens { get; set; }
    }
}
