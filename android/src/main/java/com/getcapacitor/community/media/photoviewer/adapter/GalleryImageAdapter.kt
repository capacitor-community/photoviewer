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


class GalleryImageAdapter(private val itemList: List<Image>) : RecyclerView
.Adapter<GalleryImageAdapter.ViewHolder>() {
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
            val imgUrl = image.url
             if (imgUrl?.substring(0, 4).equals("http")) {
              // load image from http
              GlideApp.with(context!!)
                      .load(image.url)
                      .centerCrop()
                      .placeholder(R.drawable.ic_image_place_holder) //5
                      .error(R.drawable.ic_broken_image) //6
                      .fallback(R.drawable.ic_no_image) //7
                      .diskCacheStrategy(DiskCacheStrategy.ALL)
                      .into(binding.ivGalleryImage)
            }
            if (imgUrl?.substring(0, 4).equals("file")) {
              val uri: Uri = Uri.parse(imgUrl)
              val element: String? = uri.getLastPathSegment()
              var file: File? = null
              if (imgUrl?.contains("DCIM") == true) {
                file = File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM).toString(), element )
              }
              if (imgUrl?.contains("Pictures") == true) {
                file = File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).toString(), element )
              }
              GlideApp.with(context!!)
                .asBitmap()
                .load(file)
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
