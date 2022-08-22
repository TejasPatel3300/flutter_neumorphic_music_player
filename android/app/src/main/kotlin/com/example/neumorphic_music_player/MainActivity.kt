package com.example.neumorphic_music_player

import android.content.ContentUris
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.provider.MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI
import android.provider.MediaStore.Audio.Artists.EXTERNAL_CONTENT_URI
import android.provider.MediaStore.Audio.Genres.EXTERNAL_CONTENT_URI
import android.provider.MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
import android.provider.MediaStore.Downloads.EXTERNAL_CONTENT_URI
import android.util.Log
import com.example.neumorphic_music_player.constants.Constants
import com.example.neumorphic_music_player.models.AudioModel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            Constants.AUDIO_FILES_CHANNEL
        ).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread.
            when (call.method) {
                Constants.METHOD_QUERY_AUDIO_FILES -> {
                    val audioList = getAudioFiles()
                    val audioFiles = mutableListOf<Map<String, Any>>()
                    if (audioList.isEmpty()) {
                        result.error("Error", "No music files found", null)
                    } else {
                        for (audio in audioList) {
                            audioFiles.add(
                                mapOf(
                                    "name" to audio.name,
                                    "uri" to audio.uri.toString(),
                                    "duration" to audio.duration,
                                    "size" to audio.size,
                                    "artist" to audio.artist
                                )
                            )
                            Log.d("audiofile", audio.toString())
                        }
                        result.success(audioFiles)
                    }
                }

            }
        }
    }


    private fun getAudioFiles(): List<AudioModel> {
        val audioList = mutableListOf<AudioModel>()

        val collection =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                MediaStore.Audio.Media.getContentUri(
                    "external"
                )
            } else {
                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
            }

//        val projection = arrayOf(
//            MediaStore.Audio.Media._ID,
//            MediaStore.Audio.Media.DISPLAY_NAME,
//            MediaStore.Audio.Media.DURATION,
//            MediaStore.Audio.Media.SIZE
//        )

        // Show only get audios that are more than 0 seconds and categorized as music.
        val selection = "${MediaStore.Audio.Media.DURATION} > 0 AND ${MediaStore.Audio.Media.IS_MUSIC} != 0"
//        val selectionArgs = arrayOf(
//            "0",
//        )

        // Display videos in alphabetical order based on their display name.
        val sortOrder = "${MediaStore.Audio.Media.TITLE} ASC"

//        val query = contentResolver.query(
//            collection, projection, selection, selectionArgs, sortOrder,
//        )
        val query = contentResolver.query(
            collection, null, selection, null, sortOrder,
        )

        query?.use { cursor ->
            // Cache column indices.
            val idColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media._ID)
            val titleColumn =
                cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.TITLE)
            val durationColumn =
                cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION)
            val sizeColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.SIZE)
            val artistColumns = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ARTIST)

            while (cursor.moveToNext()) {
                // Get values of columns for a given Audio.
                val id = cursor.getLong(idColumn)
                val title = cursor.getString(titleColumn)
                val duration = cursor.getInt(durationColumn)
                val size = cursor.getInt(sizeColumn)
                val artist = cursor.getString(artistColumns)

                val contentUri: Uri = ContentUris.withAppendedId(
                    MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                    id
                )

                // Stores column values and the contentUri in a local object
                // that represents the media file.
                audioList += AudioModel(contentUri, title, duration, size, artist)
            }
        }
        return audioList

    }
}
