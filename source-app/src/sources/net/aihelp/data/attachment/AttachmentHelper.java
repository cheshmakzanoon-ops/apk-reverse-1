package net.aihelp.data.attachment;

import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.text.TextUtils;
import android.webkit.MimeTypeMap;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.UUID;
import net.aihelp.common.CustomConfig;

public class AttachmentHelper {
    public static Intent getIntentForMedia(int i) {
        Intent intent = new Intent("android.intent.action.OPEN_DOCUMENT");
        intent.addCategory("android.intent.category.OPENABLE");
        intent.putExtra("android.intent.extra.LOCAL_ONLY", true);
        intent.addFlags(1);
        return setupMimeTypeForIntent(intent, i);
    }

    public static Intent setupMimeTypeForIntent(Intent intent, int i) {
        String strTrim;
        if (i == 1) {
            strTrim = getMIMEType(String.format("%s,%s", CustomConfig.UploadLimit.imageTypes, CustomConfig.UploadLimit.videoTypes)).trim();
        } else if (i == 2) {
            strTrim = getMIMEType(CustomConfig.UploadLimit.fileTypes).trim();
        } else if (i != 3) {
            strTrim = "";
        } else {
            strTrim = getMIMEType(CustomConfig.UploadLimit.rpaAttachmentTypes).trim();
        }
        if (!TextUtils.isEmpty(strTrim)) {
            intent.setType(strTrim);
            intent.putExtra("android.intent.extra.MIME_TYPES", strTrim.split(" "));
        }
        return intent;
    }

    public static String getMIMEType(String str) {
        if (!TextUtils.isEmpty(str)) {
            StringBuilder sb = new StringBuilder();
            String[] strArrSplit = str.split(",");
            if (strArrSplit.length > 0) {
                for (String str2 : strArrSplit) {
                    if (!TextUtils.isEmpty(str2)) {
                        String mimeTypeFromExtension = MimeTypeMap.getSingleton().getMimeTypeFromExtension(str2);
                        if (!TextUtils.isEmpty(mimeTypeFromExtension)) {
                            sb.append(mimeTypeFromExtension);
                            sb.append(" ");
                        }
                    }
                }
                return sb.toString();
            }
            return "image/jpeg image/png";
        }
        return "image/jpeg image/png";
    }

    public static File getCopiedUriFile(Context context, Uri uri) {
        int columnIndex;
        try {
            context.grantUriPermission(context.getPackageName(), uri, 1);
            String string = UUID.randomUUID().toString();
            Cursor cursorQuery = context.getContentResolver().query(uri, null, null, null, null);
            if (cursorQuery != null && cursorQuery.moveToFirst() && (columnIndex = cursorQuery.getColumnIndex("_display_name")) > 0) {
                string = cursorQuery.getString(columnIndex);
            }
            File file = new File(context.getCacheDir(), string);
            if (file.exists()) {
                return file;
            }
            InputStream inputStreamOpenInputStream = context.getContentResolver().openInputStream(uri);
            FileOutputStream fileOutputStream = new FileOutputStream(file);
            byte[] bArr = new byte[8192];
            while (true) {
                int i = inputStreamOpenInputStream.read(bArr);
                if (i == -1) {
                    break;
                }
                fileOutputStream.write(bArr, 0, i);
            }
            if (cursorQuery != null) {
                cursorQuery.close();
            }
            inputStreamOpenInputStream.close();
            fileOutputStream.close();
            return file;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
