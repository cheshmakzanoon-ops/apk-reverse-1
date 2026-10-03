package com.gme.liteav.extensions;

import android.content.res.AssetManager;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.util.LiteavLog;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class AssetsUtils {
    public static boolean hasAssetFile(String str) {
        try {
            InputStream inputStreamOpen = ContextUtils.getApplicationAssets().open(str);
            boolean z = inputStreamOpen != null;
            inputStreamOpen.close();
            return z;
        } catch (IOException e) {
            LiteavLog.m998i("virtual-background", "hasAssetFile error: " + e.getMessage());
            return false;
        }
    }

    public static boolean copyAssetFile(String str, String str2) {
        AssetManager applicationAssets = ContextUtils.getApplicationAssets();
        try {
            File file = new File(str2);
            if (!file.exists()) {
                file.mkdirs();
            }
            byte[] bArr = new byte[1024];
            InputStream inputStreamOpen = applicationAssets.open(str);
            File file2 = new File(str2 + File.separator + str + ".tmp");
            if (!file2.exists()) {
                file2.createNewFile();
            }
            FileOutputStream fileOutputStream = new FileOutputStream(file2);
            while (true) {
                int i = inputStreamOpen.read(bArr);
                if (i == -1) {
                    break;
                }
                fileOutputStream.write(bArr, 0, i);
            }
            fileOutputStream.flush();
            inputStreamOpen.close();
            fileOutputStream.close();
            if (file2.renameTo(new File(str2 + File.separator + str))) {
                return true;
            }
            file2.delete();
            return false;
        } catch (IOException e) {
            LiteavLog.m998i("virtual-background", "copyAssetFile error: " + e.getMessage());
            return false;
        }
    }
}
