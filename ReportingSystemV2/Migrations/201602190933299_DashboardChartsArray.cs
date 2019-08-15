namespace ReportingSystemV2.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DashboardChartsArray : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.AspNetUsers", "DashboardChartsArray", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.AspNetUsers", "DashboardChartsArray");
        }
    }
}
