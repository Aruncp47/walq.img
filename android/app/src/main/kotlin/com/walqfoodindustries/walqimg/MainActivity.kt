package com.walqfoodindustries.walqimg

import android.content.ContentValues
import android.content.Intent
import android.net.Uri
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.walqfoodindustries.walqimg/media"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scanFile" -> {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        val success = scanFile(path)
                        if (success) {
                            result.success(null)
                        } else {
                            result.error("FILE_NOT_FOUND", "File not found at the specified path", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "Path is required", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun scanFile(path: String): Boolean {
        val file = File(path)
        return if (file.exists()) {
            val contentUri = Uri.fromFile(file)

            // Broadcast to scan the file
            val mediaScanIntent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
            mediaScanIntent.data = contentUri
            sendBroadcast(mediaScanIntent)

            // Insert into MediaStore to appear immediately in the gallery
            val values = ContentValues().apply {
                put(MediaStore.Images.Media.DATA, file.absolutePath)
                put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                put(MediaStore.Images.Media.DATE_ADDED, System.currentTimeMillis() / 1000)
                put(MediaStore.Images.Media.DATE_TAKEN, System.currentTimeMillis())
            }

            val uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
            uri != null
        } else {
            false
        }
    }
}
