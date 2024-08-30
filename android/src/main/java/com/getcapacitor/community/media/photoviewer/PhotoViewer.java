package com.getcapacitor.community.media.photoviewer;

import android.content.Context;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import com.getcapacitor.Bridge;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.community.media.photoviewer.adapter.Image;
import com.getcapacitor.community.media.photoviewer.fragments.GalleryFullscreenFragment;
import com.getcapacitor.community.media.photoviewer.fragments.ImageFragment;
import com.getcapacitor.community.media.photoviewer.fragments.MainFragment;
import java.util.ArrayList;
import org.json.JSONException;
import org.json.JSONObject;

public class PhotoViewer extends BridgeActivity {

    private static final String TAG = "CapacitorPhotoViewer";
    private Context context;
    private int frameLayoutViewId = 8256;
    private Bridge bridge;

    PhotoViewer(Context context, Bridge bridge) {
        this.context = context;
        this.bridge = bridge;
    }

    public String echo(String value) {
        return value;
    }

    public void show(JSArray images, String mode, Integer startFrom, JSObject options) throws Exception {
        try {
            ArrayList<Image> imageList = convertJSArrayToImageList(images);
            Integer stFrom = startFrom > imageList.size() - 1 ? imageList.size() - 1 : startFrom;
            if (imageList.size() > 1 && mode.equals("gallery")) {
                // create the main fragment
                createMainFragment(imageList, options);
            } else if (mode.equals("one")) {
                createImageFragment(imageList, stFrom, options);
            } else if (mode.equals("slider")) {
                createSliderFragment(imageList, stFrom, options);
            }
            return;
        } catch (JSONException e) {
            throw new Exception(e.getMessage());
        }
    }

    private void createMainFragment(ArrayList<Image> imageList, JSObject options) throws Exception {
        try {
            // Initialize a new FrameLayout as container for fragment
            FrameLayout frameLayoutView = new FrameLayout(context);
            frameLayoutView.setId(frameLayoutViewId);
            FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            );
            // Apply the Layout Parameters to frameLayout
            frameLayoutView.setLayoutParams(lp);
            // Add FrameLayout to bridge_layout_main
            ((ViewGroup) bridge.getWebView().getParent()).addView(frameLayoutView);
            final MainFragment mainFragment = new MainFragment();
            mainFragment.setImageList(imageList);
            mainFragment.setOptions(options);

            bridge
                .getActivity()
                .getSupportFragmentManager()
                .beginTransaction()
                .replace(frameLayoutViewId, mainFragment, "mainfragment")
                .commit();
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    private void createImageFragment(ArrayList<Image> imageList, Integer startFrom, JSObject options) throws Exception {
        try {
            // Initialize a new FrameLayout as container for fragment
            FrameLayout frameLayoutView = new FrameLayout(context);
            frameLayoutView.setId(frameLayoutViewId);
            FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            );
            // Apply the Layout Parameters to frameLayout
            frameLayoutView.setLayoutParams(lp);
            // Add FrameLayout to bridge_layout_main
            ((ViewGroup) bridge.getWebView().getParent()).addView(frameLayoutView);
            final ImageFragment imageFragment = new ImageFragment();
            imageFragment.setImage(imageList.get(startFrom));
            imageFragment.setOptions(options);
            imageFragment.setStartFrom(startFrom);

            bridge
                .getActivity()
                .getSupportFragmentManager()
                .beginTransaction()
                .replace(frameLayoutViewId, imageFragment, "imagefragment")
                .commit();
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    private void createSliderFragment(ArrayList<Image> imageList, Integer startFrom, JSObject options) throws Exception {
        try {
            // Initialize a new FrameLayout as container for fragment
            FrameLayout frameLayoutView = new FrameLayout(context);
            frameLayoutView.setId(frameLayoutViewId);
            FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            );
            // Apply the Layout Parameters to frameLayout
            frameLayoutView.setLayoutParams(lp);
            // Add FrameLayout to bridge_layout_main
            ((ViewGroup) bridge.getWebView().getParent()).addView(frameLayoutView);
            final GalleryFullscreenFragment galleryFragment = new GalleryFullscreenFragment();
            galleryFragment.setImageList(imageList);
            galleryFragment.setStartFrom(startFrom);
            galleryFragment.setMode("slider");
            galleryFragment.setOptions(options);
            galleryFragment.setStartFrom(startFrom);

            bridge
                .getActivity()
                .getSupportFragmentManager()
                .beginTransaction()
                .replace(frameLayoutViewId, galleryFragment, "gallery")
                .commit();
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    private ArrayList<Image> convertJSArrayToImageList(JSArray jsArray) throws JSONException {
        ArrayList<Image> list = new ArrayList<Image>();
        for (int i = 0; i < jsArray.length(); i++) {
            if (jsArray.isNull(i)) {
                list.add(null);
            } else {
                Object obj = jsArray.get(i);
                String url = ((JSONObject) obj).getString("url");
                String title = ((JSONObject) obj).optString("title", null);
                list.add(new Image(url, title));
            }
        }
        return list;
    }
}
