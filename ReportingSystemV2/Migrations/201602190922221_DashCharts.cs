namespace ReportingSystemV2.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DashCharts : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.AspNetUsers", "LastActivity", c => c.DateTime(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.AspNetUsers", "LastActivity");
        }
    }
}
