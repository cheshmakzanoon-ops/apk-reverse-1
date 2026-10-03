package net.aihelp.core.util.logger.table;

import android.provider.BaseColumns;

public interface LoggerTable {
    public static final String TABLE_NAME = "LOG_MESSAGES";

    public interface Columns extends BaseColumns {
        public static final String LEVEL = "LEVEL";
        public static final String MESSAGE = "MESSAGE";
        public static final String STACKTRACE = "STACKTRACE";
        public static final String TIMESTAMP = "TIMESTAMP";
    }
}
