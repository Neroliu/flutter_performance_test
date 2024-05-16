package com.example.performance_test

import android.graphics.Point
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import android.view.Display
import android.view.Surface
import android.view.SurfaceHolder
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterSurfaceView

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        trySetHighRefreshRate()
    }

    private fun trySetHighRefreshRate() {
        if (activity == null) return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val supportDisplayMode = activity.display?.supportedModes ?: run {
                Log.i("nero", "cannot get support display mode")
                return
            }
            Log.i("nero", "support display mode size:${supportDisplayMode.size}")
            var maxRefreshRateMode: Display.Mode? = null
            val resolution = Point()
            activity.display?.getRealSize(resolution)

            //获取当前的刷新率
            val currentReFreshRate = activity.display?.mode?.refreshRate
            Log.i("nero", "current refreshRate:$currentReFreshRate")
            for (mode in supportDisplayMode) {
                Log.i("nero", "refreshRate:${mode.refreshRate}")
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
//                    Log.i(TAG, "alternativeRefreshRates:${mode.alternativeRefreshRates.joinToString(",")}")
//                }
                if (resolution.x == mode.physicalWidth && resolution.y == mode.physicalHeight) {
                    if (maxRefreshRateMode == null || mode.refreshRate > maxRefreshRateMode.refreshRate) {
                        maxRefreshRateMode = mode
                    }
                }
            }
            maxRefreshRateMode?.let {
                val lp = activity.window.attributes

                if (currentReFreshRate == null || it.refreshRate > currentReFreshRate) {
                    Log.i("nero", "refresh rate diff, try set:${it.refreshRate}")
                    lp.preferredDisplayModeId = it.modeId
                    activity.window.attributes = lp
                }
            }
        }
    }
}
