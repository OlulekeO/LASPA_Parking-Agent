package com.example.laspa_ok

import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.SharedPreferences
import android.content.res.Configuration
import android.os.Bundle
import android.text.InputType
import android.util.Log
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.arca.common.emv.card.types.CardAccountType
import com.arca.common.pinpad.PinpadResource
import com.arca.common.printer.models.PrintResponse
import com.arca.common.transactions.handler.PaymentCardBalanceTransactionListener
import com.arca.common.transactions.handler.PaymentCardTransactionListener
import com.arca.common.transactions.models.*
import com.arca.manager.handler.MerchantReceiptPrinterHandler
import com.arca.common.transactions.types.TransactionStatus
import com.arca.pos.Pos
import com.arca.pos.printer.Printer
import com.arca.pos.transactions.Transaction
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.*

class TransactionActivity : AppCompatActivity() {

    private var transactionDetails: TransactionDetails? = null
    private var txtTransResponse: TextView? = null

    private var transactionInProgress = true
    private var printingInProgress = false
    private var customerReceiptPrinted = false
    private var merchantReceiptPrinted = false
    private var transaction = Transaction()
    private val TAG = "MainActivity"


    val SHARED_PREFS = "shared_prefs"

    val EMAIL_KEY = "email_key"
    var sharedpreferences: SharedPreferences? = null
    var payStatus: String? = null

//    private var customerPrintButton: Button? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_transaction)
//        customerPrintButton = findViewById(R.id.customerPrint_btn)
        processTransaction()
    }

    private fun processTransaction() {
        val tranTypeFlag: String = intent.extras!!.getString(Pos.getTransType(), "SALE")
        txtTransResponse = findViewById(R.id.transaction_response)
        val pinpadResource = PinpadResource(
            R.layout.layout_pinpad, R.id.tv_pwd,
            R.id.button1, R.id.button2, R.id.button3, R.id.button4, R.id.button5,
            R.id.button6, R.id.button7, R.id.button8, R.id.button9, R.id.button0,
            R.id.btn_cancel, R.id.btn_confirm, R.id.btn_clean
        )

        if (tranTypeFlag == "SALE") {
            val intent = intent
            val Amount = intent.getStringExtra("Amount")

            val first = 100
            val second = Amount?.toInt()
            val chargeAmount = first * second!!
            val transactionParameter = TransactionParameter.Builder(CardAccountType.DEFAULT)
                .amount(chargeAmount.toLong()) // Minor Denomination
                .build()
            Log.e(this.javaClass.simpleName, "transactionParameter $transactionParameter")

            transaction.doSale(this, pinpadResource, transactionParameter, transactionListener)

//            val admindIntent = Intent(this, third::class.java)
//            admindIntent.putExtra("PlateNumber",intent.getStringExtra("PlateNumber"))
//            admindIntent.putExtra("ParkingAreaName",intent.getStringExtra("ParkingAreaName"))
//            admindIntent.putExtra("ParkingSpotName",intent.getStringExtra("ParkingSpotName"))
//            admindIntent.putExtra("Amount",intent.getStringExtra("Amount"))
//            admindIntent.putExtra("ParkingTime",intent.getStringExtra("ParkingTime"))
//            admindIntent.putExtra("ExpiringTime",intent.getStringExtra("ExpiringTime"))
//            admindIntent.putExtra("qrcode",intent.getStringExtra("qrcode"))
//            startActivity(admindIntent)

        } else if (tranTypeFlag == "PRE_AUTH") {
            val transactionParameter = TransactionParameter.Builder(CardAccountType.DEFAULT)
                .amount(intent.extras!!.getLong("TRAN_AMT", 100)) // Minor Denomination
                .build()
            transaction = Transaction()
            transaction.doPreAuth(this, null, transactionParameter, transactionListener)
        } else if (tranTypeFlag == "SALE_COMPLETION") {
            val alert = AlertDialog.Builder(this)
            alert.setTitle("Enter RRN")
            val input = EditText(this)
            input.inputType = InputType.TYPE_CLASS_NUMBER
            input.setRawInputType(Configuration.KEYBOARD_12KEY)
            alert.setView(input)
            alert.setPositiveButton("Ok") { dialog: DialogInterface?, whichButton: Int ->
                //Put actions for OK button here
                val rrn = input.text.toString()
                val buffer = StringBuffer()
                for (i in rrn.length..11) {
                    buffer.append("0")
                }
                buffer.append(rrn)
                val transactionParameter =
                    TransactionParameter.Builder(CardAccountType.DEFAULT)
                        .amount(intent.extras!!.getLong("TRAN_AMT", 100)) // Minor Denomination
                        .transactionReference(buffer.toString())
                        .build()
                val transaction =
                    Transaction()
                transaction.doSaleCompletion(
                    this,
                    null,
                    transactionParameter,
                    transactionListener
                )
            }
            alert.setNegativeButton(
                "Cancel"
            ) { dialog: DialogInterface?, whichButton: Int -> }
            alert.show()
        } else if (tranTypeFlag == "CARD_VERIFICATION") {
            val transactionParameter = TransactionParameter.Builder(CardAccountType.DEFAULT)
                .amount(intent.extras!!.getLong("TRAN_AMT", 100)) // Minor Denomination
                .build()
            transaction = Transaction()
            transaction.doCardVerification(this, null, transactionParameter, transactionListener)
        } else if (tranTypeFlag == "BALANCE") {
            val transactionParameter = TransactionParameter.Builder(CardAccountType.DEFAULT)
                .build()
            transaction = Transaction()
            transaction.doBalance(this, null, transactionParameter, transactionHandler)
        } else if (tranTypeFlag == "REFUND") {
            val alert = AlertDialog.Builder(this)
            alert.setTitle("Enter RRN")
            val input = EditText(this)
            input.inputType = InputType.TYPE_CLASS_NUMBER
            input.setRawInputType(Configuration.KEYBOARD_12KEY)
            alert.setView(input)
            alert.setPositiveButton("Ok") { dialog: DialogInterface?, whichButton: Int ->
                //Put actions for OK button here
                val rrn = input.text.toString()
                val buffer = StringBuffer()
                for (i in rrn.length..11) {
                    buffer.append("0")
                }
                buffer.append(rrn)
                val transactionParameter =
                    TransactionParameter.Builder(CardAccountType.DEFAULT)
                        .amount(intent.extras!!.getLong("TRAN_AMT", 100)) // Minor Denomination
                        .transactionReference(buffer.toString()) // 12 character Retrieval Reference Number of transaction to be refunded. This is returned as part of transaction response in transaction handler
                        .build()
                transaction = Transaction()
                transaction.doRefund(
                    this,
                    pinpadResource,
                    transactionParameter,
                    transactionListener
                )
            }
            alert.setNegativeButton(
                "Cancel"
            ) { dialog: DialogInterface?, whichButton: Int -> }
            alert.show()
        } else if (tranTypeFlag == "CASHBACK") {
            val alert = AlertDialog.Builder(this)
            alert.setTitle("Enter CashBack Amount")
            val input = EditText(this)
            input.inputType = InputType.TYPE_CLASS_NUMBER
            input.setRawInputType(Configuration.KEYBOARD_12KEY)
            alert.setView(input)
            alert.setPositiveButton("Continue") { dialog: DialogInterface?, whichButton: Int ->
                //Put actions for OK button here
                val rrn = input.text.toString()
                val buffer = StringBuffer()
                for (i in rrn.length..11) {
                    buffer.append("0")
                }
                buffer.append(rrn)
                val cashbackAmount = buffer.toString()
                val transactionParameter = TransactionParameter.Builder(CardAccountType.DEFAULT)
                    .amount(intent.extras!!.getLong("TRAN_AMT", 1000)) // Minor Denomination
                    .cashbackAmount(cashbackAmount.toLong()) // Minor Denomination
                    .build()
                transaction = Transaction()
                transaction.doCashback(this, null, transactionParameter, transactionListener)
            }
            alert.setNegativeButton("Cancel") { dialog: DialogInterface?, whichButton: Int ->
                //Put actions for CANCEL button here, or leave in blank
                finish()
            }
            alert.show()
        } else if (tranTypeFlag == "CASH_ADVANCE") {
            val transactionParameter = TransactionParameter.Builder(CardAccountType.DEFAULT)
                .amount(intent.extras!!.getLong("TRAN_AMT", 1000)) // Minor Denomination
                .build()
            transaction = Transaction()
            transaction.doCashAdvance(this, null, transactionParameter, transactionListener)
        }
    }

    private var transactionListener: PaymentCardTransactionListener =
        object : PaymentCardTransactionListener {
            override fun onStart(var1: Boolean) {
                Log.d(this::class.simpleName, "Start: $var1")
            }

            override fun onStop(var1: Boolean) {
                Log.d(this::class.simpleName, "Stop: $var1")
            }

            override fun onSucess(transactionResponse: TransactionResponse) {
                Log.d(
                    this::class.simpleName,
                    "Succcess: " + transactionResponse.transactionStatus
                )
                if (TransactionStatus.ERROR != transactionResponse.transactionStatus) {
                    transactionDetails = transactionResponse.transactionDetails
                    Log.d(
                        this::class.simpleName,
                        "Card Type: " + transactionDetails?.cardTypeName
                    )
                    Log.d(
                        this::class.simpleName,
                        "Issuer BIN: " + transactionDetails?.issuerBin
                    )
                    Log.d(
                        this::class.simpleName,
                        "Masked PAN: " + transactionDetails?.maskedPan
                    )
                    Log.d(this::class.simpleName, "STAN: " + transactionDetails?.stan)
                    Log.d(
                        this::class.simpleName,
                        "Transaction Reference: " + transactionDetails?.transactionReference
                    )
                    Log.d(
                        this::class.simpleName,
                        "Trasaction Transmission Time: " + transactionDetails?.transactionDateTime
                    )
                }
                displayMessage(transactionResponse)
                /**
                 * Print Transaction Data
                 */
                customerReceiptPrinted = true
                transactionInProgress = true
                printingInProgress = false
                merchantReceiptPrinted = false
                print(transactionResponse.transactionDetails)

//            println("This is a test call new calll")
//                val admindIntent = Intent(this@TransactionActivity, third::class.java)
//                admindIntent.putExtra("PlateNumber",intent.getStringExtra("PlateNumber"))
//                admindIntent.putExtra("ParkingAreaName",intent.getStringExtra("ParkingAreaName"))
//                admindIntent.putExtra("ParkingSpotName",intent.getStringExtra("ParkingSpotName"))
//                admindIntent.putExtra("Amount",intent.getStringExtra("Amount"))
//                admindIntent.putExtra("ParkingTime",intent.getStringExtra("ParkingTime"))
//                admindIntent.putExtra("ExpiringTime",intent.getStringExtra("ExpiringTime"))
//                admindIntent.putExtra("qrcode",intent.getStringExtra("qrcode"))
//                startActivity(admindIntent)


            }

            override fun onFailed(var1: TransactionErrorResponse) {
                Log.d(this::class.simpleName, "Transaction Failed: " + var1.errorDescription)
                displayErrorMessage(var1)
            }

            override fun onMessage(message: String?) {
                Log.d(this::class.simpleName, "Listener Message: $message")
            }
//            fun onClick(v: View) {
//                when (v.id) {
//                    R.id.customerPrint_btn -> {
//                        println(intent.getStringExtra("PlateNumber"))
////                startActivity(Intent(this, MainActivity::class.java))
////                val admindIntent = Intent(this, third::class.java)
////                admindIntent.putExtra("PlateNumber",intent.getStringExtra("PlateNumber"))
////                admindIntent.putExtra("ParkingAreaName",intent.getStringExtra("ParkingAreaName"))
////                admindIntent.putExtra("ParkingSpotName",intent.getStringExtra("ParkingSpotName"))
////                admindIntent.putExtra("Amount",intent.getStringExtra("Amount"))
////                admindIntent.putExtra("ParkingTime",intent.getStringExtra("ParkingTime"))
////                admindIntent.putExtra("ExpiringTime",intent.getStringExtra("ExpiringTime"))
////                admindIntent.putExtra("qrcode",intent.getStringExtra("qrcode"))
////                startActivity(admindIntent)
////                finish()
//                    }
//                    else -> {
//                    }
//                }
//            }
        }

    private var transactionHandler: PaymentCardBalanceTransactionListener =
        object : PaymentCardBalanceTransactionListener {
            override fun onStart(var1: Boolean) {}
            override fun onStop(var1: Boolean) {}
            override fun onSucess(var1: TransactionResponse) {}
            override fun onFailed(var1: TransactionErrorResponse) {}
            override fun onMessage(message: String) {}
            override fun onBalanceResponse(
                transactionResponse: TransactionResponse,
                balance: Balance,
            ) {
                if (TransactionStatus.ERROR != transactionResponse.transactionStatus) {
                    Printer.printCustomerReceipt(
                        transactionResponse.transactionDetails.transactionReference,
                        false,
                        null,
                        printerHandler
                    )

                }
                displayMessage(transactionResponse)
            }
        }

    private fun displayMessage(transactionResponse: TransactionResponse) {
        val transactionStatus = transactionResponse.transactionStatus
        val transactionRef = transactionResponse.transactionDetails
        if (TransactionStatus.APPROVED.equals(transactionStatus)) {
            runOnUiThread {
//                txtTransResponse?.text = "Approved with (${transactionResponse.errorCode} Response Code)"
                txtTransResponse?.text = "Approved"
//                val editor = sharedpreferences!!.edit()
//                editor.putString(EMAIL_KEY, transactionResponse.errorCode);
//                editor.apply();

                val editor = getSharedPreferences("name", Context.MODE_PRIVATE).edit()
                editor.putString("name", transactionResponse.errorCode.toString())
                editor.apply()


                parkingStatusUpdate(transactionResponse.errorCode, transactionResponse.transactionDetails.transactionReference)
//                customerTicket()
                println("Print Ticket")

            }
            println("Approved")
        } else if (TransactionStatus.DECLINED.equals(transactionStatus)) {
            runOnUiThread {
//                txtTransResponse?.text = "Declined with (${transactionResponse.errorCode} Response Code)"
                txtTransResponse?.text = "Declined)"
                val editor = getSharedPreferences("name", Context.MODE_PRIVATE).edit()
                editor.putString("name", transactionResponse.errorCode.toString())
                editor.apply()
            }
            println("Declined")
        } else {
            runOnUiThread {
                txtTransResponse?.text = "Failed"
                val editor = getSharedPreferences("name", Context.MODE_PRIVATE).edit()
                editor.putString("name", transactionResponse.errorCode.toString())
                editor.apply()
            }
            println("Failed")
        }
        runOnUiThread {
            txtTransResponse?.text = "Please remove card"
        }
        //Toast.makeText(this, "Please remove card", Toast.LENGTH_LONG).show()
       // println("Please remove card")
    }

    private fun displayErrorMessage(transactionErrorResponse: TransactionErrorResponse) {
        runOnUiThread {
//            txtTransResponse?.text = "Failed: + ${transactionErrorResponse.errorDescription}"
            txtTransResponse?.text = "Failed!! Try again pls"
        }
    }

    protected var printerHandler: MerchantReceiptPrinterHandler =
        object : MerchantReceiptPrinterHandler {
            override fun onPrintCustomerReceipt(printResponse: PrintResponse) {
                Log.e("TransactionAct", "SDK: onPrintCustomerReceipt")
                // wait for key press to print merchant copy
                customerReceiptPrinted = true
                merchantReceiptPrinted = false
                printingInProgress = false
                // press back key or any key,to initiate merchant print
                runOnUiThread {
                    txtTransResponse?.text = "Press any where to print Merchant's copy"
                }
            }

            override fun onPrintMerchantReceipt(printResponse: PrintResponse) {
                Log.e("TransactionAct", "SDK: onPrintMerchantReceipt")
                customerReceiptPrinted = false
                merchantReceiptPrinted = true
                printingInProgress = false
                transactionInProgress = false

//                sharedpreferences = getSharedPreferences(SHARED_PREFS, Context.MODE_PRIVATE);
//                val email = sharedpreferences?.getString(EMAIL_KEY, null);
//                println("This is the way to go")
//                println(email)
                val userName = getSharedPreferences("name",Context.MODE_PRIVATE).getString("name", "")
                println("This is the way to go")
                println(userName)


                if (userName == "00"){

                    customerTicket()
                }else{
                    finish()
                }




//                if (printResponse.errorCode.equals("00")){
//
//                    customerTicket()
//                }

//                customerTicket()
              // finish()
//                onBackPressed()


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
//                val intent = intent
//                val PlateNumber = intent.getStringExtra("PlateNumber")
//                val ParkingAreaName = intent.getStringExtra("ParkingAreaName")
//                val ParkingSpotName = intent.getStringExtra("ParkingSpotName")
//                val Amount = intent.getStringExtra("Amount")
//                val ParkingTime = intent.getStringExtra("ParkingTime")
//                val ExpiringTime = intent.getStringExtra("ExpiringTime")
//                val qrcode = intent.getStringExtra("qrcode")
////
////
//                val admindIntent = Intent(this@TransactionActivity, third::class.java)
//                admindIntent.putExtra("PlateNumber",PlateNumber)
//                admindIntent.putExtra("ParkingAreaName",ParkingAreaName)
//                admindIntent.putExtra("ParkingSpotName",ParkingSpotName)
//                admindIntent.putExtra("Amount",Amount)
//                admindIntent.putExtra("ParkingTime",ParkingTime)
//                admindIntent.putExtra("ExpiringTime",ExpiringTime)
//                admindIntent.putExtra("qrcode",qrcode)
//                startActivity(admindIntent)
//                finish()

            }
        }

    fun print(transactionDetails: TransactionDetails?) {
        Log.e("TransactionAct", "SDK: called to print transaction: Started...")
        if (customerReceiptPrinted && transactionInProgress && !printingInProgress && !merchantReceiptPrinted && transactionDetails != null) {
            Log.e("TransactionAct", "SDK: called to print transaction: Loading...")
            printingInProgress = true
            val additionalData: Any = HashMap<Any?, Any?>()
            //            additionalData.put("VAS", "Airtime");
//            Print Merchant receipt
            Printer.printMerchantReceipt(
                transactionDetails.transactionReference,
                false,
                null,
                printerHandler
            )

        } else {
            Log.e("TransactionAct", "SDK: called to print transaction: Loading Failed...")
        }
        Log.e("TransactionAct", "SDK: called to print transaction: Stopped...")
    }

    override fun onBackPressed() {
        transaction.stopCardReaderProcess()
//        print(transactionDetails)
        onBack()
    }

    private fun onBack() {
        transaction.stopCardReaderProcess()
        startActivity(Intent(this, MainActivity::class.java))
        finish()
    }

    private fun parkingStatusUpdate(transactionReference :String , errorCode : String) {

//        val userName = getSharedPreferences("name",Context.MODE_PRIVATE).getString("name", "")
       //println("This is the way to go")
//        println(userName)


        val intent = intent
        val ParkingID = intent.getStringExtra("ParkingID")
        println(ParkingID)
        val apiInterface = RetrofitClient.getRetrofitInstance().create(
            ApiInterface::class.java
        )
        val call = apiInterface.getUserInformation(errorCode, transactionReference.toString(),ParkingID)
        call.enqueue(object : Callback<User> {
            override fun onResponse(call: Call<User>, response: Response<User>) {
                Log.e("", "onResponse: " + response.code() )
                Log.e("", "onResponse name : " + response.body()!!.name)
                Log.e("", "onResponse createdAt : " + response.body()!!.createdAt)
                Log.e("", "onResponse job : " + response.body()!!.job)
                Log.e("", "onResponse ParkingID : " + response.body()!!.parkingID)
                Log.e("", "onResponse id : " + response.body()!!.id)
            }

            override fun onFailure(call: Call<User>, t: Throwable) {
                Log.e("", "onFailure: " + t.message)
            }
        })

       /* customerTicket()*/

    }
    fun customerTicket(){
        val intent = intent
        val PlateNumber = intent.getStringExtra("PlateNumber")
        val ParkingAreaName = intent.getStringExtra("ParkingAreaName")
        val ParkingSpotName = intent.getStringExtra("ParkingSpotName")
        val Amount = intent.getStringExtra("Amount")
        val ParkingTime = intent.getStringExtra("ParkingTime")
        val ExpiringTime = intent.getStringExtra("ExpiringTime")
        val qrcode = intent.getStringExtra("qrcode")


        val admindIntent = Intent(this@TransactionActivity, third::class.java)
        admindIntent.putExtra("PlateNumber",PlateNumber)
        admindIntent.putExtra("ParkingAreaName",ParkingAreaName)
        admindIntent.putExtra("ParkingSpotName",ParkingSpotName)
        admindIntent.putExtra("Amount",Amount)
        admindIntent.putExtra("ParkingTime",ParkingTime)
        admindIntent.putExtra("ExpiringTime",ExpiringTime)
        admindIntent.putExtra("qrcode",qrcode)
        startActivity(admindIntent)
        finish()


    }

}