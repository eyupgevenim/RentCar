using System;
using System.Data;
using System.Data.Common;

namespace RentCar.Core.Helpers
{
    public sealed class DBHelper : IDisposable
    {
        private DbTransaction transaction;
        private readonly DbConnection connection;
        
        public DBHelper(DbConnection connection)
        {
            this.connection = connection;
        }
        
        public bool OpenConnection(bool throwException = true)
        {
            try
            {
                if (connection.State == ConnectionState.Closed)
                {
                    connection.Open();
                }
                return true;
            }
            catch (Exception ex)
            {
                if (throwException)
                    throw ex;
                else
                    return false;
            }
        }
        
        public void CloseConnection()
        {
            if (connection != null)
            {
                try
                {
                    try
                    {
                        transaction?.Rollback();
                        transaction = null;
                    }
                    finally
                    {
                        if (connection.State != ConnectionState.Closed)
                            connection.Close();
                    }
                }
                catch
                {
                    //to do
                }
            }

            transaction = null;
        }

        public void BeginTransaction()
        {
            OpenConnection();
            transaction = connection.BeginTransaction();
        }

        public bool IsInTransaction
        {
            get { return transaction != null; }
        }

        public void CommitTransaction()
        {
            transaction?.Commit();
            transaction = null;
        }

        public void RollbackTransaction()
        {
            transaction?.Rollback();
            transaction = null;
        }

        public void InParameter(DbCommand cmd, string ParameterName, DbType type, object Value)
        {
            Parameter(cmd, ParameterName, ParameterDirection.Input, type, Value);
        }

        public void IntegerParameter(DbCommand cmd, string ParameterName, int? Value)
        {
            DbParameter param = cmd.CreateParameter();
            param.Direction = ParameterDirection.Input;
            param.DbType = DbType.Int32;
            if (Value != null) param.Value = Value;
            else param.Value = System.DBNull.Value;
            param.ParameterName = ParameterName;
            cmd.Parameters.Add(param);
        }

        public void Int64Parameter(DbCommand cmd, string ParameterName, Int64? Value)
        {
            DbParameter param = cmd.CreateParameter();
            param.Direction = ParameterDirection.Input;
            param.DbType = DbType.Int64;
            if (Value != null) param.Value = Value;
            else param.Value = System.DBNull.Value;
            param.ParameterName = ParameterName;
            cmd.Parameters.Add(param);
        }

        public void DoubleParameter(DbCommand cmd, string ParameterName, double? Value)
        {
            DbParameter param = cmd.CreateParameter();
            param.Direction = ParameterDirection.Input;
            param.DbType = DbType.Double;
            if (Value != null) param.Value = Value;
            else param.Value = System.DBNull.Value;
            param.ParameterName = ParameterName;
            cmd.Parameters.Add(param);
        }

        public void DateParameter(DbCommand cmd, string ParameterName, DateTime? Value)
        {
            DbParameter param = cmd.CreateParameter();
            param.Direction = ParameterDirection.Input;
            param.DbType = DbType.DateTime;
            if (Value != null) param.Value = Value;
            else param.Value = System.DBNull.Value;
            param.ParameterName = ParameterName;
            cmd.Parameters.Add(param);
        }

        public void BooleanParameter(DbCommand cmd, string ParameterName, Boolean? Value)
        {
            DbParameter param = cmd.CreateParameter();
            param.Direction = ParameterDirection.Input;
            param.DbType = DbType.Boolean;
            if (Value != null) param.Value = Value;
            else param.Value = System.DBNull.Value;
            param.ParameterName = ParameterName;
            cmd.Parameters.Add(param);
        }
        
        public void StringParameter(DbCommand cmd, string ParameterName, ParameterDirection Direction, string Value)
        {
            DbParameter param = cmd.CreateParameter();
            param.Direction = Direction;
            param.DbType = DbType.String;
            param.ParameterName = ParameterName;
            if (Value != null)
            {
                param.Value = Value;
                param.Size = Value.Length;
            }
            else
            {
                param.Value = System.DBNull.Value;
            }
            //output olanlarda param size maxvalue olsun
            if (Direction != ParameterDirection.Input)
            {
                param.Size = Int32.MaxValue;
            }
            cmd.Parameters.Add(param);
        }

        public void StringParameter(DbCommand cmd, string ParameterName, string Value)
        {
            DbParameter param = cmd.CreateParameter();
            param.Direction = ParameterDirection.Input;
            param.DbType = DbType.String;
            param.ParameterName = ParameterName;
            if (Value != null)
            {
                param.Value = Value;
                param.Size = Value.Length;
            }
            else param.Value = System.DBNull.Value;
            cmd.Parameters.Add(param);
        }

        private void Parameter(DbCommand cmd, string ParameterName, ParameterDirection Direction, DbType type, object Value)
        {
            DbParameter param = cmd.CreateParameter();
            param.Direction = Direction;
            param.DbType = type;
            param.ParameterName = ParameterName;
            param.Value = Value ?? DBNull.Value;
            cmd.Parameters.Add(param);
        }

        private void Parameter(DbCommand cmd, string ParameterName, ParameterDirection Direction, DbType type, int size, object Value)
        {
            DbParameter param = cmd.CreateParameter();
            param.Direction = Direction;
            param.DbType = type;
            param.ParameterName = ParameterName;
            param.Size = size;
            param.Value = Value ?? DBNull.Value;
            cmd.Parameters.Add(param);
        }

        public void DateOutParameter(DbCommand cmd, string ParameterName)
        {
            OutParameter(cmd, ParameterName, DbType.DateTime);
        }

        public void IntegerOutParameter(DbCommand cmd, string ParameterName)
        {
            OutParameter(cmd, ParameterName, DbType.Int32);
        }

        public void DoubleOutParameter(DbCommand cmd, string ParameterName)
        {
            OutParameter(cmd, ParameterName, DbType.Double);
        }

        public void BooleanOutParameter(DbCommand cmd, string ParameterName)
        {
            OutParameter(cmd, ParameterName, DbType.Boolean);
        }

        public void OutParameter(DbCommand cmd, string ParameterName, DbType type)
        {
            Parameter(cmd, ParameterName, ParameterDirection.Output, type, DBNull.Value);

        }

        public void OutParameter(DbCommand cmd, string ParameterName, DbType type, int Size)
        {
            Parameter(cmd, ParameterName, ParameterDirection.Output, type, Size, DBNull.Value);

        }

        public void InOutParameter(DbCommand cmd, string ParameterName, DbType type, object Value)
        {
            Parameter(cmd, ParameterName, ParameterDirection.InputOutput, type, Value);
        }

        public void InReturnParameter(DbCommand cmd, string ParameterName, DbType type)
        {
            Parameter(cmd, ParameterName, ParameterDirection.ReturnValue, type, DBNull.Value);
        }
        
        public DbCommand CreateCommandStoredProcedure(string sSQL)
        {
            DbCommand cmd = connection.CreateCommand();
            cmd.CommandText = sSQL;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Transaction = transaction;
            return cmd;
        }
        
        public void Dispose()
        {
            CloseConnection();
        }
    }
}
