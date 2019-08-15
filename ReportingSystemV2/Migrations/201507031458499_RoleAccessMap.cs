namespace ReportingSystemV2.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RoleAccessMap : DbMigration
    {
        public override void Up()
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
        
        public override void Down()
        {
            DropForeignKey("dbo.AspNetUsers", "RoleAccessMap_RoleId", "dbo.RoleAccessMaps");
            DropIndex("dbo.AspNetUsers", new[] { "RoleAccessMap_RoleId" });
            DropColumn("dbo.AspNetUsers", "RoleAccessMap_RoleId");
            DropTable("dbo.RoleAccessMaps");
        }
    }
}
