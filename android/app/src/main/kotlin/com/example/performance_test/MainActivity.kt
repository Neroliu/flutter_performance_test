package com.example.performance_test

import android.graphics.Point
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.view.Display
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        trySetHighRefreshRate()
    }

    private fun trySetHighRefreshRate() {
        if (activity == null) return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val supportDisplayMode = activity.display?.supportedModes ?: run {
                return
            }
            var maxRefreshRateMode: Display.Mode? = null
            val resolution = Point()
            activity.display?.getRealSize(resolution)

            //获取当前的刷新率
            val currentReFreshRate = activity.display?.mode?.refreshRate
            for (mode in supportDisplayMode) {
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
                    lp.preferredDisplayModeId = it.modeId
                    activity.window.attributes = lp
                }
            }
        }
    }
}
