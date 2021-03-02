package com.getcapacitor.community.media.photoviewer;

import android.util.Log;

import com.getcapacitor.JSObject;
import com.getcapacitor.PluginCall;

public class RetHandler {
    private static final String TAG = RetHandler.class.getName();

    /**
     * RetResult Method
     * Create and return the capSQLiteResult object
     * @param call
     * @param res
     * @param message
     */
    public void retResult(PluginCall call, Boolean res, String message) {
        JSObject ret = new JSObject();
        if (message != null) {
            ret.put("message", message);
            Log.v(TAG, "*** ERROR " + message);
            call.reject(message);
            return;
        }
        if (res != null) {
            ret.put("result", res);
            call.resolve(ret);
            return;
        } else {
            String msg = "Show: res must be defined";
            ret.put("message", msg);
            Log.v(TAG, "*** ERROR " + msg);
            call.reject(message);
        }

    }
}
