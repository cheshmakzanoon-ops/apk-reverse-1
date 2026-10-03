package net.aihelp.core.p004ui.glide.load.engine;

import net.aihelp.core.p004ui.glide.load.Encoder;
import net.aihelp.core.p004ui.glide.load.Key;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;
import net.aihelp.core.p004ui.glide.load.Transformation;
import net.aihelp.core.p004ui.glide.load.resource.transcode.ResourceTranscoder;

class EngineKeyFactory {
    EngineKeyFactory() {
    }

    public EngineKey buildKey(String str, Key key, int i, int i2, ResourceDecoder resourceDecoder, ResourceDecoder resourceDecoder2, Transformation transformation, ResourceEncoder resourceEncoder, ResourceTranscoder resourceTranscoder, Encoder encoder) {
        return new EngineKey(str, key, i, i2, resourceDecoder, resourceDecoder2, transformation, resourceEncoder, resourceTranscoder, encoder);
    }
}
