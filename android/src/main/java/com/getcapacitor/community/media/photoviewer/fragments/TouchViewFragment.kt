package com.getcapacitor.community.media.photoviewer.fragments

import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.util.Log
import android.view.*
import android.widget.RelativeLayout
import androidx.core.view.GestureDetectorCompat
import androidx.fragment.app.DialogFragment
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.getcapacitor.JSObject
import com.getcapacitor.community.media.photoviewer.databinding.FragmentTouchviewBinding
import com.getcapacitor.community.media.photoviewer.helper.BackgroundColor
import com.getcapacitor.community.media.photoviewer.helper.CallbackListener
import com.getcapacitor.community.media.photoviewer.helper.GlideApp
import com.ortiz.touchview.TouchImageView
import java.io.File


class TouchViewFragment(private val callbackListener: CallbackListener): DialogFragment() {
    private val TAG = "TouchViewFragment"
    private var tvFragmentBinding: FragmentTouchviewBinding? = null
    lateinit var ivTouchImage: TouchImageView
    lateinit var  appContext: Context
    private var url: String = ""
    private lateinit var rlLayout: RelativeLayout
    private lateinit var mDetector: GestureDetectorCompat
    private var options = JSObject()
    private var backgroundColor: String = "black"

    fun setUrl(url: String) {
        this.url = url
    }
    fun setBackgroundColor(color: String) {
        this.backgroundColor = color
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        // Inflate the layout for this fragment
        val binding = FragmentTouchviewBinding
            .inflate(inflater, container, false)
        tvFragmentBinding = binding
        rlLayout = binding.rlTouchImage
        val mBackgroundColor = BackgroundColor()
        rlLayout.setBackgroundResource(mBackgroundColor.setBackColor(backgroundColor))
        ivTouchImage = binding.ivTouchImage
        appContext = this.requireContext()

        if (url.substring(0, 4).equals("http")) {
          // load image from http
          GlideApp.with(appContext)
            .load(url)
            .fitCenter()
            .diskCacheStrategy(DiskCacheStrategy.ALL)
            .into(ivTouchImage)
        }
        if (url.substring(0, 4).equals("file")) {
          val uri: Uri = Uri.parse(url)
          val element: String? = uri.getLastPathSegment()
          var file: File? = null
          if (url.contains("DCIM") == true) {
            file = File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM).toString(), element )
          }
          if (url.contains("Pictures") == true) {
            file = File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).toString(), element )
          }
          GlideApp.with(appContext)
            .asBitmap()
            .load(file)
            .fitCenter()
            .diskCacheStrategy(DiskCacheStrategy.ALL)
            .into(ivTouchImage)
        }

        container?.addView(binding.root)

        return binding.root
    }

    override fun onResume() {
        // Get existing layout params for the window
        val params: ViewGroup.LayoutParams = dialog!!.window!!.attributes
        // Assign window properties to fill the parent
        params.width = WindowManager.LayoutParams.MATCH_PARENT
        params.height = WindowManager.LayoutParams.MATCH_PARENT
        dialog!!.window!!.attributes = params as WindowManager.LayoutParams
        dialog!!.setOnKeyListener { _, keyCode, _ ->
            if (keyCode == KeyEvent.KEYCODE_BACK) {
                callbackListener.onMenuToggle()
                dismiss()
                true // pretend we've processed it
            } else false // pass on to be processed as normal
        }
        // Call super onResume after sizing
        super.onResume()
    }
    override fun onDestroyView() {
        tvFragmentBinding = null
        super.onDestroyView()
    }

}
