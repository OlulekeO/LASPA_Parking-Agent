package com.example.laspa_ok;


import android.app.Application;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import androidx.appcompat.app.AppCompatActivity;
import com.arca.common.printer.models.PrintResponse;
import com.arca.manager.handler.ConfigPrinterHandler;
import com.arca.pos.Pos;
import com.arca.pos.printer.Printer;
import io.flutter.embedding.android.FlutterActivity;
import org.apache.log4j.Level;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import com.arca.manager.models.PrinterAlignment;

import com.arca.manager.models.CustomPrint;
import java.util.ArrayList;
import java.util.*;
import com.arca.manager.handler.CustomerReceiptPrinterHandler;
import com.arca.manager.handler.EndOfDayPrinterHandler;
import com.arca.pos.printer.Printer;
import com.squareup.picasso.Picasso;
import com.squareup.picasso.Target;

import java.util.HashMap;



public class third extends AppCompatActivity {
    URL ImageUrl = null;
    URL ImageUrl1 = null;

    InputStream is = null;
    InputStream is1 = null;
    Bitmap bmImg = null;

    Bitmap bmImg1 = null;
    ProgressDialog p;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //  setContentView(R.layout.activity_admin);
        Intent intent = getIntent();
        String qrcode = intent.getStringExtra("qrcode");

            String logo ="";


        Picasso.get()
                .load("https://test.laspa.lg.gov.ng/LaspaApp/Api/laspa_logo.bmp")
                .resize(300, 300)
                .into(new Target() {
                    @Override
                    public void onBitmapLoaded(Bitmap bitmap, Picasso.LoadedFrom from) {
                        bmImg1 = bitmap;

                    }

                    @Override
                    public void onBitmapFailed(Exception e, Drawable errorDrawable) {

                    }


                    public void onBitmapFailed(Drawable errorDrawable) {

                    }

                    @Override
                    public void onPrepareLoad(Drawable placeHolderDrawable) {

                    }
                });


        //Get the bundle
        AsyncTaskExample asyncTask=new AsyncTaskExample();
        asyncTask.execute(qrcode);

