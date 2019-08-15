using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Reflection;
using System.Data.SqlClient;
using System.Collections;
using System.Data.Linq;
using System.Globalization;

namespace ReportingSystemV2
{
    public class DB
    {
        ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

        class SitesOverview
        {
            public string Serial { get; set; }
            public string Generator { get; set; }
            public string Communications { get; set; }
            public string Power { get; set; }
            public string RPM { get; set; }
            public string Status { get; set; }
        }

        public class Exempts
        {
            public int Id { get; set; }
            public int IdLocation { get; set; }
            public int IdDown { get; set; }
            public int IdUp { get; set; }
            public System.DateTime DtDown { get; set; }
            public System.DateTime DtUp { get; set; }
            public int TimeDiff { get; set; }
            public System.Nullable<bool> IsExempt { get; set; }
            public string YesNo { get; set; }
        }

        #region History Data

        // IEnumerable result is required for the LINQToDataTable function
        public Tuple<IEnumerable<ed_Genset_GetHistoryByIdResult>, int> SelectComApQuery(int IdLocation, DateTime startDate, DateTime endDate)
        {
            var result = RsDc.ed_Genset_GetHistoryById(IdLocation, startDate.Date, endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)).ToList();

            int count = result.Count();

            return Tuple.Create(result.AsEnumerable(), count);
        }

        public Tuple<IEnumerable<EnergyMeters_Diris_A20>, int> SelectDirisA20Query(string serial, DateTime startDate, DateTime endDate)
        {
            var query = (from m in RsDc.EnergyMeters_Diris_A20s
                        where m.Serial == serial && m.Timestamp > startDate.Date && m.Timestamp <= endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)
                        select m).ToList();

            int count = query.Count();

