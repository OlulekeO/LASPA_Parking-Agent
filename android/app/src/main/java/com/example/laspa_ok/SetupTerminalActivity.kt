package com.example.laspa_ok


import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.arca.common.download.models.DownloadResponse
import com.arca.common.download.types.DownloadStatus
import com.arca.common.handler.CallHomeHandler
import com.arca.common.handler.KeyDownloadHandler
import com.arca.common.handler.TerminalSetupHandler
import com.arca.common.models.CallHomeResponse
import com.arca.pos.Pos
import java.util.*

class SetupTerminalActivity : AppCompatActivity(), View.OnClickListener {

    private var termParamTextMsg: String? = null
    private var tmkTextMsg: String? = null
    private var tpkTextMsg: String? = null
    private var tskTextMsg: String? = null
    private var aidTextMsg: String? = null
    private var capkTextMsg: String? = null
    private var emvParamTextMsg: String? = null

    private var termParamText: TextView? = null
    private var tmkText: TextView? = null
    private var tpkText: TextView? = null
    private var tskText: TextView? = null
    private var aidText: TextView? = null
    private var capkText: TextView? = null
    private var emvParamText: TextView? = null
    private var downloadStatusText: TextView? = null
    private var doneButton: Button? = null
    private var retryButton: Button? = null
    private val MSG_SET_UP_TERMINAL: String = "MSG_SET_UP_TERMINAL"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_setup_terminal)

        doneButton = findViewById(R.id.done_btn)
        retryButton = findViewById(R.id.retry_btn)

        initView()
        initData()
    }

    private fun initView() {
        termParamText = findViewById(R.id.termParamText)
        tmkText = findViewById(R.id.tmkText)
        tpkText = findViewById(R.id.tpkText)
        tskText = findViewById(R.id.tskText)
        aidText = findViewById(R.id.aidText)
        capkText = findViewById(R.id.capkText)
        emvParamText = findViewById(R.id.emvParamText)
        downloadStatusText = findViewById(R.id.downloadStatusText)
        doneButton!!.setOnClickListener(this)
        retryButton!!.setOnClickListener(this)
    }


    private fun initData() {
        emvParamTextMsg = emvParamText!!.text.toString()
        tmkTextMsg = tmkText!!.text.toString()
        tpkTextMsg = tpkText!!.text.toString()
        tskTextMsg = tskText!!.text.toString()
        aidTextMsg = aidText!!.text.toString()
        capkTextMsg = capkText!!.text.toString()
        termParamTextMsg = termParamText!!.text.toString()
        val devSerialNoText = findViewById<TextView>(R.id.deviceSerialNo)
        val msg = devSerialNoText.text.toString() + Build.SERIAL
        devSerialNoText.text = msg
        setAllDownloadStatus("pending")
        handleMessage(MSG_SET_UP_TERMINAL)
        downloadStatusText!!.text = "Setting up Terminal..."
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.done_btn -> {

                startActivity(Intent(this, MainActivity::class.java))
                finish()
            }
            R.id.retry_btn -> {
                handleMessage(MSG_SET_UP_TERMINAL)
                doneButton!!.isEnabled = false
                retryButton!!.isEnabled = false
            }
            else -> {
            }
        }
    }


    private fun handleMessage(msg: String) {
        when (msg) {
            MSG_SET_UP_TERMINAL -> {
                Pos.setIsEPMSEnv(false)
                Pos.setupTerminal(BuildConfig.API_KEY, terminalSetupHandler)
                val storedNetworkParameter = Pos.getNetworkParameters()
                println(storedNetworkParameter)
            }
        }
    }


    override fun onBackPressed() {
        startActivity(Intent(this, MainActivity::class.java))
        finish()

    }


    private val terminalSetupHandler: TerminalSetupHandler = object : TerminalSetupHandler {
        override fun onSetupTerminal(downloadResponse: DownloadResponse) {
            Log.d("SetupTerminal", "Terminal Setup Completed")
            if (DownloadStatus.SUCCESSFUL == downloadResponse.downloadStatus) {
                Log.d("SetupTerminal", "Dowload Key Started")
                // Must be called after successful parameter setup
                Pos.downloadKeys(keyDownloadListerner)
                // ScheduleCallHome & getCallHomePeriodInMilli must be called after successful parameter setup.
                // Please note that callhome period is usually set by NIBSS.
                val callHomeTimeInMilli = Pos.getCallHomePeriodInMilli()
                Pos.scheduleCallhome(callHomeTimeInMilli, callHomeHandler)
            } else {
                showToast("Terminal Setup failed! " + downloadResponse.downloadReasonCode)
                setAllDownloadStatus("failed")
                downloadStatusText!!.text = "Terminal Setup failed..." + downloadResponse.downloadReasonCode
            }
            doneButton!!.isEnabled = true
            retryButton!!.isEnabled = true
        }

        override fun onFailed(downloadResponse: DownloadResponse) {
            Log.d("SetupTerminal", "Terminal Setup Failed")
            showToast("Terminal Setup failed! " + downloadResponse.downloadReasonCode)
            setAllDownloadStatus("failed")
            downloadStatusText!!.text =
                "Terminal Setup failed..." + downloadResponse.downloadReasonCode
            doneButton!!.isEnabled = true
            retryButton!!.isEnabled = true
        }
    }


    private val keyDownloadListerner: KeyDownloadHandler = object : KeyDownloadHandler {
        override fun onDownloadKeys(downloadResponse: DownloadResponse) {
            logResponse("KEYS SETUP", downloadResponse)
        }

        override fun onDownloadTMK(downloadResponse: DownloadResponse) {
            logResponse("TMK", downloadResponse)
        }

        override fun onDownloadTSK(downloadResponse: DownloadResponse) {
            logResponse("TSK", downloadResponse)
        }

        override fun onDownloadTPK(downloadResponse: DownloadResponse) {
            logResponse("TPK", downloadResponse)
        }

        override fun onDownloadAID(downloadResponse: DownloadResponse) {
            logResponse("AID", downloadResponse)
        }

        override fun onDownloadCAPK(downloadResponse: DownloadResponse) {
            logResponse("CAPK", downloadResponse)
        }

        override fun onDownloadTerminalParam(downloadResponse: DownloadResponse) {
            logResponse("TERMINAL PARAM", downloadResponse)
        }
    }

    private fun logResponse(type: String, downloadResponse: DownloadResponse) {
        if (DownloadStatus.SUCCESSFUL == downloadResponse.downloadStatus) {
            runOnUiThread { downloadStatusText!!.text = "$type setup complete!" }
            setAllDownloadStatus("done")
            Log.d("SetupTerminal", "Response Status: " + downloadResponse.downloadStatus)
            Log.d("SetupTerminal", "Response Reason Code: " + downloadResponse.downloadReasonCode)
            Log.d("SetupTerminal", "Response Error code: " + downloadResponse.errorCode)
            Log.d(
                "SetupTerminal",
                "Response Error description: " + downloadResponse.errorDescription
            )
        } else {
            showToast(type + " setup failed! " + downloadResponse.downloadReasonCode)
            setAllDownloadStatus("failed")
            runOnUiThread {
                downloadStatusText!!.text =
                    type + " setup failed..." + downloadResponse.downloadReasonCode
            }
            Log.d("SetupTerminal", "Response Status: " + downloadResponse.downloadStatus)
            Log.d("SetupTerminal", "Response Reason Code: " + downloadResponse.downloadReasonCode)
            Log.d("SetupTerminal", "Response Error code: " + downloadResponse.errorCode)
            Log.d(
                "SetupTerminal",
                "Response Error description: " + downloadResponse.errorDescription
            )
        }
        runOnUiThread {
            doneButton!!.isEnabled = true
            retryButton!!.isEnabled = true
        }
    }


    private val callHomeHandler: CallHomeHandler = object : CallHomeHandler {
        override fun onPreCallHome() {
            Log.d("SetupTerminal", "About to callhome: " + Date())
        }

        override fun onPostCallHome(callHomeResponse: CallHomeResponse) {
            Log.d("SetupTerminal", "Called home: " + Date())
            Log.d("SetupTerminal", "Response Status: " + callHomeResponse.callHomeStatus)
            Log.d("SetupTerminal", "Response Reason Code: " + callHomeResponse.callHomeReasonCode)
            Log.d("SetupTerminal", "Response Error code: " + callHomeResponse.errorCode)
            Log.d(
                "SetupTerminal",
                "Response Error description: " + callHomeResponse.errorDescription
            )
        }
    }

    private fun setAllDownloadStatus(status: String) {
        runOnUiThread {
            emvParamText!!.text = "$emvParamTextMsg $status"
            tmkText!!.text = "$tmkTextMsg $status"
            tpkText!!.text = "$tpkTextMsg $status"
            tskText!!.text = "$tskTextMsg $status"
            aidText!!.text = "$aidTextMsg $status"
            capkText!!.text = "$capkTextMsg $status"
            termParamText!!.text = "$termParamTextMsg $status"
        }
    }

    private fun showToast(msg: String?) {
        runOnUiThread { Toast.makeText(this, msg, Toast.LENGTH_SHORT).show() }
    }
}