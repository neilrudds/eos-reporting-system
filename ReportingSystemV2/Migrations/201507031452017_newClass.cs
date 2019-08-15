namespace ReportingSystemV2.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class newClass : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.RolePages", "ApplicationUser_Id", "dbo.AspNetUsers");
            DropIndex("dbo.RolePages", new[] { "ApplicationUser_Id" });
            DropTable("dbo.RolePages");
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.RolePages",
                c => new
                    {
                        RoleId = c.String(nullable: false, maxLength: 128),
                        FilePageName = c.String(),
                        ApplicationUser_Id = c.String(maxLength: 128),
                    })
                .PrimaryKey(t => t.RoleId);
            
            CreateIndex("dbo.RolePages", "ApplicationUser_Id");
            AddForeignKey("dbo.RolePages", "ApplicationUser_Id", "dbo.AspNetUsers", "Id");
        }
    }
}
