package zendesk.guidekit.android.internal.data;

import dagger.internal.Factory;

public final class ArticleInMemoryDataSource_Factory implements Factory<ArticleInMemoryDataSource> {
    @Override
    public ArticleInMemoryDataSource get() {
        return newInstance();
    }

    public static ArticleInMemoryDataSource_Factory create() {
        return InstanceHolder.INSTANCE;
    }

    public static ArticleInMemoryDataSource newInstance() {
        return new ArticleInMemoryDataSource();
    }

    private static final class InstanceHolder {
        private static final ArticleInMemoryDataSource_Factory INSTANCE = new ArticleInMemoryDataSource_Factory();

        private InstanceHolder() {
        }
    }
}
