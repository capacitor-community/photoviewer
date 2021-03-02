package com.getcapacitor.community.media.photoviewer.fragments

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.*
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.TextView
import android.widget.Toast
import androidx.core.content.FileProvider
import androidx.fragment.app.Fragment
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.target.Target
import com.bumptech.glide.request.transition.Transition
import com.getcapacitor.community.media.photoviewer.BuildConfig
import com.getcapacitor.community.media.photoviewer.R
import com.getcapacitor.community.media.photoviewer.adapter.Image
import com.getcapacitor.community.media.photoviewer.databinding.FragmentScreenSlidePageBinding
import com.getcapacitor.community.media.photoviewer.helper.GlideApp
import com.ortiz.touchview.TouchImageView
import java.io.File
import java.io.FileOutputStream
import java.io.IOException


class ScreenSlidePageFragment() : Fragment() {
    lateinit var tvGalleryTitle: TextView
    lateinit var ivFullscreenImage: TouchImageView
    lateinit var  appContext: Context
    private var tmpImage: File? = null
    lateinit var binding: FragmentScreenSlidePageBinding
    lateinit var image: Image
    companion object {
        const val ARG_IMAGE = "image"

        fun getInstance(image: Image): Fragment {
            val ScreenSlidePageFragment = ScreenSlidePageFragment()
            val bundle = Bundle()
            bundle.putParcelable(ARG_IMAGE, image)
            ScreenSlidePageFragment.arguments = bundle
            return ScreenSlidePageFragment
        }
    }


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        binding = FragmentScreenSlidePageBinding
            .inflate(inflater, container, false)

        image = requireArguments().getParcelable<Image>(ARG_IMAGE)!!
        appContext = this.requireContext()

        tvGalleryTitle = binding.tvGalleryTitle
        ivFullscreenImage = binding.ivFullscreenImage
            tvGalleryTitle.text = image.title
            GlideApp.with(appContext)
                    .load(image.url)
                    .centerCrop()
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .into(ivFullscreenImage)
            container?.addView(binding.root)

        val share: ImageButton = binding.shareBtn
        val clickListener = View.OnClickListener { viewFS ->
            when (viewFS.getId()) {
                R.id.shareBtn -> {
                    shareImage(image)
                }

            }
        }
        share.setOnClickListener(clickListener)
        return binding.root
    }
    override fun onDestroyView() {
        deleteTmpImage()
        super.onDestroyView()
    }
    private fun deleteTmpImage() {
        if (tmpImage != null) {
            val path: String = tmpImage!!.absolutePath
            println("in onDestroy $path")
            tmpImage!!.delete()
        }

    }
    private fun shareImage(image:Image) {
        if (Build.VERSION.SDK_INT >= 24) {
            try {
                val m = StrictMode::class.java.getMethod("disableDeathOnFileUriExposure")
                m.invoke(null)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        // convert TouchImageView to Bitmap File and share
        deleteTmpImage()
        createTmpImageAndShare(image)
        return
    }
    private fun shareIntentCreation() {
        // create the shareIntent
        try {
            val uri: Uri = FileProvider.getUriForFile(requireContext(),
                BuildConfig.LIBRARY_PACKAGE_NAME + ".provider", tmpImage!!)

            val shareIntent = Intent()
            shareIntent.action = Intent.ACTION_SEND
            shareIntent.type = "\"image/*\""
            shareIntent.putExtra(Intent.EXTRA_STREAM, uri)

            shareIntent.addFlags(
                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                        Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                        Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
            startActivity(Intent.createChooser(shareIntent, "Share image via"))

        } catch (e: java.lang.Exception) {
            val toast = Toast.makeText(requireContext(), e.message, Toast.LENGTH_SHORT)
            toast.setGravity(Gravity.TOP, 0, 50)
            toast.show()
            e.printStackTrace()
        }

    }
    private fun createTmpImageAndShare(image: Image) {
        val fileName: String = "share_image_" + System.currentTimeMillis() + ".png"
        tmpImage = File(requireContext().filesDir, fileName)
        GlideApp.with(requireContext())
            .asBitmap()
            .load(image.url)
            .override(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL)
            .into(object : CustomTarget<Bitmap>(){
                override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                    try {
                        val out: FileOutputStream = FileOutputStream(tmpImage)
                        resource.compress(Bitmap.CompressFormat.PNG, 100, out)
                        out.close()
                        tmpImage!!.setReadable(true, false)
                        val toast = Toast.makeText(context!!, " created: $fileName", Toast.LENGTH_SHORT)
                        toast.setGravity(Gravity.TOP, 0, 50)
                        toast.show()
                        // share Intent creation
                        shareIntentCreation()
                        return
                    } catch (e: IOException) {
                        e.printStackTrace()
                        val toast = Toast.makeText(context!!, e.message, Toast.LENGTH_SHORT)
                        toast.setGravity(Gravity.TOP, 0, 50)
                        toast.show()
                        return
                    }
                }
                override fun onLoadCleared(placeholder: Drawable?) {
                }
            })

    }

}