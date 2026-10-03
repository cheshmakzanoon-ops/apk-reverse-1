package net.aihelp.core.p004ui.glide;

import java.io.File;
import net.aihelp.core.p004ui.glide.request.FutureTarget;
import net.aihelp.core.p004ui.glide.request.target.Target;

interface DownloadOptions {
    FutureTarget<File> downloadOnly(int i, int i2);

    <Y extends Target<File>> Y downloadOnly(Y y);
}
