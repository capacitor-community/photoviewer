package com.getcapacitor.community.media.photoviewer.adapter

import android.os.Parcel
import android.os.Parcelable
import kotlinx.parcelize.Parceler
import kotlinx.parcelize.Parcelize

@Parcelize
data class Image(
        val url: String?,
        val title: String? = null
): Parcelable {
    constructor(parcel: Parcel) : this(
            parcel.readString(),
            parcel.readString()) {
    }

    companion object : Parceler<Image> {

        override fun Image.write(parcel: Parcel, flags: Int) {
            parcel.writeString(url)
            parcel.writeString(title)
        }

        override fun create(parcel: Parcel): Image {
            return Image(parcel)
        }
    }
}
