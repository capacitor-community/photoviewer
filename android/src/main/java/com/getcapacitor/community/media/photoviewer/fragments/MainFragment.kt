package com.getcapacitor.community.media.photoviewer.fragments

//import android.widget.Toast
import android.content.Context
import android.content.res.Configuration
import android.os.Bundle
import android.util.Log
import android.view.KeyEvent
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
    var mContainer: ViewGroup? = null
    lateinit var mInflater: LayoutInflater

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
        mInflater = inflater
        if (container != null) {
            mContainer  = container
            val view: View = initializeView()
            activity?.runOnUiThread( java.lang.Runnable {
                view.isFocusableInTouchMode = true;
                view.requestFocus();
                view.setOnKeyListener(object: View.OnKeyListener {
                    override fun onKey(v: View?, keyCode: Int, event: KeyEvent): Boolean {
                        // if the event is a key down event on the enter button
                        if (event.action == KeyEvent.ACTION_DOWN &&
                            keyCode == KeyEvent.KEYCODE_BACK
                        ) {
                            backPressed()
                            return true
                        }
                        return false
                    }
                })
            })

            return view
        }
        return null
    }
    private fun initializeView(): View {
        if (mContainer != null) {
            mContainer?.removeAllViewsInLayout()
        }
        // Inflate the layout for this fragment
        val binding = MainFragmentBinding.inflate(mInflater, mContainer, false)
        mainFragmentBinding = binding
        galleryAdapter = GalleryImageAdapter(imageList)
        galleryAdapter.listener = this
        // init recyclerview
        appContext = this.requireContext()
        val orientation: Int = resources.configuration.orientation
        Log.d(TAG, "orientation: $orientation")
        if(orientation == Configuration.ORIENTATION_PORTRAIT) {
            Log.d(TAG, "orientation Portrait")
        } else {
            Log.d(TAG, "orientation Landscape")
        }
        recyclerViewLayoutManager = if (orientation == Configuration.ORIENTATION_PORTRAIT) {
            GridLayoutManager(appContext, spanCount, GridLayoutManager.VERTICAL, false)
        } else {
            GridLayoutManager(appContext, spanCount + 1,
                GridLayoutManager.VERTICAL, false)
        }
        binding.recyclerView.layoutManager = recyclerViewLayoutManager;
        binding.recyclerView.adapter = galleryAdapter
        galleryAdapter.notifyDataSetChanged()
        Log.d(TAG, "> options: $options")

        return binding.root
    }
    private fun backPressed() {
        activity?.supportFragmentManager?.beginTransaction()?.remove(this)?.commit();
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        Log.d(TAG, "$$ onConfigurationChanged ${newConfig.orientation}")
        val view: View = initializeView()
        mContainer?.addView(view)
        super.onConfigurationChanged(newConfig)
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