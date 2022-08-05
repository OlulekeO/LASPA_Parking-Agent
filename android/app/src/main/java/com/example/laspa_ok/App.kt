package com.example.laspa_ok


import android.app.Application
import android.os.Build
import android.util.Log
import com.arca.pos.Pos
import org.apache.log4j.Level

class App : Application() {
    override fun onCreate() {
        super.onCreate()

        // This must be done at Application startup
        Pos.LOG_LEVEL = Level.TRACE
        Pos.SCHEDULE_SETTLEMENT_RETRY = true // Will periodically schedule settlement retry
        Pos.ENABLE_BEACON = true // Enables advert
        Pos().init(this)
        Log.e(this.javaClass.simpleName, "Serial Number: ${Build.SERIAL}")
    }

}