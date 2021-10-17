package com.getcapacitor.community.media.photoviewer.fragments

import android.content.Context
import android.os.Bundle
import android.view.*
import androidx.fragment.app.DialogFragment
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.getcapacitor.community.media.photoviewer.R
import com.getcapacitor.community.media.photoviewer.databinding.FragmentTouchviewBinding
import com.getcapacitor.community.media.photoviewer.helper.CallbackListener
import com.getcapacitor.community.media.photoviewer.helper.GlideApp
import com.ortiz.touchview.TouchImageView


class TouchViewFragment(private val callbackListener: CallbackListener): DialogFragment() {
    private val TAG = "TouchViewFragment"
    private var tvFragmentBinding: FragmentTouchviewBinding? = null
    lateinit var ivTouchImage: TouchImageView
    lateinit var  appContext: Context
    private var url: String = ""

    fun setUrl(url: String) {
        this.url = url
    }

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {

        // Inflate the layout for this fragment
        val binding = FragmentTouchviewBinding
                .inflate(inflater, container, false)
        tvFragmentBinding = binding
        ivTouchImage = binding.ivTouchImage
        appContext = this.requireContext()

        GlideApp.with(appContext)
                .load(url)
                .fitCenter()
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .into(ivTouchImage)
        container?.addView(binding.root)
        val clickListener = View.OnClickListener { viewFS ->
            when (viewFS.getId()) {
                R.id.ivTouchImage -> {
                    callbackListener.onMenuToggle()
                    dismiss()
                }
            }
        }

        ivTouchImage.setOnClickListener(clickListener)
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