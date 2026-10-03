package net.aihelp.utils;

import android.content.Context;
import android.text.TextUtils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.UUID;
import net.aihelp.config.AIHelpContext;

public class DeviceUuidFactory {
    private static final String INSTALLATION = "INSTALLATION";
    private static String sID;

    public static synchronized String m137id(Context context) {
        String str;
        File file;
        if (context == null) {
            context = AIHelpContext.getInstance().getContext();
            if (context == null) {
                String string = UUID.randomUUID().toString();
                sID = string;
                return string;
            }
            if (sID == null) {
                str = SpUtil.getInstance().get1_xDeviceId();
                file = new File(context.getFilesDir(), INSTALLATION);
                try {
                    if (file.exists()) {
                        sID = readInstallationFile(file);
                    } else if (!TextUtils.isEmpty(str)) {
                        sID = str;
                    } else {
                        writeInstallationFile(file);
                        sID = readInstallationFile(file);
                    }
                } catch (Exception unused) {
                    String str2 = "" + UUID.randomUUID().toString();
                    sID = str2;
                    return str2;
                }
            }
            return sID;
        }
        if (sID == null) {
            str = SpUtil.getInstance().get1_xDeviceId();
            file = new File(context.getFilesDir(), INSTALLATION);
            if (file.exists()) {
                sID = readInstallationFile(file);
            } else if (!TextUtils.isEmpty(str)) {
                sID = str;
            } else {
                writeInstallationFile(file);
                sID = readInstallationFile(file);
            }
        }
        return sID;
        throw th;
    }

    private static String readInstallationFile(File file) throws IOException {
        RandomAccessFile randomAccessFile = new RandomAccessFile(file, "r");
        byte[] bArr = new byte[(int) randomAccessFile.length()];
        randomAccessFile.readFully(bArr);
        randomAccessFile.close();
        return new String(bArr);
    }

    private static void writeInstallationFile(File file) throws IOException {
        FileOutputStream fileOutputStream = new FileOutputStream(file);
        fileOutputStream.write(UUID.randomUUID().toString().getBytes());
        fileOutputStream.close();
    }
}
