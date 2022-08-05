package com.example.laspa_ok

import android.app.ProgressDialog
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.wifi.WifiConfiguration.AuthAlgorithm.strings
import android.os.AsyncTask
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.arca.common.printer.models.PrintResponse
import com.arca.manager.handler.CustomerReceiptPrinterHandler
import com.arca.manager.models.CustomPrint
import com.arca.manager.models.PrinterAlignment
import com.arca.pos.printer.Printer
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL
import java.util.ArrayList

class test : AppCompatActivity() {
    var ImageUrl: URL? = null
    var ImageUrl1: URL? = null
    var `is`: InputStream? = null
    var is1: InputStream? = null
    var bmImg: Bitmap? = null
    var bmImg1: Bitmap? = null
    var p: ProgressDialog? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //  setContentView(R.layout.activity_admin);
        val intent = intent
        val qrcode = intent.getStringExtra("qrcode")


        //Get the bundle
        val asyncTask = AsyncTaskExample()
        asyncTask.execute(qrcode)
        val intent1 = Intent(this, fourth::class.java)
        startActivity(intent1)
    }

    var url = "https://i.ibb.co/3NjWvMr/laspa-receipt-logo.png"

    private inner class AsyncTaskExample :
        AsyncTask<String?, String?, Bitmap?>() {
        override fun onPreExecute() {
            super.onPreExecute()
            p = ProgressDialog(this@test)
            p!!.setMessage("Please wait...Ticket Printing")
            p!!.isIndeterminate = false
            p!!.setCancelable(false)
            p!!.show()
        }
        override fun doInBackground(vararg params: String?): Bitmap? {
            try {
                ImageUrl = URL(strings[0])
                val conn = ImageUrl!!.openConnection() as HttpURLConnection
                conn.doInput = true
                conn.connect()
                `is` = conn.inputStream
                val options = BitmapFactory.Options()
                options.inPreferredConfig = Bitmap.Config.RGB_565
                bmImg = BitmapFactory.decodeStream(`is`, null, options)
            } catch (e: IOException) {
                e.printStackTrace()
            }
            return bmImg
        }


        override fun onPostExecute(bitmap: Bitmap?) {
            super.onPostExecute(bitmap)

//
//            try {
//                ImageUrl1 = new URL(url);
//                HttpURLConnection conn = (HttpURLConnection) ImageUrl1.openConnection();
//                conn.setDoInput(true);
//                conn.connect();
//                is1 = conn.getInputStream();
//                BitmapFactory.Options options = new BitmapFactory.Options();
//                options.inPreferredConfig = Bitmap.Config.RGB_565;
//                bmImg1 = BitmapFactory.decodeStream(is1, null, options);
//
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
            val intent = intent
            val PlateNumber = intent.getStringExtra("PlateNumber")
            val ParkingAreaName = intent.getStringExtra("ParkingAreaName")
            val ParkingSpotName = intent.getStringExtra("ParkingSpotName")
            val Amount = intent.getStringExtra("Amount")
            val ParkingTime = intent.getStringExtra("ParkingTime")
            val ExpiringTime = intent.getStringExtra("ExpiringTime")
            val qrcode = intent.getStringExtra("qrcode")
            val dataMap: MutableList<CustomPrint> = ArrayList()
            val customPrint = CustomPrint()
            customPrint.leftContent =
                "Plate Number:" // the data to be printed and it usually align by passing alignment value
            customPrint.rightContent =
                PlateNumber // to align data to left and the right side of a line, pass a value here, it'll be printed to the right.
            customPrint.alignment =
                PrinterAlignment.LEFT // pass this value if you are not passing in any value for the rightContent
            customPrint.textSize = 26 // to set the size of the text
            customPrint.bold = false // to set the weight of the text
            customPrint.invertColor = false // usually false
            dataMap.add(customPrint)
            val customPrint1 = CustomPrint()
            customPrint1.leftContent = "Parking Area:"
            customPrint1.rightContent = ParkingAreaName
            customPrint1.alignment =
                PrinterAlignment.LEFT // pass this value if you are not passing in any value for the rightContent
            customPrint1.textSize = 26 // to set the size of the text
            customPrint1.bold = false // to set the weight of the text
            customPrint1.invertColor = false // usually false
            dataMap.add(customPrint1)
            val customPrint3 = CustomPrint()
            customPrint3.leftContent = "Parking Spot:"
            customPrint3.rightContent = ParkingSpotName
            customPrint3.alignment =
                PrinterAlignment.LEFT // pass this value if you are not passing in any value for the rightContent
            customPrint3.textSize = 26 // to set the size of the text
            customPrint3.bold = false // to set the weight of the text
            customPrint3.invertColor = false // usually false
            dataMap.add(customPrint3)
            val customPrint4 = CustomPrint()
            customPrint4.leftContent = "Amount:"
            customPrint4.rightContent = Amount
            customPrint4.alignment =
                PrinterAlignment.LEFT // pass this value if you are not passing in any value for the rightContent
            customPrint4.textSize = 26 // to set the size of the text
            customPrint4.bold = false // to set the weight of the text
            customPrint4.invertColor = false // usually false
            dataMap.add(customPrint4)
            val customPrint5 = CustomPrint()
            customPrint5.leftContent = "Park Time:"
            customPrint5.rightContent = ParkingTime
            customPrint5.alignment =
                PrinterAlignment.LEFT // pass this value if you are not passing in any value for the rightContent
            customPrint5.textSize = 26 // to set the size of the text
            customPrint5.bold = false // to set the weight of the text
            customPrint5.invertColor = false // usually false
            dataMap.add(customPrint5)
            val customPrint6 = CustomPrint()
            customPrint6.leftContent = "End Time:"
            customPrint6.rightContent = ExpiringTime
            customPrint6.alignment =
                PrinterAlignment.LEFT // pass this value if you are not passing in any value for the rightContent
            customPrint6.textSize = 26 // to set the size of the text
            customPrint6.bold = false // to set the weight of the text
            customPrint6.invertColor = false // usually false
            dataMap.add(customPrint6)
            val customPrint2 = CustomPrint()

//            // get input stream
//            String src = "https://app.prananet.io/LaspaApp/img/LASPALOGOPNGB.png";
//            URL url = new URL(src);
//            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
//            connection.setDoInput(true);
//            connection.connect();
//            InputStream input = connection.getInputStream();
//            Bitmap myBitmap = BitmapFactory.decodeStream(input);
//            customPrint2.image = myBitmap;
//            customPrint2.alignment = PrinterAlignment.CENTER;
            customPrint2.image = bitmap
            customPrint2.alignment =
                PrinterAlignment.CENTER // pass this value if you are not passing in any value for the rightContent
            customPrint2.textSize = 26 // to set the size of the text
            customPrint2.bold = false // to set the weight of the text
            customPrint2.invertColor = false // usually false


//        loading();
            dataMap.add(customPrint2)
            val customPrint8 = CustomPrint()
            customPrint8.image = bmImg1
            customPrint8.alignment =
                PrinterAlignment.CENTER // pass this value if you are not passing in any value for the rightContent
            customPrint8.invertColor = false // usually false
            dataMap.add(customPrint8)
            val customPrint7 = CustomPrint()
            customPrint7.leftContent = " "
            customPrint7.rightContent = " "
            customPrint7.alignment =
                PrinterAlignment.LEFT // pass this value if you are not passing in any value for the rightContent
            customPrint7.textSize = 26 // to set the size of the text
            customPrint7.bold = false // to set the weight of the text
            customPrint7.invertColor = false // usually false
            dataMap.add(customPrint7)
            Printer.printCustomReceipt(
                dataMap
            ) { }
            p!!.hide()
        }


    } //    public void loading (){
    //
    //            DownloadImage downloadImage = new DownloadImage();
    //            try {
    //                Bitmap bitmap = downloadImage.execute(url).get();
    //                CustomPrint customPrint2 = new CustomPrint();
    //                customPrint2.leftContent = "Email";
    //                customPrint2.rightContent = "ldldldld";
    //                customPrint2.image = bitmap;
    //                customPrint2.alignment = PrinterAlignment.LEFT; // pass this value if you are not passing in any value for the rightContent
    //                customPrint2.textSize = 26; // to set the size of the text
    //                customPrint2.bold = false; // to set the weight of the text
    //                customPrint2. invertColor = false; // usually false
    //
    //
    //
    //
    //            } catch (Exception e) {
    //                e.printStackTrace();
    //            }
    //
    //    }
    //
    //    public class DownloadImage extends AsyncTask<String, Void, Bitmap> {
    //
    //
    //        @Override
    //        protected Bitmap doInBackground(String... strings) {
    //            Bitmap bitmap = null;
    //
    //            URL url;
    //            HttpURLConnection httpURLConnection;
    //
    //            InputStream in;
    //
    //            try {
    //
    //                url = new URL (strings[0]);
    //                httpURLConnection= (HttpURLConnection) url.openConnection();
    //                in = httpURLConnection.getInputStream();
    //                bitmap = BitmapFactory.decodeStream(in);
    //
    //
    //
    //            } catch (Exception e) {
    //                e.printStackTrace();
    //            }
    //
    //            return null;
    //        }
    //    }
    companion object{

        private lateinit var flutterContext : FlutterEngine

        fun callFlutterMethod(){


            MethodChannel(flutterContext.dartExecutor.binaryMessenger, "callMrFlutter")
                .invokeMethod("showToast", "")



        }
    }

}