package com.example.laspa_ok

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.arca.manager.models.CustomPrint
import com.arca.manager.models.PrinterAlignment
import com.arca.pos.printer.Printer
import java.util.ArrayList
import java.util.*
import android.R.attr.name
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.Drawable
import android.graphics.drawable.Drawable.createFromStream
import java.io.InputStream
import java.net.URL
import android.R.attr.src
import android.app.ProgressDialog
import android.os.AsyncTask
import java.net.HttpURLConnection
import java.util.concurrent.Executors


class fourth : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        //  setContentView(R.layout.activity_admin);
        //Get the bundle
        val intent = intent
        val email = intent.getStringExtra("email")
        val firstname = intent.getStringExtra("firstname")
        val lastname = intent.getStringExtra("lastname")
        val phone = intent.getStringExtra("phone")
        //  setContentView(R.layout.activity_admin);
        val dataMap: MutableList<CustomPrint> = ArrayList()
        val customPrint = CustomPrint()
        customPrint.leftContent =
            "Name" // the data to be printed and it usually align by passing alignment value

        customPrint.rightContent =
            firstname // to align data to left and the right side of a line, pass a value here, it'll be printed to the right.

        customPrint.alignment =
            PrinterAlignment.LEFT // pass this value if you are not passing in any value for the rightContent

        customPrint.textSize = 26 // to set the size of the text

        customPrint.bold = false // to set the weight of the text

        customPrint.invertColor = false // usually false

        dataMap.add(customPrint)


        val customPrint1 = CustomPrint()
        customPrint1.leftContent = "Phone"
        customPrint1.rightContent = phone
        customPrint1.alignment =
            PrinterAlignment.LEFT // pass this value if you are not passing in any value for the rightContent

        customPrint1.textSize = 26 // to set the size of the text

        customPrint1.bold = false // to set the weight of the text

        customPrint1.invertColor = false // usually false

        dataMap.add(customPrint1)


        val customPrint2 = CustomPrint()
        customPrint2.leftContent = "Email"
        customPrint2.rightContent = email
//        val link =("https://app.prananet.io/LaspaApp/img/LASPALOGOPNGB.png")
//        val url = URL(link)
//        val connection = url.openConnection() as HttpURLConnection
//        connection.doInput = true
//        connection.connect()
//        val input = connection.inputStream
//        val bitmapFrmUrl = BitmapFactory.decodeStream(input)
//        customPrint2.image = bitmapFrmUrl
//        val url = URL("https://app.prananet.io/LaspaApp/img/LASPALOGOPNGB.png")
//        val bmp = BitmapFactory.decodeStream(url.openConnection().getInputStream())
//        customPrint2.image = BitmapFactory.decodeStream(url.openConnection().getInputStream())
        //val String_URI = "https://app.prananet.io/LaspaApp/img/LASPALOGOPNGB.png";
       // val url = URL("https://app.prananet.io/LaspaApp/img/LASPALOGOPNGB.png")
//        val image: Bitmap = BitmapFactory.decodeStream(url.openConnection().getInputStream())
//            var image: Bitmap? = null
//// Declaring executor to parse the URL
//        val executor = Executors.newSingleThreadExecutor()
//        executor.execute {
//
//            // Image URL
//            val imageURL = "https://media.geeksforgeeks.org/wp-content/cdn-uploads/gfg_200x200-min.png"
//            val `in` = java.net.URL(imageURL).openStream()
//            image = BitmapFactory.decodeStream(`in`)
//            customPrint2.image = image
//        }
//            val url = URL("http://app.prananet.io/LaspaApp/img/LASPALOGOPNGB.png")
//            val connection: HttpURLConnection = url.openConnection() as HttpURLConnection
//            connection.setDoInput(true)
//            connection.connect()
//            val input: InputStream = connection.getInputStream()
//            val myBitmap = BitmapFactory.decodeStream(input)




        customPrint2.alignment =
            PrinterAlignment.LEFT // pass this value if you are not passing in any value for the rightContent

        customPrint2.textSize = 26 // to set the size of the text

        customPrint2.bold = false // to set the weight of the text

        customPrint2.invertColor = false // usually false



        dataMap.add(customPrint2)
        Printer.printCustomReceipt(
            dataMap
        ) { }

//
//        val saleIntent = Intent(this, TransactionActivity::class.java)
//        val saleBundle = Bundle()
//        saleBundle.putString("TRAN_TYPE", "SALE")
//        saleIntent.putExtras(saleBundle)

        startActivity(Intent(this, MainActivity::class.java))
        finish()


    }



}

