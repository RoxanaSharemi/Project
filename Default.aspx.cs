using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Subgurim.Controles;
using Subgurim.Controles.GoogleChartIconMaker;
using System.Drawing;
using System.Data.SqlClient;

public partial class _Default : System.Web.UI.Page
{
        protected void Page_Load(object sender, EventArgs e)
    {
    }
        protected void Button1_Click(object sender, EventArgs e)
        {
            Random rnd = new Random();
            Type cstype = this.GetType();
            ClientScriptManager cs = Page.ClientScript;
            try
            {
                string[] userName = SendUserName.Value.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries);
                string[] fireStationName = SendFireStationName.Value.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries);
                string[] time = SendTime.Value.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries);
                string[] distance = SendDistance.Value.Split(new[] { ";","km" }, StringSplitOptions.RemoveEmptyEntries);
                string[] fireStationAddress = SendFireStationAddress.Value.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries);
                string[] userAddress = SendUserAddress.Value.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries);
                
                for (int i = 0; i < time.Length; i++)
                {
                    SqlConnection sqlc = new SqlConnection("YOUR SQL Connection");
                    SqlCommand cmd = new SqlCommand("INSERT INTO [dbo].[TBL_SCHEDULE_SHIRAZ]([USER_NAME],[FIRESTATION_NAME],[TIME],[COST],[QUALITY],[USER_ADDRESS],[FIRESTATION_ADDRESS],[DISTANCE]) VALUES ('" +
                                                    userName[i] + "','" + fireStationName[i] + "'," + time[i] + "," + rnd.Next(1, 100) + "," + rnd.Next(1, 100) + ",'" + userAddress[i] + "','" + fireStationAddress[i] +
                                                    "','" +Convert.ToDouble(distance[i]) + "')", sqlc);
                    sqlc.Open();
                    cmd.ExecuteNonQuery();
                    sqlc.Close();
                }

                if (!cs.IsStartupScriptRegistered(cstype, "PopupScript"))
                {
                    String cstext = "alert('اطلاعات با موفقیت ثبت شد');";
                    cs.RegisterStartupScript(cstype, "PopupScript", cstext, true);
                }
                SendUserName.Value = SendFireStationName.Value = SendTime.Value = SendDistance.Value = SendFireStationAddress.Value = SendUserAddress.Value = null;
            }
            catch
            {
                String cstext = "alert('مشکل در ذخیره اطلاعات');";
                cs.RegisterStartupScript(cstype, "PopupScript", cstext, true);
            }
        }
}