package com.getcapacitor.community.media.photoviewer.adapter

import android.content.Context
import android.os.Environment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.getcapacitor.community.media.photoviewer.R
import com.getcapacitor.community.media.photoviewer.databinding.ItemGalleryImageBinding
import com.getcapacitor.community.media.photoviewer.helper.GlideApp
import java.io.File
import android.net.Uri;
import android.util.Log
import com.getcapacitor.community.media.photoviewer.helper.ImageToBeLoaded


class GalleryImageAdapter(private val itemList: List<Image>) : RecyclerView
.Adapter<GalleryImageAdapter.ViewHolder>() {
    private val TAG = "GalleryImageAdapter"
    private lateinit var binding: ItemGalleryImageBinding
    private var context: Context? = null
    var listener: GalleryImageClickListener? = null
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): GalleryImageAdapter
    .ViewHolder {
        context = parent.context
        binding = ItemGalleryImageBinding
                .inflate(LayoutInflater.from(context),parent,false)

        return ViewHolder(binding.root)
    }
    override fun getItemCount(): Int {
        return itemList.size
    }
    override fun onBindViewHolder(holder: GalleryImageAdapter.ViewHolder, position: Int) {
        holder.bind(binding)
    }
    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        fun bind(binding: ItemGalleryImageBinding) {
          val image = itemList.get(bindingAdapterPosition)
          val mImageToBeLoaded = ImageToBeLoaded()
          val toBeLoaded = image.url?.let { mImageToBeLoaded.getToBeLoaded(it) }

          if (toBeLoaded is String) {
            // load image from http
            GlideApp.with(context!!)
              .load(toBeLoaded)
              .centerCrop()
              .placeholder(R.drawable.ic_image_place_holder) //5
              .error(R.drawable.ic_broken_image) //6
              .fallback(R.drawable.ic_no_image) //7
              .diskCacheStrategy(DiskCacheStrategy.ALL)
              .into(binding.ivGalleryImage)
          }
          if (toBeLoaded is File) {
            // load image from file
            GlideApp.with(context!!)
              .asBitmap()
              .load(toBeLoaded)
              .centerCrop()
              .placeholder(R.drawable.ic_image_place_holder) //5
              .error(R.drawable.ic_broken_image) //6
              .fallback(R.drawable.ic_no_image) //7
              .diskCacheStrategy(DiskCacheStrategy.ALL)
              .into(binding.ivGalleryImage)
          }
          // adding click or tap handler for our image layout
          binding.container.setOnClickListener {
              listener?.onClick(bindingAdapterPosition)
          }
        }
    }
}
