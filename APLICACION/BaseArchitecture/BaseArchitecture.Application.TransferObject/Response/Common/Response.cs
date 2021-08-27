using System;

namespace BaseArchitecture.Application.TransferObject.Response.Common
{
    public class Response<T>
    {
        public Response()
        {
        }

        public Response(bool status)
        {
            Status = status;
        }

        public Response(T value, int state, string message)
        {
            Value = value;
            State = state;
            Message = message;
        }

        public Response(T value)
        {
            Value = value;
        }

        public Response(bool status, T value) : this(status)
        {
            Value = value;
        }

        public Response(bool status, T value, string message) : this(status)
        {
            Value = value;
            Message = message;
        }

        public Response(bool status, T value, string message, int state) : this(status)
        {
            Value = value;
            Message = message;
            State = state;
        }

        public bool Status { get; set; } = true;
        public int State { get; set; } = 200;
        public string Message { get; set; } = "Ok";
        public T Value { set; get; }
        public ResultResponse ResultResponse { set; get; }

        public static implicit operator Response<T>(bool v)
        {
            throw new NotImplementedException();
        }
    }
}