package com.example.laspa_ok

import android.content.Intent
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.example.native";

    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        channel.setMethodCallHandler { call, result ->
            var sendName = "Good o";
            var argument = call.arguments() as Map<String, String>

            var PlateNumber = argument["PlateNumber"];
            var ParkingAreaName = argument["ParkingAreaName"];
            var ParkingSpotName = argument["ParkingSpotName"];
            var Amount = argument["Amount"];
            var ParkingTime = argument["ParkingTime"];
            var ExpiringTime = argument["ExpiringTime"];
            var qrcode = argument["qrcode"];

            if (call.method == "showtoast") {

               //Toast.makeText(this, firstname, Toast.LENGTH_LONG).show()
//                val admindIntent = Intent(this, fourth::class.java)
//                startActivity(admindIntent)
//    var result = "Yes good"
//                Toast.makeText(this, result, Toast.LENGTH_LONG).show()

                val admindIntent = Intent(this, third::class.java)

                admindIntent.putExtra("PlateNumber",PlateNumber)
                admindIntent.putExtra("ParkingAreaName",ParkingAreaName)
                admindIntent.putExtra("ParkingSpotName",ParkingSpotName)
                admindIntent.putExtra("Amount",Amount)
                admindIntent.putExtra("ParkingTime",ParkingTime)
                admindIntent.putExtra("ExpiringTime",ExpiringTime)
                admindIntent.putExtra("qrcode",qrcode)
                startActivity(admindIntent)

//                val saleIntent = Intent(this, TransactionActivity::class.java)
//                val saleBundle = Bundle()
//                saleBundle.putString("TRAN_TYPE", "SALE")
//                saleIntent.putExtras(saleBundle)
//                startActivity(saleIntent)


            }


            if (call.method == "OnlinePayment") {

                var argument = call.arguments() as Map<String, String>
                var Amount = argument["Amount"];


                //Toast.makeText(this, Amount, Toast.LENGTH_LONG).show()
                val adminIntent = Intent(this, SetupTerminalActivity::class.java)
                startActivity(adminIntent)

            }

            if (call.method == "CardPayment") {
                var ParkingID = argument["ParkingID"];



                val admindIntent = Intent(this, TransactionActivity::class.java)
                admindIntent.putExtra("TRAN_TYPE","SALE")
                admindIntent.putExtra("PlateNumber",PlateNumber)
                admindIntent.putExtra("ParkingAreaName",ParkingAreaName)
                admindIntent.putExtra("ParkingSpotName",ParkingSpotName)
                admindIntent.putExtra("Amount",Amount)
                admindIntent.putExtra("ParkingTime",ParkingTime)
                admindIntent.putExtra("ExpiringTime",ExpiringTime)
                admindIntent.putExtra("qrcode",qrcode)
                admindIntent.putExtra("ParkingID",ParkingID)

                println (PlateNumber)
                println (ParkingAreaName)



                startActivity(admindIntent)


            }



        }


    }
    companion object{

        private lateinit var flutterContext : FlutterEngine

        fun callFlutterMethod(){


            MethodChannel(flutterContext.dartExecutor.binaryMessenger, "callMrFlutter")
                .invokeMethod("showToast", "")



        }
    }

}