            return Tuple.Create(query.AsEnumerable(), count);
        }

        public Tuple<IEnumerable<EnergyMeters_LG_E650>, int> SelectLgE650Query(string serial, DateTime startDate, DateTime endDate)
        {
            var query = (from m in RsDc.EnergyMeters_LG_E650s
                        where m.Serial == serial && m.Timestamp > startDate.Date && m.Timestamp <= endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)
                        select m).ToList();

            int count = query.Count();

            return Tuple.Create(query.AsEnumerable(), count);
        }

        public Tuple<IEnumerable<EnergyMeter>, int> SelectRH33Query(int IdLocation, DateTime startDate, DateTime endDate)
        {
            var query = (from m in RsDc.EnergyMeters
                        where m.ID_Location == IdLocation && m.Timestamp > startDate.Date && m.Timestamp <= endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)
                        select m).ToList();


            int count = query.Count();

            return Tuple.Create(query.AsEnumerable(), count);
        }

        public Tuple<IEnumerable<GasMeter>, int> SelectEHGasQuery(int IdLocation, DateTime startDate, DateTime endDate)
        {
            var query = (from m in RsDc.GasMeters
                         where m.ID_Location == IdLocation && m.Timestamp > startDate.Date && m.Timestamp <= endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)
                         select m).ToList();


            int count = query.Count();

            return Tuple.Create(query.AsEnumerable(), count);
        }

        public IEnumerable<ComAp_BinaryTypes_Mapping> SelectMappedBinaryDefinitions(int IdBlackbox)
        {
            var s = (from m in RsDc.ComAp_BinaryTypes_Mappings
                    where m.ID_Blackbox == IdBlackbox
                    select m).ToList();

            return s.AsEnumerable();
        }

        public string SelectBinaryDefinitions(int Id)
        {
            var s = (from m in RsDc.ComAp_BinaryTypes
                     where m.id == Id
                     select m).FirstOrDefault();

            return s.Tooltip;
        }

        #endregion

        #region Reporting
        //public IEnumerable<Exempts> getDowntime(string strID, System.DateTime startDate, System.DateTime endDate, bool GetReason = true)
        //{

        //    ReportingSystemDataContext db = new ReportingSystemDataContext();

        //    if (GetReason)
        //    {
        //        var query = from h in db.FILTEREXEMPTS(Convert.ToInt32(strID), startDate, endDate)
        //                select h;

        //        return query.Cast<Exempts>();
        //    }
        //    else
        //    {
        //        var query = from h in db.FILTEREXEMPTS_NOREASON(Convert.ToInt32(strID), startDate, endDate)
        //                    select new
        //                    {
        //                        Id = h.ID,
        //                        IdLocation = h.ID_LOCATION,
        //                        IdDown = h.IDDOWN,
        //                        IdUp = h.IDUP,
        //                        DtDown = h.DTDOWN,
        //                        DtUp = h.DTUP,
        //                        TimeDiff = h.TIMEDIFFERENCE,
        //                        IsExempt = h.ISEXEMPT,
        //                        YesNo = h.YesNo
        //                    };
                            

        //        //ID, ID_LOCATION, IDDOWN, IDUP, DTDOWN, DTUP, TIMEDIFFERENCE, ISEXEMPT

        //        return query.Cast<Exempts>();
        //    }
        //}

        // Check this function as with or without reason yields different results when trying to split.
        public DataTable getDowntime_SplitTimes(int IdLocation, DateTime StartDate, DateTime EndDate, bool GetReason = true, bool GetExcluded = true)
        {
            DataTable dt = new DataTable();

            if (GetReason)
            {
                if (GetExcluded)
                {
                    dt = LINQToDataTable(RsDc.ed_Exempts_GetWithReasonById(IdLocation, StartDate.Date, EndDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)));
                }
                else
                {
                    dt = LINQToDataTable(RsDc.ed_Exempts_GetWithReasonById(IdLocation, StartDate.Date, EndDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)).Where(x => x.ISEXCLUDED != true));
                }
            }
            else
            {
                if (GetExcluded)
                {
                    dt = LINQToDataTable(RsDc.ed_Exempts_GetById(IdLocation, StartDate.Date, EndDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)));
                }
                else
                {
                    dt = LINQToDataTable(RsDc.ed_Exempts_GetById(IdLocation, StartDate.Date, EndDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)).Where(x => x.ISEXCLUDED != true));
                }
            }

            //Modify the first and the last record to correspond to the requested dates.
            {
                if (dt.Rows.Count > 0)
                {
                    DateTime startdown = (DateTime)dt.Rows[0]["DTDOWN"];
                    if (startdown < StartDate)
                    {
                        DateTime startup = (DateTime)dt.Rows[0]["DTUP"];
                        dt.Rows[0]["DTDOWN"] = StartDate;
                        dt.Rows[0]["TIMEDIFFERENCE"] = ((TimeSpan)(startup - StartDate)).TotalMinutes;
                    }

                    DateTime endup = (DateTime)dt.Rows[dt.Rows.Count - 1]["DTUP"]; // Uptime
                    DateTime EndTime = EndDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59); // Required uptime
                    if (endup > EndTime)
                    {
                        DateTime enddown = (DateTime)dt.Rows[dt.Rows.Count - 1]["DTDOWN"]; // Get the shutdown time
                        dt.Rows[dt.Rows.Count - 1]["DTUP"] = EndTime; // Set the uptime to the required
                        dt.Rows[dt.Rows.Count - 1]["TIMEDIFFERENCE"] = ((TimeSpan)(EndTime - enddown)).TotalMinutes; // Set the time difference
                    }
                }
            }

            return dt;
        }

        /// <summary>
        /// /////////////////////////////////////////////////////////////////////////////////////////////////
        /// </summary>
        /// <param name="IdLocation"></param>
        /// <param name="StartDate"></param>
        /// <param name="EndDate"></param>
        /// <returns></returns>
        public Tuple<DataTable, int, int> getDowntime_SplitTimesPDF(int IdLocation, DateTime StartDate, DateTime EndDate)
        {
            DataTable dt = getDowntime_SplitTimes(IdLocation, StartDate.Date, EndDate.Date, true, false);

            int totalExempts = 0;
            int totalNonExempts = 0;

            if (dt.Columns.Count > 0)
            {
                // Get the exempt and non-exempt total mins
                foreach (DataRow dr in dt.Rows)
                {
                    if (dr["ISEXEMPT"] != System.DBNull.Value && Convert.ToBoolean(dr["ISEXEMPT"]))
                    {
                        totalExempts += Convert.ToInt32(dr["TIMEDIFFERENCE"]);
                    }
                    else
                    {
                        totalNonExempts += Convert.ToInt32(dr["TIMEDIFFERENCE"]);
                    }
                }

                // Make the table more presentable
                dt.Columns.Remove("ID");
                dt.Columns.Remove("ID_LOCATION");
                dt.Columns.Remove("IDDOWN");
                dt.Columns.Remove("IDUP");
                dt.Columns["TIMEDIFFERENCE"].ColumnName = "Duration (mins)";
                dt.Columns.Remove("ISEXEMPT");
                dt.Columns.Remove("ISEXCLUDED");
                dt.Columns["DETAILS"].ColumnName = "Notes";
                dt.Columns["YesNo"].ColumnName = "Is Exempt?";
                dt.Columns["REASON"].ColumnName = "Reason";

                // New datetime string columns
                dt.Columns.Add("Down", typeof(string));
                dt.Columns.Add("Up", typeof(string));


                // Format them
                foreach (DataRow dr in dt.Rows)
                {
                    // Format the datetime coulmns
                    string dtdown = "";
                    dtdown = ((DateTime)dr["DTDOWN"]).ToString("dd/MM/yyyy HH:mm:ss");
                    dr["Down"] = dtdown;

                    string dtup = "";
                    dtup = ((DateTime)dr["DTUP"]).ToString("dd/MM/yyyy HH:mm:ss");
                    dr["Up"] = dtup;
                }

                //Remove the origninal
                dt.Columns.Remove("DTDOWN");
                dt.Columns.Remove("DTUP");

                // Set column order
                dt.SetColumnsOrder("Down", "Up", "Duration (mins)", "Is Exempt?", "Reason", "Notes");

            }

            return Tuple.Create(dt, totalExempts, totalNonExempts);
        }

        public Tuple<DataTable, int, int> getAvailabilityWithSummary(int IdLocation, DateTime StartDate, DateTime EndDate)
        {
            var availability = (from x in RsDc.GeneratorAvailabilities
                                where x.IdLocation == IdLocation && x.DtUnavailable >= StartDate && x.DtAvailable < EndDate.AddHours(23).AddMinutes(59).AddSeconds(59) && (x.Exclude == false || x.Exclude == null)
                                select new
                                {
                                    Unavailable = x.DtUnavailable,
                                    Available = x.DtAvailable,
                                    TimeDifference = x.TimeDifference,
                                    Reason = x.Reason,
                                    Exempt = (x.IsExempt == true) ? "Yes" : (x.IsExempt == false) ? "No" : "Unverified",
                                    IsExempt = x.IsExempt,
                                    Notes = x.Details
                                });

            int? totalExempts = availability.Where(x => x.IsExempt == true).Sum(x => (int?)x.TimeDifference);
            int? totalNonExempts = availability.Where(x => x.IsExempt == null || x.IsExempt == false).Sum(x => (int?)x.TimeDifference);

            TimeSpan tsTotalExempts = new TimeSpan(0, Convert.ToInt32(totalExempts), 0);
            TimeSpan tsTotalNonExempts = new TimeSpan(0, Convert.ToInt32(totalNonExempts), 0);

            // Convert to a datatable
            DataTable dt = LINQToDataTable(availability);

            if (dt.Columns.Count > 0)
            {
                // Make the table more presentable
                dt.Columns["TimeDifference"].ColumnName = "Duration (mins)";
                dt.Columns["Exempt"].ColumnName = "Is Exempt?";
                dt.Columns.Remove("IsExempt");
            }
            return Tuple.Create(dt, Convert.ToInt32(totalExempts), Convert.ToInt32(totalNonExempts));
        }


        public void populatedg_ReportSummary()
        {
            ReportingSystemDataContext db = new ReportingSystemDataContext();

            var dt = new DataTable();

            var q = (
            from a in db.GetTable<HL_Log>()
            where a.Time_Stamp > DateTime.Now.AddDays(-1)
            select new
            {
                a.ID_Location,
                Runhours = a.Runhrs.Max() - a.Runhrs.Min()
            });

            dt.Columns.Add("Genset Name");
            dt.Columns.Add("Run Hours");

            foreach (var item in q)
            {
                DataRow row = dt.NewRow();
                row["Genset Name"] = item.ID_Location;
                row["Run Hours"] = item.Runhours;
                dt.Rows.Add(row);
            }

            //dg_ReportSummary.DataSource = q.ToList();
        }

        public IEnumerable getAllReasonForDownTimeAppend(int locationId, DateTime startDate, DateTime endDate, int adjust, int ExemptId)
        {
            ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

            var detail = from s in RsDc.ed_Genset_GetEvents(locationId, startDate.AddMinutes(-adjust), endDate.AddMinutes(adjust))
                         select new
                         {
                             ExemptId = ExemptId, // Append the Exempt Id to the table
                             Id = s.ID,
                             Timestamp = s.TIME_STAMP,
                             Reason = s.REASON,
                             Event = s.EVENT
                         };

            return detail;
        }

        public IEnumerable getAllReasonForLoadTimeAppend(int locationId, DateTime startDate, DateTime endDate, int adjust, int StartUpId)
        {
            ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

            var detail = from s in RsDc.ed_Genset_GetEvents(locationId, startDate.AddMinutes(-adjust), endDate.AddMinutes(adjust))
                         select new
                         {
                             StartUpId = StartUpId, // Append the Exempt Id to the table
                             Id = s.ID,
                             Timestamp = s.TIME_STAMP,
                             Reason = s.REASON,
                             Event = s.EVENT
                         };

            return detail;
        }

        public IEnumerable getAllReasonForAvailabilityAppend(int IdLocation, DateTime StartDate, DateTime EndDate, int Adjust, int IdAvailability)
        {
            ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

            var detail = from s in RsDc.ed_Genset_GetEvents(IdLocation, StartDate.AddMinutes(-Adjust), EndDate.AddMinutes(Adjust))
                         select new
                         {
                             IdAvailability = IdAvailability, // Append the Exempt Id to the table
                             Id = s.ID,
                             Timestamp = s.TIME_STAMP,
                             Reason = s.REASON,
                             Event = s.EVENT
                         };

            return detail;
        }

        //public DataTable _Obselete_getAllReasonForLoadTimeAppend(int locationId, DateTime startDate, DateTime endDate, int adjust, int StartUpId)
        //{
        //    ReportingSystemDataContext db = new ReportingSystemDataContext();

        //    var dt = new DataTable();

        //    dt = LINQToDataTable(db.getAllReasonForLoadTime(locationId, startDate.AddMinutes(-adjust), endDate.AddMinutes(adjust)));

        //    // Append table with StartUp ID
        //    DataColumn dcStartUp = new DataColumn();
        //    dcStartUp = dt.Columns.Add("StartUpId", Type.GetType("System.Int32"));

        //    foreach (DataRow dr in dt.Rows)
        //    {
        //        dr["StartUpId"] = StartUpId;
        //    }

        //    return dt;
        //}

        public string GetContractType(int locationId)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var query = (from g in RsDc.HL_Locations
                            join c in RsDc.ContractInformations on g.ID_ContractInformation equals c.ID
                            join t in RsDc.ContractTypes on c.ID_ContractType equals t.ID
                            where g.ID == locationId
                            select new { Name = t.Contract_Type }).FirstOrDefault();

                if (query != null)
                {
                    return query.Name;
                }
                else
                {
                    return "Undefined";
                }
            }
        }


        #endregion

        #region Charting Data
        #endregion

        #region Overview
        //public List<SitesOverview> GetSitesOverview()
        //{
        //    ReportingSystemDataContext db = new ReportingSystemDataContext();

        //    var query = from h in db.HL_Locations
        //                orderby h.GENSETNAME
        //                select new
        //                {
        //                    Serial = h.GENSET_SN,
        //                    Generator = h.GENSETNAME,
        //                    Communications = 0,
        //                    Power = 0,
        //                    RPM = 0,
        //                    Status = 0
        //                };

        //    return query.AsEnumerable<SitesOverview>;
        //}
        #endregion

        #region Shutdowns

        // Not used as table has no primary key
        public bool updateShutdownExcluded(int Id, bool excluded)
        {
            using (ReportingSystemDataContext dataContext = new ReportingSystemDataContext())
            {
                var shut = (from s in dataContext.Exempts
                            where s.ID == Id
                            select s).FirstOrDefault();

                if (shut != null)
                {
                    shut.IsExcluded = excluded;
                    dataContext.SubmitChanges();
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        #endregion

        #region Linq Helpers
        public DataTable LINQToDataTable<t>(IEnumerable<t> varlist)
        {
            DataTable dtReturn = new DataTable();

            // column names 
            PropertyInfo[] oProps = null;

            if (varlist == null) return dtReturn;

            foreach (t rec in varlist)
            {
                // Use reflection to get property names, to create table, Only first time, others will follow 
                if (oProps == null)
                {
                    oProps = ((Type)rec.GetType()).GetProperties();
                    foreach (PropertyInfo pi in oProps)
                    {
                        Type colType = pi.PropertyType;

                        if ((colType.IsGenericType) && (colType.GetGenericTypeDefinition() == typeof(Nullable<>)))
                        {
                            colType = colType.GetGenericArguments()[0];
                        }

                        dtReturn.Columns.Add(new DataColumn(pi.Name, colType));
                    }
                }

                DataRow dr = dtReturn.NewRow();

                foreach (PropertyInfo pi in oProps)
                {
                    dr[pi.Name] = pi.GetValue(rec, null) == null ? DBNull.Value : pi.GetValue
                    (rec, null);
                }

                dtReturn.Rows.Add(dr);
            }
            return dtReturn;
        }

        public DataTable RemoveEmptyColumns(DataTable dt)
        {
            //loop through the table and remove empty columns
            foreach (var column in dt.Columns.Cast<DataColumn>().ToArray())
            {
                if (dt.AsEnumerable().All(dr => dr.IsNull(column)))
                    dt.Columns.Remove(column);
            }

            return dt;
        }
        #endregion

        #region Control Panel

        // Site Management

        public bool updateGeneratorDetails(int locationId, string GeneratorName, string SiteName)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var GenDetails = (from g in RsDc.HL_Locations where g.ID == locationId select g).SingleOrDefault();

                if (GenDetails != null)
                {
                    //Update
                    GenDetails.GENSETNAME = GeneratorName;
                    GenDetails.SITENAME = SiteName;
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool updateOrInsertGeneratorGeoLocation(int locationId, string Lat, string Long, string Desc)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var GenGeo = (from g in RsDc.GensetLocations where g.ID_Location == locationId select g).SingleOrDefault();

                if (GenGeo != null)
                {
                    // Update
                    GenGeo.Latitude = Convert.ToDecimal(Lat);
                    GenGeo.Longitude = Convert.ToDecimal(Long);
                    GenGeo.Description = Desc;
                }
                else
                {
                    GensetLocation Geo = new GensetLocation
                    {
                        ID_Location = locationId,
                        Longitude = Convert.ToDecimal(Lat),
                        Latitude = Convert.ToDecimal(Long),
                        Description = Desc
                    };
                    RsDc.GensetLocations.InsertOnSubmit(Geo);
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool updateOrInsertContractInformation(int locationId, string Id_Type, string Output, string Avail, string Cycle, string StartDate, string Length, string RunHrs, string kWh)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var CId = (from g in RsDc.HL_Locations
                           where g.ID == locationId
                           select g).FirstOrDefault();

                var TypeName = (from t in RsDc.ContractTypes
                                where t.ID == Convert.ToInt32(Id_Type)
                                select t.Contract_Type).FirstOrDefault();

                // Parse the contract start date
                DateTime d;
                bool Valid = DateTime.TryParseExact(StartDate, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out d);
                if (!Valid)
                {
                    return false;
                }

                if (CId.ID_ContractInformation != null && TypeName != null)
                {
                    // Update
                    var c = (from s in RsDc.ContractInformations
                             where s.ID == CId.ID_ContractInformation
                             select s).FirstOrDefault();

                    if (c != null)
                    {
                        c.ContractType = TypeName.ToString();
                        c.ID_ContractType = Convert.ToInt32(Id_Type);
                        c.ContractOutput = Convert.ToInt32(Output);
                        c.ContractAvailability = Convert.ToDecimal(Avail);
                        c.DutyCycle = Convert.ToInt32(Cycle);
                        c.ContractStartDate = d;
                        c.ContractLength = Convert.ToInt32(Length);
                        c.InitialRunHrs = Convert.ToInt32(RunHrs);
                        c.InitialKwHours = Convert.ToInt32(kWh);

                        // Submit
                        try
                        {
                            RsDc.SubmitChanges();
                            return true;
                        }
                        catch
                        {
                            return false;
                        }
                    }
                    else
                    {
                        // Update Failed, Contract info is corrupt
                        return false;
                    }
                }
                else
                {
                    // Insert
                    ContractInformation Ci = new ContractInformation
                    {
                        ContractType = TypeName.ToString(),
                        ID_ContractType = Convert.ToInt32(Id_Type),
                        ContractOutput = Convert.ToInt32(Output),
                        ContractAvailability = Convert.ToDecimal(Avail),
                        DutyCycle = Convert.ToInt32(Cycle),
                        ContractStartDate = d,
                        ContractLength = Convert.ToInt32(Length),
                        InitialRunHrs = Convert.ToInt32(RunHrs),
                        InitialKwHours = Convert.ToInt32(kWh),
                    };

                    RsDc.ContractInformations.InsertOnSubmit(Ci);

                    // Submit & Update the ID in the HL_Locations Table
                    try
                    {
                        RsDc.SubmitChanges(); // Insert contract info
                        CId.ID_ContractInformation = Ci.ID; // Get its Id and set to HL_Locations
                        RsDc.SubmitChanges(); // Apply
                        return true;
                    }
                    catch
                    {
                        return false;
                    }
                }
            }
        }

        public bool updateOrInsertReportConfig(int locationId, bool ShowEfficiency, bool ShowUptime, bool AvailabilityFlag)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var ReportConfig = (from cfg in RsDc.ConfigReports where cfg.IdLocation == locationId select cfg).SingleOrDefault();

                if (ReportConfig != null)
                {
                    //Update
                    ReportConfig.ShowEfficiency = ShowEfficiency;
                    ReportConfig.ShowUptime = ShowUptime;
                    ReportConfig.AvailabilityBasedOnUnitUnavailableFlag = AvailabilityFlag;
                }
                else
                {
                    ConfigReport cfgrep = new ConfigReport
                    {
                        IdLocation = locationId,
                        ShowEfficiency = ShowEfficiency,
                        ShowUptime = ShowUptime,
                        AvailabilityBasedOnUnitUnavailableFlag = AvailabilityFlag
                    };

                    RsDc.ConfigReports.InsertOnSubmit(cfgrep);
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool updateOrInsertReportConfigTrendArray(int locationId, string TrendArray)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var ReportConfig = (from cfg in RsDc.ConfigReports where cfg.IdLocation == locationId select cfg).SingleOrDefault();

                if (ReportConfig != null)
                {
                    //Update
                    ReportConfig.TrendChartArray = TrendArray;
                }
                else
                {
                    ConfigReport cfgrep = new ConfigReport
                    {
                        IdLocation = locationId,
                        TrendChartArray = TrendArray
                    };

                    RsDc.ConfigReports.InsertOnSubmit(cfgrep);
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool updateOrInsertEfficiencyConfig(int locationId, string GasVolColName, double CalorificVal, bool IsGasVolCorrected)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var EfficiencyConfig = (from s in RsDc.ConfigEfficiencies where s.IdLocation == locationId select s).SingleOrDefault();

                if (EfficiencyConfig != null)
                {
                    // Update
                    EfficiencyConfig.GasVolumeColumnName = GasVolColName;
                    EfficiencyConfig.GasCalorificValue = CalorificVal;
                    EfficiencyConfig.IsGasVolumeCorrected = IsGasVolCorrected;
                }
                else
                {
                    // Insert
                    ConfigEfficiency Ce = new ConfigEfficiency
                    {
                        IdLocation = locationId,
                        GasVolumeColumnName = GasVolColName,
                        GasCalorificValue = CalorificVal,
                        IsGasVolumeCorrected = IsGasVolCorrected
                    };
                    RsDc.ConfigEfficiencies.InsertOnSubmit(Ce);
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool UpdateOrInsertGasMeter_Mapping(int locationId, int? GasMeterAddress)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var GasMap = (from s in RsDc.GasMeters_Mappings where s.ID_Location == locationId select s).SingleOrDefault();

                int GasMeterAddr = 0;
                if (GasMeterAddress == null)
                {
                    // Delete record
                    if (GasMap != null)
                    {
                        RsDc.GasMeters_Mappings.DeleteOnSubmit(GasMap);
                    }
                }
                else
                {
                    GasMeterAddr = Convert.ToInt32(GasMeterAddress);

                    if (GasMap != null)
                    {
                        // Update
                        GasMap.Modbus_Addr = GasMeterAddr;
                    }
                    else
                    {
                        // Insert
                        GasMeters_Mapping Gm = new GasMeters_Mapping
                        {
                            ID_Location = locationId,
                            Modbus_Addr = GasMeterAddr
                        };
                        RsDc.GasMeters_Mappings.InsertOnSubmit(Gm);
                    }
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool updateEngineType(int locationId, int? EngineTypeId)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var Genset = (from s in RsDc.HL_Locations where s.ID == locationId select s).SingleOrDefault();

                if (Genset != null)
                {
                    Genset.ID_EngineType = EngineTypeId;
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool updateOrInsertGasType_Mapping(int locationId, int? GasTypeId)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var GasTypeMap = (from s in RsDc.GasTypes_Mappings where s.ID_Location == locationId select s).SingleOrDefault();

                // Already exists, therefore update it
                if (GasTypeMap != null)
                {
                    if (GasTypeId != null)
                    {
                        // Update
                        GasTypeMap.ID_GasType = (int)GasTypeId;
                    }
                }
                else
                {
                    // Insert
                    GasTypes_Mapping Gt = new GasTypes_Mapping
                    {
                        ID_Location = locationId,
                        ID_GasType = (int)GasTypeId
                    };
                    RsDc.GasTypes_Mappings.InsertOnSubmit(Gt);
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool updateMeterMapping_BySerial(string Serial, int IdLocation, int IdType)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                if (Serial == "-1")
                {
                    var MeterMap = (from m in RsDc.EnergyMeters_Mapping_Serials where m.ID_Location == IdLocation && m.ID_Type == IdType select m).SingleOrDefault();

                    if (MeterMap != null)
                    {
                        //Remove the map
                        MeterMap.ID_Location = null;
                        MeterMap.ID_Type = null;
                    }

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch
                    {
                        return false;
                    }

                }
                else
                {
                    var MeterMap = (from m in RsDc.EnergyMeters_Mapping_Serials where m.Serial == Serial select m).SingleOrDefault();

                    if (MeterMap != null)
                    {
                        //Update
                        MeterMap.ID_Location = IdLocation;
                        MeterMap.ID_Type = IdType;
                    }

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch
                    {
                        return false;
                    }
                }
            }
        }

        // SMS

        public bool updateSMSGroupId(int locationId, int? SMSGroupId)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var Genset = (from s in RsDc.HL_Locations where s.ID == locationId select s).SingleOrDefault();
            
                if (Genset != null)
                {
                    Genset.ID_SMS_Group = SMSGroupId;
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        // SMS Group
        public bool deleteSMSGroup(int SMSGroupId)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var SMSGroup = (from s in RsDc.sms_Mappings where s.id == SMSGroupId select s).SingleOrDefault();

                if (SMSGroup != null)
                {
                    RsDc.sms_Mappings.DeleteOnSubmit(SMSGroup);
                }
                else
                {
                    return false;
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool isSMSGroupInUse(int SMSGroupId)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var RecCount = (from s in RsDc.HL_Locations where s.ID_SMS_Group == SMSGroupId select s).Count();

                if (RecCount > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        public bool updateSMSGroup(int SMSGroupId, string Name, string Recipient)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var SMSGroup = (from s in RsDc.sms_Mappings where s.id == SMSGroupId select s).SingleOrDefault();

                if (SMSGroup != null)
                {
                    SMSGroup.SMS_Group = Name;
                    SMSGroup.SMS_Recipient = Recipient;
                }
                else
                {
                    return false;
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool insertSMSGroup(string Name, string Recipient)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                sms_Mapping sms = new sms_Mapping();

                sms.SMS_Group = Name;
                sms.SMS_Recipient = Recipient;

                RsDc.sms_Mappings.InsertOnSubmit(sms);

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        // SMS Logs
        public IEnumerable getSMSLog(DateTime StartDate, DateTime EndDate, int? locationId = null)
        {
            ReportingSystemDataContext RsDc = new ReportingSystemDataContext();

            var SMSLog = (dynamic)null;

            if (locationId == null)
            {
                // No Location Filter
                SMSLog = (from s in RsDc.BB_SMSLogs
                          where s.SMS_SendTime >= StartDate && s.SMS_SendTime < EndDate
                          orderby s.SMS_SendTime descending
                          select new
                          {
                              Genset = (from l in RsDc.HL_Locations where l.ID == s.ID_Location select l.GENSETNAME).FirstOrDefault().ToString(),
                              SMS_Content = s.SMS_Content,
                              SMS_Recipient = s.SMS_Recipient,
                              SMS_SendTime = s.SMS_SendTime
                          });
            }
            else
            {
                // Filter Location
                SMSLog = (from s in RsDc.BB_SMSLogs
                          where s.SMS_SendTime >= StartDate && s.SMS_SendTime < EndDate && s.ID_Location == locationId
                          orderby s.SMS_SendTime descending
                          select new
                          {
                              Genset = (from l in RsDc.HL_Locations where l.ID == s.ID_Location select l.GENSETNAME).FirstOrDefault().ToString(),
                              SMS_Content = s.SMS_Content,
                              SMS_Recipient = s.SMS_Recipient,
                              SMS_SendTime = s.SMS_SendTime
                          });
            }

            return SMSLog;
        }

        // Unit Management
        // Modify History
        public bool updateHistoryHeaders(string unitSerial, string headerString, string TypeStr, string LenStr, string DecStr, string ObjNameStr = null, string ObjTypeStr = null, string HistoryColIDsStr = null)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var unit = (from u in RsDc.Blackboxes
                            where u.BB_SerialNo == unitSerial
                            select u).FirstOrDefault();

                if (unit.BB_SerialNo != null && headerString.Length > 0 && TypeStr.Length > 0 && LenStr.Length > 0 && DecStr.Length > 0)
                {
                    unit.CFG_HistoryColNameStr = headerString;
                    unit.CFG_HistoryColTypeStr = TypeStr;
                    unit.CFG_CommsObjLenStr = LenStr;
                    unit.CFG_CommsObjDecStr = DecStr;
                    unit.CFG_CommsObjNameStr = ObjNameStr;
                    unit.CFG_CommsObjTypeStr = ObjTypeStr;
                    unit.CFG_HistoryColIDsStr = HistoryColIDsStr;
                    unit.CFG_State = 3; // System needs to take new settings

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch (Exception e)
                    {
                        LogMe.LogSystemException(e.Message);
                        return false;
                    }
                }
                else
                {
                    return false;
                }
            }
        }

        public void updateBinaryDefinition(DataTable defs, int ID_Blackbox)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                foreach (DataRow def in defs.Rows)
                {
                    if (def != null && ((string)def["Type"]).Length > 0 && ((string)def["Def"]).Length > 0)
                    {
                        try
                        {
                            RsDc.ed_ComapBinaryDefinition_Insert(ID_Blackbox, (string)def["Type"], (string)def["Def"]);

                        }
                        catch (Exception e)
                        {
                            LogMe.LogSystemException(e.Message);
                        }
                    }
                }
            }
        }

        public void updateBinaryMap(int ID_Blackbox, string ColumnName, string binaryType)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                if (ID_Blackbox != null && ColumnName.Length > 0 && binaryType.Length > 0)
                {
                    try
                    {
                        RsDc.ed_ComapBinaryMap_Insert(ID_Blackbox, ColumnName, binaryType);

                    }
                    catch (Exception e)
                    {
                        LogMe.LogSystemException(e.Message);
                    }
                }
            }
        }

        #endregion

        #region Administration

        // History Headers
        public bool insertHistoryHeader(string Name, string Description)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                // Exists
                var RecCount = (from s in RsDc.ComAp_Headers where s.History_Header == Name select s).Count();

                if (RecCount == 0)
                {
                    ComAp_Header head = new ComAp_Header();

                    head.History_Header = Name;
                    head.History_Description = Description;

                    RsDc.ComAp_Headers.InsertOnSubmit(head);

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch
                    {
                        return false;
                    }
                }
                else
                {
                    LogMe.LogUserMessage(string.Format("The history header already exists and cannot be created. {0}", Name));
                    return false;
                }
            }
        }

        public bool isHistoryHeaderInUse(int HistoryHeaderId)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var RecCount = (from s in RsDc.ComAp_Wildcards where s.id_Header == HistoryHeaderId select s).Count();

                if (RecCount > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        public bool deleteHistoryHeader(int HistoryHeaderId)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var Header = (from s in RsDc.ComAp_Headers where s.id == HistoryHeaderId select s).SingleOrDefault();

                if (Header != null)
                {
                    RsDc.ComAp_Headers.DeleteOnSubmit(Header);
                }
                else
                {
                    return false;
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool updateHistoryHeader(int HistoryHeaderId, string Name, string Description)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var Header = (from s in RsDc.ComAp_Headers where s.id == HistoryHeaderId select s).SingleOrDefault();

                if (Header != null)
                {
                    Header.History_Header = Name;
                    Header.History_Description = Description;
                }
                else
                {
                    return false;
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        // History Mapping
        public bool updateMapApprovedFlag(int Id, bool approved)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var ColumnMap = (from s in RsDc.ComAp_Wildcards where s.id == Id select s).SingleOrDefault();

                if (ColumnMap != null)
                {
                    // Update
                    ColumnMap.Approved = approved;
                }
                else
                {
                    return false;
                }
                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool updateMapHeaderId(int Id, int headerId)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var ColumnMap = (from s in RsDc.ComAp_Wildcards where s.id == Id select s).SingleOrDefault();

                if (ColumnMap != null && headerId != null)
                {
                    // Update
                    ColumnMap.id_Header = headerId;
                }
                else
                {
                    return false;
                }
                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        // Column Properties

        public bool updateOrInsertColumnProperty(int headerId, string ColumnLabel, bool IsInstantaneousPlot, bool IsCumulativePlot, bool IsAvailableInReports, string ColumnUnits, string ColumnHtmlColor)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var ColumnProperty = (from s in RsDc.ColumnNames where s.HeaderId == headerId select s).FirstOrDefault();

                if (ColumnProperty != null)
                {
                    // Update
                    ColumnProperty.ColumnLabel = ColumnLabel;
                    ColumnProperty.IsInstantaneousPlot = IsInstantaneousPlot;
                    ColumnProperty.IsCumulativePlot = IsCumulativePlot;
                    ColumnProperty.IsAvailableInReports = IsAvailableInReports;
                    ColumnProperty.ColumnUnits = ColumnUnits;
                    ColumnProperty.ColumnHtmlColor = ColumnHtmlColor;
                }
                else
                {
                    // Insert
                    ColumnName Col = new ColumnName
                    {
                        HeaderId = headerId,
                        ColumnLabel = ColumnLabel,
                        IsInstantaneousPlot = IsInstantaneousPlot,
                        IsCumulativePlot = IsCumulativePlot,
                        IsAvailableInReports = IsAvailableInReports,
                        ColumnUnits = ColumnUnits,
                        ColumnHtmlColor = ColumnHtmlColor
                    };

                    RsDc.ColumnNames.InsertOnSubmit(Col);
                }
                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        public bool deleteColumnProperties(int HeaderId)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                var ColumnProperty = (from s in RsDc.ColumnNames where s.HeaderId == HeaderId select s).SingleOrDefault();

                if (ColumnProperty != null)
                {
                    RsDc.ColumnNames.DeleteOnSubmit(ColumnProperty);
                }
                else
                {
                    return false;
                }

                try
                {
                    RsDc.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
        }

        // Meter Types
        public bool updateOrInsertMeterType(string MeterType, int MeterCategory, int Id = 0)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                if (Id == 0) // This should be new
                {
                    var Meter = (from s in RsDc.EnergyMeters_Types where s.Meter_Type == MeterType select s).SingleOrDefault();

                    if (Meter == null && MeterCategory != null)
                    {
                        // doesnt exist, lets insert
                        EnergyMeters_Type em = new EnergyMeters_Type
                        {
                            Meter_Type = MeterType,
                            Meter_Category = MeterCategory
                        };
                        RsDc.EnergyMeters_Types.InsertOnSubmit(em);
                    }
                    else
                    {
                        // no can do, item with that name exists
                        return false;
                    }

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch
                    {
                        return false;
                    }
                }
                else
                {
                    // id defined so update
                    var Meter = (from s in RsDc.EnergyMeters_Types where s.id == Id select s).SingleOrDefault();

                    if (Meter != null && MeterCategory != null)
                    {
                        Meter.Meter_Type = MeterType;
                        Meter.Meter_Category = MeterCategory;
                    }
                    else
                    {
                        // nothing to update
                        return false;
                    }

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch
                    {
                        return false;
                    }
                }
            }
        }

        public bool deleteMeterType(int Id)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                // Is it in use?
                var MeterType = (from s in RsDc.EnergyMeters_Types where s.id == Id select s).SingleOrDefault();

                var Mapped = (from s in RsDc.EnergyMeters_Mappings where s.ID_Type == Id && (s.Modbus_Addr == null || s.Modbus_Addr == -1) select s);

                if (Mapped.Count() > 0)
                {
                    // Cannot delete as its in use
                    return false;
                }
                else
                {
                    // delete if it exists
                    if (MeterType != null)
                    {
                        RsDc.EnergyMeters_Types.DeleteOnSubmit(MeterType);

                        try
                        {
                            RsDc.SubmitChanges();
                            return true;
                        }
                        catch
                        {
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }

        // Meter Categories
        public bool updateOrInsertMeterCategory(string MeterCategory, int Id = 0)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                if (Id == 0) // This should be new
                {
                    var Meter = (from s in RsDc.EnergyMeters_Types_Categories where s.Category_Name == MeterCategory select s).SingleOrDefault();

                    if (Meter == null)
                    {
                        // doesnt exist, lets insert
                        EnergyMeters_Types_Category emc = new EnergyMeters_Types_Category
                        {
                            Category_Name = MeterCategory
                        };
                        RsDc.EnergyMeters_Types_Categories.InsertOnSubmit(emc);
                    }
                    else
                    {
                        // no can do, item with that name exists
                        return false;
                    }

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch
                    {
                        return false;
                    }
                }
                else
                {
                    // id defined so update
                    var Meter = (from s in RsDc.EnergyMeters_Types_Categories where s.Id == Id select s).SingleOrDefault();

                    if (Meter != null)
                    {
                        Meter.Category_Name = MeterCategory;
                    }
                    else
                    {
                        // nothing to update
                        return false;
                    }

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch
                    {
                        return false;
                    }
                }
            }
        }

        public bool deleteMeterCategory(int Id)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                // Is it in use?
                var MeterCategory = (from s in RsDc.EnergyMeters_Types_Categories where s.Id == Id select s).SingleOrDefault();

                var Mapped = (from s in RsDc.EnergyMeters_Types where s.Meter_Category == Id select s);

                if (Mapped.Count() > 0)
                {
                    // Cannot delete as its in use
                    return false;
                }
                else
                {
                    // delete if it exists
                    if (MeterCategory != null)
                    {
                        RsDc.EnergyMeters_Types_Categories.DeleteOnSubmit(MeterCategory);

                        try
                        {
                            RsDc.SubmitChanges();
                            return true;
                        }
                        catch
                        {
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }

        // Engine Types
        public bool updateOrInsertEngineType(string Make, string Model, int Cylinders, int MaxOut, string Description, int Id = 0)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                if (Id == 0) // This should be new
                {
                    var Engine = (from s in RsDc.EngineTypes where s.Description == Description select s).SingleOrDefault();

                    if (Engine == null)
                    {
                        // doesnt exist, lets insert
                        EngineType eng = new EngineType
                        {
                            Make = Make,
                            Model = Model,
                            Cylinders = Cylinders,
                            MaximumOutput = MaxOut,
                            Description = Description
                        };
                        RsDc.EngineTypes.InsertOnSubmit(eng);
                    }
                    else
                    {
                        // no can do, item with that name exists
                        return false;
                    }

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch
                    {
                        return false;
                    }
                }
                else
                {
                    // id defined so update
                    var Engine = (from s in RsDc.EngineTypes where s.ID == Id select s).SingleOrDefault();

                    if (Engine != null)
                    {
                        Engine.Make = Make;
                        Engine.Model = Model;
                        Engine.Cylinders = Cylinders;
                        Engine.MaximumOutput = MaxOut;
                        Engine.Description = Description;
                    }
                    else
                    {
                        // nothing to update
                        return false;
                    }

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch
                    {
                        return false;
                    }
                }
            }
        }

        public bool deleteEngineType(int Id)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                // Is it in use?
                var EngineType = (from s in RsDc.EngineTypes where s.ID == Id select s).SingleOrDefault();

                var Mapped = (from s in RsDc.HL_Locations where s.ID_EngineType == Id select s);

                if (Mapped.Count() > 0)
                {
                    // Cannot delete as its in use
                    return false;
                }
                else
                {
                    // delete if it exists
                    if (EngineType != null)
                    {
                        RsDc.EngineTypes.DeleteOnSubmit(EngineType);

                        try
                        {
                            RsDc.SubmitChanges();
                            return true;
                        }
                        catch
                        {
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }

        // Gas Types
        public bool updateOrInsertGasType(string GasType, int Id = 0)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                if (Id == 0) // This should be new
                {
                    var Gas = (from s in RsDc.GasTypes where s.Gas_Type == GasType select s).SingleOrDefault();

                    if (Gas == null)
                    {
                        // doesnt exist, lets insert
                        GasType gt = new GasType
                        {
                            Gas_Type = GasType
                        };
                        RsDc.GasTypes.InsertOnSubmit(gt);
                    }
                    else
                    {
                        // no can do, item with that name exists
                        return false;
                    }

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch (Exception e)
                    {
                        LogMe.LogSystemException(e.Message);
                        return false;
                    }
                }
                else
                {
                    // id defined so update
                    var Gas = (from s in RsDc.GasTypes where s.ID == Id select s).SingleOrDefault();

                    if (Gas != null)
                    {
                        Gas.Gas_Type = GasType;
                    }
                    else
                    {
                        // nothing to update
                        return false;
                    }

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch (Exception e)
                    {
                        LogMe.LogSystemException(e.Message);
                        return false;
                    }
                }
            }
        }

        public bool deleteGasType(int Id)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                // Is it in use?
                var GasType = (from s in RsDc.GasTypes where s.ID == Id select s).SingleOrDefault();

                var Mapped = (from s in RsDc.GasTypes_Mappings where s.ID_GasType == Id select s);

                if (Mapped.Count() > 0)
                {
                    // Cannot delete as its in use
                    return false;
                }
                else
                {
                    // delete if it exists
                    if (GasType != null)
                    {
                        RsDc.GasTypes.DeleteOnSubmit(GasType);

                        try
                        {
                            RsDc.SubmitChanges();
                            return true;
                        }
                        catch
                        {
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }

        // Contract Types
        public bool updateOrInsertContractType(string ContractType, int Id = 0)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                if (Id == 0) // This should be new
                {
                    var Contract = (from s in RsDc.ContractTypes where s.Contract_Type == ContractType select s).SingleOrDefault();

                    if (Contract == null)
                    {
                        // doesnt exist, lets insert
                        ContractType ct = new ContractType
                        {
                            Contract_Type = ContractType
                        };
                        RsDc.ContractTypes.InsertOnSubmit(ct);
                    }
                    else
                    {
                        // no can do, item with that name exists
                        return false;
                    }

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch (Exception e)
                    {
                        LogMe.LogSystemException(e.Message);
                        return false;
                    }
                }
                else
                {
                    // id defined so update
                    var Contract = (from s in RsDc.ContractTypes where s.ID == Id select s).SingleOrDefault();

                    if (Contract != null)
                    {
                        Contract.Contract_Type = ContractType;
                    }
                    else
                    {
                        // nothing to update
                        return false;
                    }

                    try
                    {
                        RsDc.SubmitChanges();
                        return true;
                    }
                    catch (Exception e)
                    {
                        LogMe.LogSystemException(e.Message);
                        return false;
                    }
                }
            }
        }

        public bool deleteContractType(int Id)
        {
            using (ReportingSystemDataContext RsDc = new ReportingSystemDataContext())
            {
                // Is it in use?
                var ContractType = (from s in RsDc.ContractTypes where s.ID == Id select s).SingleOrDefault();

                var Mapped = (from s in RsDc.ContractInformations where s.ID_ContractType == Id select s);

                if (Mapped.Count() > 0)
                {
                    // Cannot delete as its in use
                    return false;
                }
                else
                {
                    // delete if it exists
                    if (ContractType != null)
                    {
                        RsDc.ContractTypes.DeleteOnSubmit(ContractType);

                        try
                        {
                            RsDc.SubmitChanges();
                            return true;
                        }
                        catch
                        {
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }
        #endregion
    }

    public partial class ReportingSystemDataContext : System.Data.Linq.DataContext
    {
        // Change the query timeout....
        partial void OnCreated()
        {
            //Put your desired timeout here.
            this.CommandTimeout = 180; // 3 mins

            //If you do not want to hard code it, then take it 
            //from Application Settings / AppSettings
            //this.CommandTimeout = Settings.Default.CommandTimeout;
        }
    }

    public partial class CustomDataContext : ReportingSystemV2.ReportingSystemDataContext
    {
        public IEnumerable<generatorSummary> GetMembersMatchingSites(List<string> sites, DateTime dtstart, object dtend = null)
        {
            DataTable sitesTable = new DataTable();
            sitesTable.Columns.Add("N", typeof(string));

            foreach (string e in sites)
                sitesTable.Rows.Add(e);

            using (SqlConnection conn = new SqlConnection(Connection.ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("dbo.ed_Genset_GetSummaryByUserGensetIds", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter p = cmd.Parameters.AddWithValue("@IDS", sitesTable);
                p.SqlDbType = SqlDbType.Structured;
                p.TypeName = "integer_list_tbltype";

                p = cmd.Parameters.AddWithValue("@STARTDT", dtstart.ToString("yyyy-MM-dd"));
                p.SqlDbType = SqlDbType.DateTime;

                p = cmd.Parameters.AddWithValue("@ENDDT", Convert.ToDateTime(dtend).ToString("yyyy-MM-dd"));
                p.SqlDbType = SqlDbType.DateTime;

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                // Naturally, you already retrieved your objects so no deferred
                // loading needed nor posible, hence the ToList()
                return this.Translate<generatorSummary>(reader).ToList();
            }
        }

        public IEnumerable<PagesInRoles> GetPagesInRolesByIds(List<string> RoleIds)
        {
            DataTable RolesTable = new DataTable();
            RolesTable.Columns.Add("N", typeof(string));

            foreach (string e in RoleIds)
                RolesTable.Rows.Add(e);

            using (SqlConnection conn = new SqlConnection(Connection.ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("dbo.ed_IdentityRole_GetPagesByIds", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter p = cmd.Parameters.AddWithValue("@RoleIds", RolesTable);
                p.SqlDbType = SqlDbType.Structured;
                p.TypeName = "string_list_tbltype";

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                // Naturally, you already retrieved your objects so no deferred
                // loading needed nor posible, hence the ToList()
                return this.Translate<PagesInRoles>(reader).ToList();
            }
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.ed_GensetNote_GetByGensetId")]
        public ISingleResult<ed_GensetNote_GetByGensetIdResult> ed_GensetNote_GetByGensetId([global::System.Data.Linq.Mapping.ParameterAttribute(DbType = "Int")] System.Nullable<int> location)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), location);
            return ((ISingleResult<ed_GensetNote_GetByGensetIdResult>)(result.ReturnValue));
        }

        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.ed_GensetNote_GetById")]
        public ISingleResult<ed_GensetNote_GetByIdResult> ed_GensetNote_GetById([global::System.Data.Linq.Mapping.ParameterAttribute(DbType = "Int")] System.Nullable<int> Id)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), Id);
            return ((ISingleResult<ed_GensetNote_GetByIdResult>)(result.ReturnValue));
        }

        public class generatorSummary
        {
            private int _ID_LOCATION;

            private string _GENSETNAME;

            private System.Nullable<double> _HOURSRUN;

            private System.Nullable<double> _KWPRODUCED;

            private System.Nullable<int> _NOSTOPS;

            private System.Nullable<System.DateTime> _FIRSTSTART;

            private System.Nullable<System.DateTime> _LASTSTOP;


            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_ID_LOCATION", DbType = "Int NOT NULL")]
            public int ID_LOCATION
            {
                get
                {
                    return this._ID_LOCATION;
                }
                set
                {
                    if ((this._ID_LOCATION != value))
                    {
                        this._ID_LOCATION = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_GENSETNAME", DbType = "NVarChar(25) NOT NULL", CanBeNull = false)]
            public string GENSETNAME
            {
                get
                {
                    return this._GENSETNAME;
                }
                set
                {
                    if ((this._GENSETNAME != value))
                    {
                        this._GENSETNAME = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_HOURSRUN", DbType = "Float")]
            public System.Nullable<double> HOURSRUN
            {
                get
                {
                    return this._HOURSRUN;
                }
                set
                {

                    if ((this._HOURSRUN != value))
                    {
                        this._HOURSRUN = value;
                    }

                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_KWPRODUCED", DbType = "Float")]
            public System.Nullable<double> KWPRODUCED
            {
                get
                {
                    return this._KWPRODUCED;
                }
                set
                {

                    if ((this._KWPRODUCED != value))
                    {
                        this._KWPRODUCED = value;
                    }

                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_NOSTOPS", DbType = "Int")]
            public System.Nullable<int> NOSTOPS
            {
                get
                {
                    return this._NOSTOPS;
                }
                set
                {
                    if ((this._NOSTOPS != value))
                    {
                        this._NOSTOPS = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_FIRSTSTART", DbType = "DateTime")]
            public System.Nullable<System.DateTime> FIRSTSTART
            {
                get
                {
                    return this._FIRSTSTART;
                }
                set
                {
                    if ((this._FIRSTSTART != value))
                    {
                        this._FIRSTSTART = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_LASTSTOP", DbType = "DateTime")]
            public System.Nullable<System.DateTime> LASTSTOP
            {
                get
                {
                    return this._LASTSTOP;
                }
                set
                {
                    if ((this._LASTSTOP != value))
                    {
                        this._LASTSTOP = value;
                    }
                }
            }



        }
 
        public class PagesInRoles
        {
            private string _FilePageName;

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_FilePageName", DbType = "NVarChar(MAX) NOT NULL", CanBeNull = false)]
            public string FilePageName
            {
                get
                {
                    return this._FilePageName;
                }
                set
                {
                    if ((this._FilePageName != value))
                    {
                        this._FilePageName = value;
                    }
                }
            }
        }

        public partial class ed_GensetNote_GetByGensetIdResult
        {
            private int _Id;

            private string _UserId;

            private System.Nullable<System.DateTime> _CommentDate;

            private string _Comment;

            private System.Nullable<bool> _Flag;

            public ed_GensetNote_GetByGensetIdResult()
            {
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_Id", DbType = "Int")]
            public int Id
            {
                get
                {
                    return this._Id;
                }
                set
                {
                    if ((this._Id != value))
                    {
                        this._Id = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_UserId", DbType = "NVarChar(128) NOT NULL", CanBeNull = false)]
            public string UserId
            {
                get
                {
                    return this._UserId;
                }
                set
                {
                    if ((this._UserId != value))
                    {
                        this._UserId = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_CommentDate", DbType = "DateTime")]
            public System.Nullable<System.DateTime> CommentDate
            {
                get
                {
                    return this._CommentDate;
                }
                set
                {
                    if ((this._CommentDate != value))
                    {
                        this._CommentDate = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_Comment", DbType = "NVarChar(512)")]
            public string Comment
            {
                get
                {
                    return this._Comment;
                }
                set
                {
                    if ((this._Comment != value))
                    {
                        this._Comment = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_Flag", DbType = "Bit")]
            public System.Nullable<bool> Flag
            {
                get
                {
                    return this._Flag;
                }
                set
                {
                    if ((this._Flag != value))
                    {
                        this._Flag = value;
                    }
                }
            }
        }

        public partial class ed_GensetNote_GetByIdResult
        {
            private int _ID_Location;

            private string _UserId;

            private System.Nullable<System.DateTime> _CommentDate;

            private string _Comment;

            private System.Nullable<bool> _Flag;

            public ed_GensetNote_GetByIdResult()
            {
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_ID_Location", DbType = "Int")]
            public int ID_Location
            {
                get
                {
                    return this._ID_Location;
                }
                set
                {
                    if ((this._ID_Location != value))
                    {
                        this._ID_Location = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_UserId", DbType = "NVarChar(128) NOT NULL", CanBeNull = false)]
            public string UserId
            {
                get
                {
                    return this._UserId;
                }
                set
                {
                    if ((this._UserId != value))
                    {
                        this._UserId = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_CommentDate", DbType = "DateTime")]
            public System.Nullable<System.DateTime> CommentDate
            {
                get
                {
                    return this._CommentDate;
                }
                set
                {
                    if ((this._CommentDate != value))
                    {
                        this._CommentDate = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_Comment", DbType = "NVarChar(512)")]
            public string Comment
            {
                get
                {
                    return this._Comment;
                }
                set
                {
                    if ((this._Comment != value))
                    {
                        this._Comment = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_Flag", DbType = "Bit")]
            public System.Nullable<bool> Flag
            {
                get
                {
                    return this._Flag;
                }
                set
                {
                    if ((this._Flag != value))
                    {
                        this._Flag = value;
                    }
                }
            }
        }
    
    }

    public static class DataTableExtensions
    {
        public static void SetColumnsOrder(this DataTable table, params String[] columnNames)
        {
            int columnIndex = 0;
            foreach (var columnName in columnNames)
            {
                table.Columns[columnName].SetOrdinal(columnIndex);
                columnIndex++;
            }
        }
    }

}