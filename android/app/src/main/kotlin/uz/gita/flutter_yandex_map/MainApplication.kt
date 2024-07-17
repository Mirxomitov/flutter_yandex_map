package uz.gita.flutter_yandex_map

import android.app.Application

import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
    override fun onCreate() {
        super.onCreate()
       // MapKitFactory.setLocale("En") // Your preferred language. Not required, defaults to system language
        MapKitFactory.setApiKey("74c4dfb4-0106-4b58-9adc-1623e4393457") // Your generated API key
    }
}