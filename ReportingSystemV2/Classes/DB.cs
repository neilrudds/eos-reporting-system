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

        public class GeneratorContentHistory
        {
            public System.DateTime Date { get; set; }

            public string Generator { get; set; }

            public string Reason { get; set; }

            public string Event { get; set; }

            public System.Nullable<short> RPM { get; set; }

            public System.Nullable<short> Pwr { get; set; }

            public System.Nullable<double> PF { get; set; }

            public System.Nullable<double> Gfrq { get; set; }

            public System.Nullable<short> Vg1 { get; set; }

            public System.Nullable<short> Vg2 { get; set; }

            public System.Nullable<short> Vg3 { get; set; }

            public System.Nullable<short> Vg12 { get; set; }

            public System.Nullable<short> Vg23 { get; set; }

            public System.Nullable<short> Vg31 { get; set; }

            public System.Nullable<short> Ig1 { get; set; }

            public System.Nullable<short> Ig2 { get; set; }

            public System.Nullable<short> Ig3 { get; set; }

            public System.Nullable<double> Mfrq { get; set; }

            public System.Nullable<short> Vm1 { get; set; }

            public System.Nullable<short> Vm2 { get; set; }

            public System.Nullable<short> Vm3 { get; set; }

            public System.Nullable<short> Vm12 { get; set; }

            public System.Nullable<short> Vm23 { get; set; }

            public System.Nullable<short> Vm31 { get; set; }

            public System.Nullable<double> MPF { get; set; }

            public System.Nullable<double> SRO { get; set; }

            public System.Nullable<double> VRO { get; set; }

            public string Mode { get; set; }

            public System.Nullable<int> kWhour { get; set; }

            public System.Nullable<int> Runhrs { get; set; }

            public System.Nullable<short> ActPwr { get; set; }

            public System.Nullable<short> ActDem { get; set; }

            public System.Nullable<short> CylA1 { get; set; }

            public System.Nullable<short> CylA2 { get; set; }

            public System.Nullable<short> CylA3 { get; set; }

            public System.Nullable<short> CylA4 { get; set; }

            public System.Nullable<short> CylA5 { get; set; }

            public System.Nullable<short> CylA6 { get; set; }

            public System.Nullable<short> CylA7 { get; set; }

            public System.Nullable<short> CylA8 { get; set; }

            public System.Nullable<short> CylA9 { get; set; }

            public System.Nullable<short> CylA10 { get; set; }

            public System.Nullable<short> CylB1 { get; set; }

            public System.Nullable<short> CylB2 { get; set; }

            public System.Nullable<short> CylB3 { get; set; }

            public System.Nullable<short> CylB4 { get; set; }

            public System.Nullable<short> CylB5 { get; set; }

            public System.Nullable<short> CylB6 { get; set; }

            public System.Nullable<short> CylB7 { get; set; }

            public System.Nullable<short> CylB8 { get; set; }

            public System.Nullable<short> CylB9 { get; set; }

            public System.Nullable<short> CylB10 { get; set; }

            public string BIN { get; set; }

            public string BOUT { get; set; }

            public System.Nullable<double> MVS { get; set; }

            public System.Nullable<short> ActPwrReq { get; set; }

            public System.Nullable<double> Ubat { get; set; }

            public System.Nullable<double> CPUT { get; set; }

            public System.Nullable<double> TEMv { get; set; }

            public System.Nullable<char> LChr { get; set; }

            public System.Nullable<double> OilB4F { get; set; }

            public System.Nullable<double> OilLev { get; set; }

            public System.Nullable<double> OilT { get; set; }

            public System.Nullable<double> CCPres { get; set; }

            public System.Nullable<double> AirInT { get; set; }

            public System.Nullable<double> RecAT { get; set; }

            public System.Nullable<double> ThrPos { get; set; }

            public System.Nullable<double> CH4 { get; set; }

            public System.Nullable<double> JWTin { get; set; }

            public System.Nullable<double> JWTout { get; set; }

            public System.Nullable<short> Numstr { get; set; }

            public string BI1 { get; set; }

            public string BI2 { get; set; }

            public string BI3 { get; set; }

            public string BI4 { get; set; }

            public string BI5 { get; set; }

            public string BI6 { get; set; }

            public string BI7 { get; set; }

            public string BI8 { get; set; }

            public string BI9 { get; set; }

            public string BI10 { get; set; }

            public string BI11 { get; set; }

            public string BI12 { get; set; }

            public string BO1 { get; set; }

            public string BO2 { get; set; }

            public string BO3 { get; set; }

            public string BO4 { get; set; }

            public string BO5 { get; set; }

            public System.Nullable<short> Pmns { get; set; }

            public System.Nullable<short> Qmns { get; set; }

            public System.Nullable<short> ActPfi { get; set; }

            public System.Nullable<char> MLChr { get; set; }

            public System.Nullable<double> Amb { get; set; }

            public System.Nullable<int> kVarho { get; set; }

            public System.Nullable<double> GasP { get; set; }

            public System.Nullable<double> LTHWfT { get; set; }

            public System.Nullable<double> LTHWrT { get; set; }

            public System.Nullable<double> GFlwRte { get; set; }

            public System.Nullable<int> GFlwM3 { get; set; }

            public System.Nullable<short> H2S { get; set; }

            public System.Nullable<short> NumUns { get; set; }

            public System.Nullable<short> PwrDem { get; set; }

            public System.Nullable<double> JWGKin { get; set; }

            public System.Nullable<double> HWFlo { get; set; }

            public System.Nullable<double> HWRtn { get; set; }

            public System.Nullable<int> GasMet { get; set; }

            public System.Nullable<short> IcOut { get; set; }

            public System.Nullable<short> ImpLoad { get; set; }

            public System.Nullable<double> Q { get; set; }

            public System.Nullable<double> U { get; set; }

            public System.Nullable<double> V { get; set; }

            public System.Nullable<double> W { get; set; }

            public System.Nullable<int> Grokwh { get; set; }

            public System.Nullable<int> Auxkwh { get; set; }

            public System.Nullable<int> TotRunPact { get; set; }

            public System.Nullable<int> TotRunPnomAll { get; set; }

            public System.Nullable<int> SumMWh { get; set; }

            public string Extended { get; set; }

        }

        #region History Data

        public Tuple<IEnumerable<GeneratorContentHistory>, int> SelectComApQuery(int IdLocation, DateTime startDate, DateTime endDate)
        {
            //var result = RsDc.ed_Genset_GetHistoryById_GeneratorContent(IdLocation, startDate.Date, endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)).ToList();

            var result = (from t1 in RsDc.GeneratorContents
                          join t2 in RsDc.HL_Locations on t1.IdLocation equals t2.ID
                          join t3 in RsDc.HL_Events on t1.IdEvent equals t3.ID
            where t1.IdLocation == IdLocation && t1.TimeStamp > startDate.Date && t1.TimeStamp <= endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)
            orderby t1.TimeStamp descending
            select new GeneratorContentHistory
            {
                Date = t1.TimeStamp,
                Generator = t2.GENSETNAME,
                Reason = t3.REASON,
                Event = t1.Event,
                RPM = t1.RPM,
                Pwr = t1.Pwr,
                PF = t1.PF,
                Gfrq = t1.Gfrq,
                Vg1 = t1.Vg1,
                Vg2 = t1.Vg2,
                Vg3 = t1.Vg3,
                Vg12 = t1.Vg12,
                Vg23 = t1.Vg23,
                Vg31 = t1.Vg31,
                Ig1 = t1.Ig1,
                Ig2 = t1.Ig2,
                Ig3 = t1.Ig3,
                Mfrq = t1.Mfrq,
                Vm1 = t1.Vm1,
                Vm2 = t1.Vm2,
                Vm3 = t1.Vm3,
                Vm12 = t1.Vm12,
                Vm23 = t1.Vm23,
                Vm31 = t1.Vm31,
                MPF = t1.MPF,
                SRO = t1.SRO,
                VRO = t1.VRO,
                Mode = t1.Mode,
                kWhour = t1.kWhour,
                Runhrs = t1.Runhrs,
                ActPwr = t1.ActPwr,
                ActDem = t1.ActDem,
                CylA1 = t1.CylA1,
                CylA2 = t1.CylA2,
                CylA3 = t1.CylA3,
                CylA4 = t1.CylA4,
                CylA5 = t1.CylA5,
                CylA6 = t1.CylA6,
                CylA7 = t1.CylA7,
                CylA8 = t1.CylA8,
                CylA9 = t1.CylA9,
                CylA10 = t1.CylA10,
                CylB1 = t1.CylB1,
                CylB2 = t1.CylB2,
                CylB3 = t1.CylB3,
                CylB4 = t1.CylB4,
                CylB5 = t1.CylB5,
                CylB6 = t1.CylB6,
                CylB7 = t1.CylB7,
                CylB8 = t1.CylB8,
                CylB9 = t1.CylB9,
                CylB10 = t1.CylB10,
                BIN = t1.BIN,
                BOUT = t1.BOUT,
                MVS = t1.MVS,
                ActPwrReq = t1.ActPwrReq,
                Ubat = t1.Ubat,
                CPUT = t1.CPUT,
                TEMv = t1.TEMv,
                LChr = t1.LChr,
                OilB4F = t1.OilB4F,
                OilLev = t1.OilLev,
                OilT = t1.OilT,
                CCPres = t1.CCPres,
                AirInT = t1.AirInT,
                RecAT = t1.RecAT,
                ThrPos = t1.ThrPos,
                CH4 = t1.CH4,
                JWTin = t1.JWTin,
                JWTout = t1.JWTout,
                Numstr = t1.Numstr,
                BI1 = t1.BI1,
                BI2 = t1.BI2,
                BI3 = t1.BI3,
                BI4 = t1.BI4,
                BI5 = t1.BI5,
                BI6 = t1.BI6,
                BI7 = t1.BI7,
                BI8 = t1.BI8,
                BI9 = t1.BI9,
                BI10 = t1.BI10,
                BI11 = t1.BI11,
                BI12 = t1.BI12,
                BO1 = t1.BO1,
                BO2 = t1.BO2,
                BO3 = t1.BO3,
                BO4 = t1.BO4,
                BO5 = t1.BO5,
                Pmns = t1.Pmns,
                Qmns = t1.Qmns,
                ActPfi = t1.ActPfi,
                MLChr = t1.MLChr,
                Amb = t1.Amb,
                kVarho = t1.kVarho,
                GasP = t1.GasP,
                LTHWfT = t1.LTHWfT,
                LTHWrT = t1.LTHWrT,
                GFlwRte = t1.GFlwRte,
                GFlwM3 = t1.GFlwM3,
                H2S = t1.H2S,
                NumUns = t1.NumUns,
                PwrDem = t1.PwrDem,
                JWGKin = t1.JWGKin,
                HWFlo = t1.HWFlo,
                HWRtn = t1.HWRtn,
                GasMet = t1.GasMet,
                IcOut = t1.IcOut,
                ImpLoad = t1.ImpLoad,
                Q = t1.Q,
                U = t1.U,
                V = t1.V,
                W = t1.W,
                Grokwh = t1.Grokwh,
                Auxkwh = t1.Auxkwh,
                TotRunPact = t1.TotRunPact,
                TotRunPnomAll = t1.TotRunPnomAll,
                SumMWh = t1.SumMWh,
                Extended = t1.Extended
            }).ToList();

            return Tuple.Create(result.AsEnumerable(), result.Count());
        }

        public Tuple<IEnumerable<DirisA20>, int> SelectDirisA20Query(string serial, DateTime startDate, DateTime endDate)
        {
            var query = (from m in RsDc.DirisA20s
                        where m.Serial == serial && m.TimeStamp > startDate.Date && m.TimeStamp <= endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)
                        orderby m.TimeStamp descending
                        select m).ToList();

            int count = query.Count();

            return Tuple.Create(query.AsEnumerable(), count);
        }

        public Tuple<IEnumerable<E650>, int> SelectLgE650Query(string serial, DateTime startDate, DateTime endDate)
        {
            var query = (from m in RsDc.E650s
                        where m.Serial == serial && m.TimeStamp > startDate.Date && m.TimeStamp <= endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)
                        orderby m.TimeStamp descending
                        select m).ToList();

            int count = query.Count();

            return Tuple.Create(query.AsEnumerable(), count);
        }

        public Tuple<IEnumerable<Heat>, int> SelectRH33Query(int IdLocation, int IdMeter, DateTime startDate, DateTime endDate)
        {
            var query = (from m in RsDc.Heats
                        where m.IdLocation == IdLocation && m.IdMeter == IdMeter && m.TimeStamp > startDate.Date && m.TimeStamp <= endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)
                        orderby m.TimeStamp descending
                        select m).ToList();

            int count = query.Count();

            return Tuple.Create(query.AsEnumerable(), count);
        }

        public Tuple<IEnumerable<Steam>, int> SelectEHSteamQuery(int IdLocation, int IdMeter, DateTime startDate, DateTime endDate)
        {
            var query = (from m in RsDc.Steams
                         where m.IdLocation == IdLocation && m.IdMeter == IdMeter
                         && m.TimeStamp > startDate.Date && m.TimeStamp <= endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)
                         orderby m.TimeStamp descending
                         select m).ToList();


            int count = query.Count();

            return Tuple.Create(query.AsEnumerable(), count);
        }

        public Tuple<IEnumerable<Gas>, int> SelectEHGasQuery(int IdLocation, int IdMeter, DateTime startDate, DateTime endDate)
        {
            var query = (from m in RsDc.Gas
                         where m.IdLocation == IdLocation && m.IdMeter == IdMeter 
                         && m.TimeStamp > startDate.Date && m.TimeStamp <= endDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59)
                         orderby m.TimeStamp descending
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

            var result = (
            from a in db.GeneratorContents
            where a.TimeStamp > DateTime.Now.AddDays(-1)
            select new
            {
                a.IdLocation,
                a.Runhrs
            });

            dt.Columns.Add("Genset Name");
            dt.Columns.Add("Run Hours");

            foreach (var item in result)
            {
                DataRow row = dt.NewRow();
                row["Genset Name"] = item.IdLocation;
                row["Run Hours"] = result.Max(x => x.Runhrs) - result.Min(x => x.Runhrs);
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
                             Id = s.Id,
                             Timestamp = s.TimeStamp,
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
                             Id = s.Id,
                             Timestamp = s.TimeStamp,
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
                             Id = s.Id,
                             Timestamp = s.TimeStamp,
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

        public decimal GetActualHoursRun(int IdLocation, DateTime startDate, DateTime endDate)
        {
            var x = (from row in RsDc.GeneratorContents
                     where row.IdLocation == IdLocation && row.TimeStamp >= startDate && row.TimeStamp < endDate.AddHours(23).AddMinutes(59).AddSeconds(59)
                     select new { TimeStamp = row.TimeStamp, Runhrs = row.Runhrs }).AsEnumerable();

            var Max = x.Max(p => p.Runhrs);
            var Min = x.Min(p => p.Runhrs);

            return x != null ? Convert.ToDecimal(Max - Min) : 0;
        }

        public decimal GetActualkWhProduced(int IdLocation, DateTime startDate, DateTime endDate)
        {
            var x = (from row in RsDc.GeneratorContents
                     where row.IdLocation == IdLocation && row.TimeStamp >= startDate && row.TimeStamp < endDate.AddHours(23).AddMinutes(59).AddSeconds(59)
                     select new { TimeStamp = row.TimeStamp, kWhours = row.kWhour }).AsEnumerable();

            var Max = x.Max(p => p.kWhours);
            var Min = x.Min(p => p.kWhours);

            return x != null ? Convert.ToDecimal(Max - Min) : 0;
        }

        //public decimal GetTotalHoursRun(int IdLocation, DateTime startDate, DateTime? endDate = null)
        //{
        //    endDate = endDate != null ? endDate.Value.AddHours(23).AddMinutes(59).AddSeconds(59) : DateTime.Now;

        //    var x = (from row in RsDc.GeneratorContents
        //             where row.IdLocation == IdLocation && row.TimeStamp >= startDate && row.TimeStamp < endDate
        //             group row by true into r
        //             select new { Runhrs = r.Max(z => z.Runhrs) }).FirstOrDefault();

        //    return Convert.ToDecimal(x != null ? x.Runhrs : 0);
        //}

        //public decimal GetTotalkWhProduced(int IdLocation, DateTime startDate, DateTime? endDate = null)
        //{
        //    endDate = endDate != null ? endDate.Value.AddHours(23).AddMinutes(59).AddSeconds(59) : DateTime.Now;

        //    var x = (from row in RsDc.GeneratorContents
        //             where row.IdLocation == IdLocation && row.TimeStamp >= startDate && row.TimeStamp < endDate
        //             group row by true into r
        //             select new { kWhour = r.Max(z => z.kWhour) }).FirstOrDefault();

        //    return Convert.ToDecimal(x != null ? x.kWhour : 0);
        //}

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
                SqlCommand cmd = new SqlCommand("dbo.ed_Genset_GetSummaryByUserGensetIds_GeneratorContent", conn);
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
            private int _IdLocation;

            private string _GENSETNAME;

            private System.Nullable<double> _HOURSRUN;

            private System.Nullable<double> _KWPRODUCED;

            private System.Nullable<int> _NOSTOPS;

            private System.Nullable<System.DateTime> _FIRSTSTART;

            private System.Nullable<System.DateTime> _LASTSTOP;


            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_IdLocation", DbType = "Int NOT NULL")]
            public int IdLocation
            {
                get
                {
                    return this._IdLocation;
                }
                set
                {
                    if ((this._IdLocation != value))
                    {
                        this._IdLocation = value;
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