package com.getcapacitor.community.media.photoviewer.fragments

import android.content.Context
//import android.widget.Toast
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.getcapacitor.JSObject
import com.getcapacitor.community.media.photoviewer.adapter.GalleryImageAdapter
import com.getcapacitor.community.media.photoviewer.adapter.GalleryImageClickListener
import com.getcapacitor.community.media.photoviewer.adapter.Image
import com.getcapacitor.community.media.photoviewer.databinding.MainFragmentBinding

class MainFragment : Fragment() , GalleryImageClickListener {
    private val TAG = "MainFragment"
    private var mainFragmentBinding: MainFragmentBinding? = null
    private var spanCount = 3

    private var imageList = ArrayList<Image>()
    private var options = JSObject()
    lateinit var galleryAdapter: GalleryImageAdapter
    var recyclerViewLayoutManager: RecyclerView.LayoutManager? = null
    lateinit var  appContext: Context

    fun setImageList(imageList: ArrayList<Image>) {
        this.imageList = imageList
    }
    fun setOptions(options: JSObject) {
        this.options = options
        if(this.options.has("spancount")) this.spanCount = this.options
                .getInt("spancount")
    }

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val binding = MainFragmentBinding.inflate(inflater, container, false)
        mainFragmentBinding = binding

        galleryAdapter = GalleryImageAdapter(imageList)
        galleryAdapter.listener = this
        // init recyclerview
        appContext = this.requireContext()
        recyclerViewLayoutManager = GridLayoutManager(appContext, spanCount, GridLayoutManager
                .VERTICAL, false)
        binding.recyclerView.layoutManager = recyclerViewLayoutManager;
        binding.recyclerView.adapter = galleryAdapter
        galleryAdapter.notifyDataSetChanged()
        Log.d(TAG, "> options: $options")

        return binding.root
    }
    override fun onDestroyView() {
        mainFragmentBinding = null
        clearCache()
        super.onDestroyView()
    }

    override fun onClick(position: Int) {
        val galleryFragment = GalleryFullscreenFragment()
        galleryFragment.setImageList(imageList)
        galleryFragment.setPosition(position)
        galleryFragment.setOptions(options)

        val fragmentTransaction = parentFragmentManager.beginTransaction()
        galleryFragment.setStyle(DialogFragment.STYLE_NO_TITLE, android.R.style.Theme);
        galleryFragment.show(fragmentTransaction, "gallery")

    }
    private fun clearCache() {
        Thread(Runnable {
            Glide.get(appContext).clearDiskCache()
        }).start()
        Glide.get(appContext).clearMemory()
    }

}