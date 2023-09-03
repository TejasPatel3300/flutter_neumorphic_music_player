package com.example.neumorphic_music_player.models

import android.net.Uri


data class AudioModel(
    val uri: Uri,
    val name: String,
    val duration: Int,
    val size: Int,
    val artist: String
)
