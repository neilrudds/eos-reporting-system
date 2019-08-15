namespace ReportingSystemV2.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RolePageAccess : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.RolePageAccesses",
                c => new
                    {
                        Id = c.Long(nullable: false, identity: true),
                        RoleId = c.String(),
                        FilePageName = c.String(),
                        ApplicationUser_Id = c.String(maxLength: 128),
                    })
                .PrimaryKey(t => t.Id)
                .ForeignKey("dbo.AspNetUsers", t => t.ApplicationUser_Id)
                .Index(t => t.ApplicationUser_Id);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.RolePageAccesses", "ApplicationUser_Id", "dbo.AspNetUsers");
            DropIndex("dbo.RolePageAccesses", new[] { "ApplicationUser_Id" });
            DropTable("dbo.RolePageAccesses");
        }
    }
}
