namespace ReportingSystemV2.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class rolepages : DbMigration
    {
        public override void Up()
        {
            RenameTable(name: "dbo.RolePageAccesses", newName: "RolePages");
        }
        
        public override void Down()
        {
            RenameTable(name: "dbo.RolePages", newName: "RolePageAccesses");
        }
    }
}
