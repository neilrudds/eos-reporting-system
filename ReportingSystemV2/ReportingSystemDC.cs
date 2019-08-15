using System.Data.Linq;
using System.Reflection;
namespace ReportingSystemV2
{
    partial class ReportingSystemDataContext
    {
        // Custom ed_EnergyMeters_GetColumnDifferenceByDays
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.ed_EnergyMeters_GetColumnDifferenceByDays")]
        public ISingleResult<ed_EnergyMeters_GetColumnDifferenceByDaysResult> ed_EnergyMeters_GetColumnDifferenceByDays([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ID_Location", DbType = "Int")] System.Nullable<int> iD_Location, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Modbus_Addr", DbType = "Int")] System.Nullable<int> modbus_Addr, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Start_Date", DbType = "DateTime")] System.Nullable<System.DateTime> start_Date, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "End_Date", DbType = "DateTime")] System.Nullable<System.DateTime> end_Date)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), iD_Location, modbus_Addr, start_Date, end_Date);
            return ((ISingleResult<ed_EnergyMeters_GetColumnDifferenceByDaysResult>)(result.ReturnValue));
        }

        public partial class ed_EnergyMeters_GetColumnDifferenceByDaysResult
        {

            private System.Nullable<double> _TotalEnergy;

            private string _TIME_STAMP;