        Intent intent1 = new Intent(this, fourth.class);
        startActivity(intent1);
    }




    String url = "https://i.ibb.co/3NjWvMr/laspa-receipt-logo.png";
    private class AsyncTaskExample extends AsyncTask<String, String, Bitmap> {
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            p = new ProgressDialog(third.this);
            p.setMessage("Please wait...Ticket Printing");
            p.setIndeterminate(false);
            p.setCancelable(false);
            p.show();
        }
        @Override
        protected Bitmap doInBackground(String... strings) {
            try {
                ImageUrl = new URL(strings[0]);
                HttpURLConnection conn = (HttpURLConnection) ImageUrl.openConnection();
                conn.setDoInput(true);
                conn.connect();
                is = conn.getInputStream();
                BitmapFactory.Options options = new BitmapFactory.Options();
                options.inPreferredConfig = Bitmap.Config.RGB_565;
                bmImg = BitmapFactory.decodeStream(is, null, options);





            } catch (IOException e) {
                e.printStackTrace();
            }
            return bmImg;
        }
        @Override
        protected void onPostExecute(Bitmap bitmap) {
            super.onPostExecute(bitmap);

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



            Intent intent = getIntent();
            String PlateNumber = intent.getStringExtra("PlateNumber");
            String ParkingAreaName = intent.getStringExtra("ParkingAreaName");
            String ParkingSpotName = intent.getStringExtra("ParkingSpotName");
            String Amount = intent.getStringExtra("Amount");
            String ParkingTime = intent.getStringExtra("ParkingTime");
            String ExpiringTime = intent.getStringExtra("ExpiringTime");
            String qrcode = intent.getStringExtra("qrcode");

            List<CustomPrint> dataMap = new ArrayList<>();


            CustomPrint customPrint8 = new CustomPrint();
            customPrint8.image = bmImg1;
            customPrint8.alignment = PrinterAlignment.CENTER; // pass this value if you are not passing in any value for the rightContent
            customPrint8. invertColor = false; // usually false
            dataMap.add(customPrint8);



            CustomPrint customPrint = new CustomPrint ();
            customPrint.leftContent = "Plate Number:"; // the data to be printed and it usually align by passing alignment value
            customPrint.rightContent = PlateNumber; // to align data to left and the right side of a line, pass a value here, it'll be printed to the right.
            customPrint.alignment = PrinterAlignment.LEFT; // pass this value if you are not passing in any value for the rightContent
            customPrint.textSize = 26; // to set the size of the text
            customPrint.bold = false; // to set the weight of the text
            customPrint. invertColor = false; // usually false
            dataMap.add(customPrint);


            CustomPrint customPrint1 = new CustomPrint();
            customPrint1.leftContent = "Parking Area:";
            customPrint1.rightContent = ParkingAreaName;
            customPrint1.alignment = PrinterAlignment.LEFT; // pass this value if you are not passing in any value for the rightContent
            customPrint1.textSize = 26; // to set the size of the text
            customPrint1.bold = false; // to set the weight of the text
            customPrint1. invertColor = false; // usually false
            dataMap.add(customPrint1);

            CustomPrint customPrint3 = new CustomPrint();
            customPrint3.leftContent = "Parking Spot:";
            customPrint3.rightContent = ParkingSpotName;
            customPrint3.alignment = PrinterAlignment.LEFT; // pass this value if you are not passing in any value for the rightContent
            customPrint3.textSize = 26; // to set the size of the text
            customPrint3.bold = false; // to set the weight of the text
            customPrint3. invertColor = false; // usually false
            dataMap.add(customPrint3);


            CustomPrint customPrint4 = new CustomPrint();
            customPrint4.leftContent = "Amount:";
            customPrint4.rightContent = "₦ "+ Amount;
            customPrint4.alignment = PrinterAlignment.LEFT; // pass this value if you are not passing in any value for the rightContent
            customPrint4.textSize = 26; // to set the size of the text
            customPrint4.bold = false; // to set the weight of the text
            customPrint4. invertColor = false; // usually false
            dataMap.add(customPrint4);


            CustomPrint customPrint5 = new CustomPrint();
            customPrint5.leftContent = "Park Time:";
            customPrint5.rightContent = ParkingTime;
            customPrint5.alignment = PrinterAlignment.LEFT; // pass this value if you are not passing in any value for the rightContent
            customPrint5.textSize = 26; // to set the size of the text
            customPrint5.bold = false; // to set the weight of the text
            customPrint5. invertColor = false; // usually false
            dataMap.add(customPrint5);



            CustomPrint customPrint6 = new CustomPrint();
            customPrint6.leftContent = "End Time:";
            customPrint6.rightContent = ExpiringTime;
            customPrint6.alignment = PrinterAlignment.LEFT; // pass this value if you are not passing in any value for the rightContent
            customPrint6.textSize = 26; // to set the size of the text
            customPrint6.bold = false; // to set the weight of the text
            customPrint6. invertColor = false; // usually false
            dataMap.add(customPrint6);




            CustomPrint customPrint2 = new CustomPrint();
            
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


            customPrint2.image = bitmap;
            customPrint2.alignment = PrinterAlignment.CENTER; // pass this value if you are not passing in any value for the rightContent
            customPrint2.textSize = 26; // to set the size of the text
            customPrint2.bold = false; // to set the weight of the text
            customPrint2. invertColor = false; // usually false



//        loading();

            dataMap.add(customPrint2);



            CustomPrint customPrint7 = new CustomPrint();
            customPrint7.leftContent = " ";
            customPrint7.rightContent = " ";
            customPrint7.alignment = PrinterAlignment.CENTER; // pass this value if you are not passing in any value for the rightContent
            customPrint7.textSize = 26; // to set the size of the text
            customPrint7.bold = false; // to set the weight of the text
            customPrint7. invertColor = false; // usually false
            dataMap.add(customPrint7);


            CustomPrint customPrint9 = new CustomPrint();
            customPrint9.leftContent = "Powered by Automata";

            customPrint9.alignment = PrinterAlignment.CENTER; // pass this value if you are not passing in any value for the rightContent
            customPrint9.textSize = 26; // to set the size of the text
            customPrint9.bold = false; // to set the weight of the text
            customPrint9. invertColor = false; // usually false
            dataMap.add(customPrint9);

//            CustomPrint customPrint10 = new CustomPrint();
//            customPrint10.leftContent = "www.automata.com.ng";
//            customPrint10.alignment = PrinterAlignment.CENTER; // pass this value if you are not passing in any value for the rightContent
//            customPrint10.textSize = 26; // to set the size of the text
//            customPrint10.bold = false; // to set the weight of the text
//            customPrint10. invertColor = false; // usually false
//            dataMap.add(customPrint10);

            CustomPrint customPrint11 = new CustomPrint();
            customPrint11.leftContent = "support@automata.com.ng";
            customPrint11.alignment = PrinterAlignment.CENTER; // pass this value if you are not passing in any value for the rightContent
            customPrint11.textSize = 26; // to set the size of the text
            customPrint11.bold = false; // to set the weight of the text
            customPrint11. invertColor = false; // usually false
            dataMap.add(customPrint11);

            CustomPrint customPrint12 = new CustomPrint();
            customPrint12.leftContent = "";
            customPrint12.rightContent = "";
            customPrint12.alignment = PrinterAlignment.CENTER; // pass this value if you are not passing in any value for the rightContent
            customPrint12.textSize = 26; // to set the size of the text
            customPrint12.bold = false; // to set the weight of the text
            customPrint12. invertColor = false; // usually false
            dataMap.add(customPrint12);




            Printer.printCustomReceipt(
                    dataMap,
                    new CustomerReceiptPrinterHandler() {
                        @Override
                        public void onPrintCustomerReceipt(PrintResponse printResponse) {

                        }
                    }
            );
            p.hide();
            startActivity(new Intent(third.this, MainActivity.class));

       
        }
    }
//    public void loading (){
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

}

