package net.aihelp.core.p004ui.glide.load.resource.file;

import java.io.File;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.engine.Resource;

public class FileDecoder implements ResourceDecoder<File, File> {
    @Override
    public Resource<File> decode(File file, int i, int i2) {
        return new FileResource(file);
    }

    @Override
    public String getId() {
        return "";
    }
}
