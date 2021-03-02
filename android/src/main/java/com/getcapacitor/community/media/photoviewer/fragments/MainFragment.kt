package com.getcapacitor.community.media.photoviewer.fragments

import android.content.Context
//import android.widget.Toast
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.getcapacitor.community.media.photoviewer.adapter.GalleryImageAdapter
import com.getcapacitor.community.media.photoviewer.adapter.GalleryImageClickListener
import com.getcapacitor.community.media.photoviewer.adapter.Image
import com.getcapacitor.community.media.photoviewer.databinding.MainFragmentBinding

class MainFragment : Fragment() , GalleryImageClickListener {
    private var mainFragmentBinding: MainFragmentBinding? = null
    private val SPAN_COUNT = 3
    private var imageList = ArrayList<Image>()
    private var transformer: String = "zoom"
    lateinit var galleryAdapter: GalleryImageAdapter
    var recyclerViewLayoutManager: RecyclerView.LayoutManager? = null
    lateinit var  appContext: Context

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val binding = MainFragmentBinding.inflate(inflater, container, false)
        mainFragmentBinding = binding
        imageList = arguments?.getSerializable("images") as ArrayList<Image>
        transformer = requireArguments().getString("transformer").toString()
        galleryAdapter = GalleryImageAdapter(imageList)
        galleryAdapter.listener = this
        // init recyclerview
        appContext = this.requireContext()
        recyclerViewLayoutManager = GridLayoutManager(appContext, SPAN_COUNT, GridLayoutManager
                                                      .VERTICAL, false)
        binding.recyclerView.layoutManager = recyclerViewLayoutManager;
        binding.recyclerView.adapter = galleryAdapter
        galleryAdapter.notifyDataSetChanged()

        return binding.root
    }
    override fun onDestroyView() {
        mainFragmentBinding = null
        super.onDestroyView()
    }

    override fun onClick(position: Int) {
        // handle click of image
        val bundle = Bundle()
        bundle.putSerializable("images", imageList)
        bundle.putInt("position", position)
        val fragmentTransaction = parentFragmentManager.beginTransaction()
        val galleryFragment = GalleryFullscreenFragment()
        galleryFragment.arguments = bundle
        galleryFragment.setStyle( DialogFragment.STYLE_NO_TITLE, android.R.style.Theme );
        galleryFragment.show(fragmentTransaction, "gallery")

    }

}