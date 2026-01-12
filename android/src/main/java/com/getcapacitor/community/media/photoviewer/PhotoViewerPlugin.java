package com.getcapacitor.community.media.photoviewer;

import android.Manifest;
import android.os.Build;
import androidx.appcompat.app.AppCompatActivity;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.PermissionState;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import com.getcapacitor.annotation.PermissionCallback;
import com.getcapacitor.community.media.photoviewer.Notifications.MyRunnable;
import com.getcapacitor.community.media.photoviewer.Notifications.NotificationCenter;
import org.json.JSONException;
import org.json.JSONObject;

@CapacitorPlugin(
    name = "PhotoViewer",
    permissions = {
        @Permission(alias = PhotoViewerPlugin.MEDIAIMAGES, strings = { Manifest.permission.READ_MEDIA_IMAGES }),
        @Permission(alias = PhotoViewerPlugin.READ_EXTERNAL_STORAGE, strings = { Manifest.permission.READ_EXTERNAL_STORAGE })
    }
)
public class PhotoViewerPlugin extends Plugin {

    // Permission alias constants
    private static final String PERMISSION_DENIED_ERROR = "Unable to access media images, user denied permission request";
    static final String MEDIAIMAGES = "images";
    static final String READ_EXTERNAL_STORAGE = "read_external_storage";

    private PhotoViewer implementation;
    private RetHandler rHandler = new RetHandler();
    private Boolean isPermissions = false;

    @Override
    public void load() {
        implementation = new PhotoViewer(getContext(), getBridge());
    }

    @PermissionCallback
    private void imagesPermissionsCallback(PluginCall call) {
        if (Build.VERSION.SDK_INT >= 33) {
            if (getPermissionState(MEDIAIMAGES) == PermissionState.GRANTED) {
                isPermissions = true;
                show(call);
            } else {
                call.reject(PERMISSION_DENIED_ERROR);
            }
        } else if (Build.VERSION.SDK_INT >= 29) {
            if (getPermissionState(READ_EXTERNAL_STORAGE) == PermissionState.GRANTED) {
                isPermissions = true;
                show(call);
            } else {
                call.reject(PERMISSION_DENIED_ERROR);
            }
        }
    }

    private boolean isImagesPermissions() {
        if (Build.VERSION.SDK_INT >= 33) {
            return getPermissionState(MEDIAIMAGES) == PermissionState.GRANTED;
        } else if (Build.VERSION.SDK_INT >= 29) {
            return getPermissionState(READ_EXTERNAL_STORAGE) == PermissionState.GRANTED;
        }
        return true;
    }

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @PluginMethod
    public void show(PluginCall call) {
        if (!call.getData().has("images")) {
            String msg = "Show: Must provide an image list";
            rHandler.retResult(call, false, msg);
            return;
        }
        JSArray images = call.getArray("images");
        if (images == null || images.length() == 0) {
            String msg = "Show: Must provide a non-empty list of image";
            rHandler.retResult(call, false, msg);
            return;
        }
        JSObject options = new JSObject();
        if (call.getData().has("options")) {
            options = call.getObject("options", new JSObject());
        }
        String mode = "one";
        if (call.getData().has("mode")) {
            mode = call.getString("mode");
        }
        Integer startFrom = 0;
        if (call.getData().has("startFrom")) {
            startFrom = call.getInt("startFrom");
        }
        // Check if requires permissions
        boolean isRequired = false;
        for (int i = 0; i < images.length(); i++) {
            try {
                JSONObject obj = images.getJSONObject(i);
                String url = obj.getString("url");
                if (url.startsWith("file:") || url.contains("_capacitor_file_")) {
                    isRequired = true;
                    break;
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        if (isRequired) {
            // Check for permissions to access media image files
            if (!isImagesPermissions()) {
                this.bridge.saveCall(call);
                requestAllPermissions(call, "imagesPermissionsCallback");
            } else {
                isPermissions = true;
            }
        } else {
            isPermissions = true;
        }
        if (isPermissions) {
            try {
                JSObject finalOptions = options;
                String finalMode = mode;
                Integer finalStartFrom = startFrom;
                AddObserversToNotificationCenter();

                bridge
                    .getActivity()
                    .runOnUiThread(() -> {
                        try {
                            if (images.length() <= 1 && (finalMode.equals("gallery") || finalMode.equals("slider"))) {
                                String msg = "Show : imageList must be greater that one ";
                                msg += "for Mode " + finalMode;
                                rHandler.retResult(call, false, msg);
                                return;
                            }
                            implementation.show(images, finalMode, finalStartFrom, finalOptions);
                            rHandler.retResult(call, true, null);
                        } catch (Exception e) {
                            rHandler.retResult(call, false, e.getMessage());
                        }
                    });
            } catch (Exception e) {
                String msg = "Show: " + e.getMessage();
                rHandler.retResult(call, false, msg);
            }
        }
    }

    @PluginMethod
    public void saveImageFromHttpToInternal(PluginCall call) {
        call.unimplemented("Not implemented on Android.");
    }

    @PluginMethod
    public void getInternalImagePaths(PluginCall call) {
        call.unimplemented("Not implemented on Android.");
    }

    private void AddObserversToNotificationCenter() {
        NotificationCenter.defaultCenter().addMethodForNotification(
            "photoviewerExit",
            new MyRunnable() {
                @Override
                public void run() {
                    JSObject data = new JSObject();
                    data.put("result", this.getInfo().get("result"));
                    data.put("imageIndex", this.getInfo().get("imageIndex"));
                    data.put("message", this.getInfo().get("message"));
                    NotificationCenter.defaultCenter().removeAllNotifications();
                    notifyListeners("jeepCapPhotoViewerExit", data);
                    return;
                }
            }
        );
    }
}
