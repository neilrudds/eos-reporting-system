namespace ReportingSystemV2.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class roleaccess : DbMigration
    {
        public override void Up()
        {
            DropPrimaryKey("dbo.RolePageAccesses");
            AlterColumn("dbo.RolePageAccesses", "RoleId", c => c.String(nullable: false, maxLength: 128));
            AddPrimaryKey("dbo.RolePageAccesses", "RoleId");
            DropColumn("dbo.RolePageAccesses", "Id");
        }
        
        public override void Down()
        {
            AddColumn("dbo.RolePageAccesses", "Id", c => c.Long(nullable: false, identity: true));
            DropPrimaryKey("dbo.RolePageAccesses");
            AlterColumn("dbo.RolePageAccesses", "RoleId", c => c.String());
            AddPrimaryKey("dbo.RolePageAccesses", "Id");
        }
    }
}
