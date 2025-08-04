package com.getcapacitor.community.media.photoviewer.Notifications;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class NotificationCenter {

    //static reference for singleton
    private static NotificationCenter _instance;

    private HashMap<String, ArrayList<MyRunnable>> registeredObjects;

    //default c'tor for singleton
    private NotificationCenter() {
        registeredObjects = new HashMap<String, ArrayList<MyRunnable>>();
    }

    //returning the reference
    public static synchronized NotificationCenter defaultCenter() {
        if (_instance == null) _instance = new NotificationCenter();
        return _instance;
    }

    public synchronized void addMethodForNotification(String notificationName, MyRunnable r) {
        ArrayList<MyRunnable> list = registeredObjects.get(notificationName);
        if (list == null) {
            list = new ArrayList<MyRunnable>();
            registeredObjects.put(notificationName, list);
        }
        list.add(r);
    }

    public synchronized void removeMethodForNotification(String notificationName, MyRunnable r) {
        ArrayList<MyRunnable> list = registeredObjects.get(notificationName);
        if (list != null) {
            list.remove(r);
        }
    }

    public synchronized void removeAllNotifications() {
        Iterator<Map.Entry<String, ArrayList<MyRunnable>>> entryIterator = registeredObjects.entrySet().iterator();
        while (entryIterator.hasNext()) {
            Map.Entry<String, ArrayList<MyRunnable>> entry = entryIterator.next();
            ArrayList<MyRunnable> value = entry.getValue();
            if (!value.isEmpty()) {
                removeMethodForNotification(entry.getKey(), value.get(0));
            }
            entryIterator.remove();
        }
    }

    public synchronized void postNotification(String notificationName, Map<String, Object> _info) {
        ArrayList<MyRunnable> list = registeredObjects.get(notificationName);
        if (list != null) {
            ArrayList<MyRunnable> listCopy = new ArrayList<>(list);

            for (MyRunnable r : listCopy) {
                if (r != null) {
                    r.setInfo(_info);
                    r.run();
                }
            }
        }
    }
}
