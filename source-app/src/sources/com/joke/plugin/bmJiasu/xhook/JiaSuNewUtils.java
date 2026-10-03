package com.joke.plugin.bmJiasu.xhook;

import android.content.Context;
import com.cheatfirst.cheatspeed.CheatPlusPlus;
import com.joke.speedfloatingball.utils.MLog;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;

public final class JiaSuNewUtils {
    private static final List<String> INTERESTING_LIBRARY_NAMES = new ArrayList();
    private final Context context;
    private boolean initialized;

    static {
        INTERESTING_LIBRARY_NAMES.add("libunity.so");
    }

    public JiaSuNewUtils(Context context) {
        this.context = context == null ? null : context.getApplicationContext();
    }

    public synchronized void modifySpeed(long speed) {
        if (this.context == null) {
            return;
        }
        try {
            if (!this.initialized) {
                initialize(this.context);
                this.initialized = true;
            }
            CheatPlusPlus.ioctl(1002, String.valueOf(speed));
        } catch (Throwable e) {
            MLog.m2e(e);
        }
    }

    private void initialize(Context context) throws IOException {
        CheatPlusPlus.ioctl(1001, context.getPackageName());
        LinkedHashSet<String> pathSet = new LinkedHashSet<>();
        File nativeDir = new File(context.getApplicationInfo().nativeLibraryDir);
        if (nativeDir.exists()) {
            ArrayList<File> interestingLibraries = new ArrayList<>();
            for (String libraryName : INTERESTING_LIBRARY_NAMES) {
                File library = new File(nativeDir, libraryName);
                if (library.exists()) {
                    interestingLibraries.add(library);
                }
            }
            if (interestingLibraries.isEmpty()) {
                addPath(pathSet, nativeDir);
            } else {
                Iterator<File> it = interestingLibraries.iterator();
                while (it.hasNext()) {
                    addPath(pathSet, it.next());
                }
            }
        }
        pathSet.add(context.getPackageCodePath() + "!");
        String[] splitSourceDirs = context.getApplicationInfo().splitSourceDirs;
        if (splitSourceDirs != null) {
            for (String item : splitSourceDirs) {
                pathSet.add(item + "!");
            }
        }
        if (!pathSet.isEmpty()) {
            CheatPlusPlus.ioctl(1004, pathSet.toArray(new String[0]));
        }
    }

    private void addPath(LinkedHashSet<String> pathSet, File file) throws IOException {
        pathSet.add(file.getAbsolutePath());
        pathSet.add(file.getCanonicalPath());
    }
}
