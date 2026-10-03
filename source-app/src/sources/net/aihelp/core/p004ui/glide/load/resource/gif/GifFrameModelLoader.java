package net.aihelp.core.p004ui.glide.load.resource.gif;

import net.aihelp.core.p004ui.glide.Priority;
import net.aihelp.core.p004ui.glide.gifdecoder.GifDecoder;
import net.aihelp.core.p004ui.glide.load.data.DataFetcher;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;

class GifFrameModelLoader implements ModelLoader<GifDecoder, GifDecoder> {
    GifFrameModelLoader() {
    }

    @Override
    public DataFetcher<GifDecoder> getResourceFetcher(GifDecoder gifDecoder, int i, int i2) {
        return new GifFrameDataFetcher(gifDecoder);
    }

    private static class GifFrameDataFetcher implements DataFetcher<GifDecoder> {
        private final GifDecoder decoder;

        @Override
        public void cancel() {
        }

        @Override
        public void cleanup() {
        }

        public GifFrameDataFetcher(GifDecoder gifDecoder) {
            this.decoder = gifDecoder;
        }

        @Override
        public GifDecoder loadData(Priority priority) {
            return this.decoder;
        }

        @Override
        public String getId() {
            return String.valueOf(this.decoder.getCurrentFrameIndex());
        }
    }
}