            public ed_EnergyMeters_GetColumnDifferenceByDaysResult()
            {
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_TotalEnergy", DbType = "Float")]
            public System.Nullable<double> TotalEnergy
            {
                get
                {
                    return this._TotalEnergy;
                }
                set
                {
                    if ((this._TotalEnergy != value))
                    {
                        this._TotalEnergy = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_TIME_STAMP", DbType = "VarChar(30)")]
            public string TIME_STAMP
            {
                get
                {
                    return this._TIME_STAMP;
                }
                set
                {
                    if ((this._TIME_STAMP != value))
                    {
                        this._TIME_STAMP = value;
                    }
                }
            }
        }

        // Custom ed_EnergyMeters_GetGasDifferenceByDays
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.ed_EnergyMeters_GetGasDifferenceByDays")]
        public ISingleResult<ed_EnergyMeters_GetGasDifferenceByDaysResult> ed_EnergyMeters_GetGasDifferenceByDays([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ID_Location", DbType = "Int")] System.Nullable<int> iD_Location, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Modbus_Addr", DbType = "Int")] System.Nullable<int> modbus_Addr, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Start_Date", DbType = "DateTime")] System.Nullable<System.DateTime> start_Date, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "End_Date", DbType = "DateTime")] System.Nullable<System.DateTime> end_Date)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), iD_Location, modbus_Addr, start_Date, end_Date);
            return ((ISingleResult<ed_EnergyMeters_GetGasDifferenceByDaysResult>)(result.ReturnValue));
        }

        public partial class ed_EnergyMeters_GetGasDifferenceByDaysResult
        {

            private System.Nullable<double> _TotalVolume;

            private string _TIME_STAMP;

            public ed_EnergyMeters_GetGasDifferenceByDaysResult()
            {
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_TotalVolume", DbType = "Float")]
            public System.Nullable<double> TotalVolume
            {
                get
                {
                    return this._TotalVolume;
                }
                set
                {
                    if ((this._TotalVolume != value))
                    {
                        this._TotalVolume = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_TIME_STAMP", DbType = "VarChar(30)")]
            public string TIME_STAMP
            {
                get
                {
                    return this._TIME_STAMP;
                }
                set
                {
                    if ((this._TIME_STAMP != value))
                    {
                        this._TIME_STAMP = value;
                    }
                }
            }
        }

        // Custom get Difference of any ComAp column by Day
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.ed_Genset_GetColumnDifferenceByDays")]
        public ISingleResult<ed_Genset_GetColumnDifferenceByDaysResult> ed_Genset_GetColumnDifferenceByDays([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ID_Location", DbType = "Int")] System.Nullable<int> iD_Location, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Column_Name", DbType = "NVarChar(10)")] string column_Name, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Start_Date", DbType = "DateTime")] System.Nullable<System.DateTime> start_Date, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "End_Date", DbType = "DateTime")] System.Nullable<System.DateTime> end_Date)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), iD_Location, column_Name, start_Date, end_Date);
            return ((ISingleResult<ed_Genset_GetColumnDifferenceByDaysResult>)(result.ReturnValue));
        }

        public partial class ed_Genset_GetColumnDifferenceByDaysResult
        {

            private System.Nullable<double> _TotalEnergy;

            private string _TIME_STAMP;

            public ed_Genset_GetColumnDifferenceByDaysResult()
            {
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_TotalEnergy", DbType = "Float")]
            public System.Nullable<double> TotalEnergy
            {
                get
                {
                    return this._TotalEnergy;
                }
                set
                {
                    if ((this._TotalEnergy != value))
                    {
                        this._TotalEnergy = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_TIME_STAMP", DbType = "VarChar(30)")]
            public string TIME_STAMP
            {
                get
                {
                    return this._TIME_STAMP;
                }
                set
                {
                    if ((this._TIME_STAMP != value))
                    {
                        this._TIME_STAMP = value;
                    }
                }
            }
        }

        // Custom get Difference of any ComAp column by Hour
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.ed_Genset_GetColumnDifferenceByHoursofDays")]
        public ISingleResult<ed_Genset_GetColumnDifferenceByHoursofDaysResult> ed_Genset_GetColumnDifferenceByHoursofDays([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ID_Location", DbType = "Int")] System.Nullable<int> iD_Location, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Column_Name", DbType = "NVarChar(10)")] string column_Name, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Start_Date", DbType = "DateTime")] System.Nullable<System.DateTime> start_Date, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "End_Date", DbType = "DateTime")] System.Nullable<System.DateTime> end_Date)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), iD_Location, column_Name, start_Date, end_Date);
            return ((ISingleResult<ed_Genset_GetColumnDifferenceByHoursofDaysResult>)(result.ReturnValue));
        }

        public partial class ed_Genset_GetColumnDifferenceByHoursofDaysResult
        {

            private System.Nullable<double> _TotalEnergy;

            private int _HR;

            private int _DY;

            private int _MTH;

            private int _YR;

            public ed_Genset_GetColumnDifferenceByHoursofDaysResult()
            {
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_TotalEnergy", DbType = "Float")]
            public System.Nullable<double> TotalEnergy
            {
                get
                {
                    return this._TotalEnergy;
                }
                set
                {
                    if ((this._TotalEnergy != value))
                    {
                        this._TotalEnergy = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_HR", DbType = "int")]
            public int HR
            {
                get
                {
                    return this._HR;
                }
                set
                {
                    if ((this._HR != value))
                    {
                        this._HR = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_DY", DbType = "int")]
            public int DY
            {
                get
                {
                    return this._DY;
                }
                set
                {
                    if ((this._DY != value))
                    {
                        this._DY = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_MTH", DbType = "int")]
            public int MTH
            {
                get
                {
                    return this._MTH;
                }
                set
                {
                    if ((this._MTH != value))
                    {
                        this._MTH = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_YR", DbType = "int")]
            public int YR
            {
                get
                {
                    return this._YR;
                }
                set
                {
                    if ((this._YR != value))
                    {
                        this._YR = value;
                    }
                }
            }
        }

        // Custom get Difference of any ComAp column by Month
        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.ed_Genset_GetColumnDifferenceByMonthsOfYear")]
        public ISingleResult<ed_Genset_GetColumnDifferenceByMonthsOfYearResult> ed_Genset_GetColumnDifferenceByMonthsOfYear([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ID_Location", DbType = "Int")] System.Nullable<int> iD_Location, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Column_Name", DbType = "NVarChar(10)")] string column_Name, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Start_Date", DbType = "DateTime")] System.Nullable<System.DateTime> start_Date, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "End_Date", DbType = "DateTime")] System.Nullable<System.DateTime> end_Date)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), iD_Location, column_Name, start_Date, end_Date);
            return ((ISingleResult<ed_Genset_GetColumnDifferenceByMonthsOfYearResult>)(result.ReturnValue));
        }

        public partial class ed_Genset_GetColumnDifferenceByMonthsOfYearResult
        {

            private System.Nullable<double> _TotalEnergy;

            private int _MTH;

            private int _YR;

            public ed_Genset_GetColumnDifferenceByMonthsOfYearResult()
            {
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_TotalEnergy", DbType = "Float")]
            public System.Nullable<double> TotalEnergy
            {
                get
                {
                    return this._TotalEnergy;
                }
                set
                {
                    if ((this._TotalEnergy != value))
                    {
                        this._TotalEnergy = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_MTH", DbType = "int")]
            public int MTH
            {
                get
                {
                    return this._MTH;
                }
                set
                {
                    if ((this._MTH != value))
                    {
                        this._MTH = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_YR", DbType = "int")]
            public int YR
            {
                get
                {
                    return this._YR;
                }
                set
                {
                    if ((this._YR != value))
                    {
                        this._YR = value;
                    }
                }
            }
        }


        [global::System.Data.Linq.Mapping.FunctionAttribute(Name = "dbo.ed_Genset_GetColumnOverTimePlot")]
        public ISingleResult<ed_Genset_GetColumnOverTimePlotResult> ed_Genset_GetColumnOverTimePlot([global::System.Data.Linq.Mapping.ParameterAttribute(Name = "ID_Location", DbType = "Int")] System.Nullable<int> iD_Location, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Column_Name", DbType = "NVarChar(10)")] string column_Name, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "Start_Date", DbType = "DateTime")] System.Nullable<System.DateTime> start_Date, [global::System.Data.Linq.Mapping.ParameterAttribute(Name = "End_Date", DbType = "DateTime")] System.Nullable<System.DateTime> end_Date)
        {
            IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), iD_Location, column_Name, start_Date, end_Date);
            return ((ISingleResult<ed_Genset_GetColumnOverTimePlotResult>)(result.ReturnValue));
        }

        public partial class ed_Genset_GetColumnOverTimePlotResult
        {

            private string _Data;

            private System.Nullable<System.DateTime> _Time_stamp;

            public ed_Genset_GetColumnOverTimePlotResult()
            {
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_Data", DbType = "NVarChar(50)")]
            public string Data
            {
                get
                {
                    return this._Data;
                }
                set
                {
                    if ((this._Data != value))
                    {
                        this._Data = value;
                    }
                }
            }

            [global::System.Data.Linq.Mapping.ColumnAttribute(Storage = "_Time_stamp", DbType = "DateTime")]
            public System.Nullable<System.DateTime> Time_stamp
            {
                get
                {
                    return this._Time_stamp;
                }
                set
                {
                    if ((this._Time_stamp != value))
                    {
                        this._Time_stamp = value;
                    }
                }
            }
        }
    }
}
