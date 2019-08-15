namespace ReportingSystemV2.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class SiteAccessArray : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.AspNetUsers", "SiteAccessArray", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.AspNetUsers", "SiteAccessArray");
        }
    }
}
