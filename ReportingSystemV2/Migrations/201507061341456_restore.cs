namespace ReportingSystemV2.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class restore : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.AspNetUsers", "RoleAccessMap_RoleId", "dbo.RoleAccessMaps");
            DropIndex("dbo.AspNetUsers", new[] { "RoleAccessMap_RoleId" });
            DropColumn("dbo.AspNetUsers", "RoleAccessMap_RoleId");
            DropTable("dbo.RoleAccessMaps");
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.RoleAccessMaps",
                c => new
                    {
                        RoleId = c.String(nullable: false, maxLength: 128),
                        FilePageName = c.String(),
                    })
                .PrimaryKey(t => t.RoleId);
            
            AddColumn("dbo.AspNetUsers", "RoleAccessMap_RoleId", c => c.String(maxLength: 128));
            CreateIndex("dbo.AspNetUsers", "RoleAccessMap_RoleId");
            AddForeignKey("dbo.AspNetUsers", "RoleAccessMap_RoleId", "dbo.RoleAccessMaps", "RoleId");
        }
    }
}
