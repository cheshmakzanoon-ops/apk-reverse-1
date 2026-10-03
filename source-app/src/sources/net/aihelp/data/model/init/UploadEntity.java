package net.aihelp.data.model.init;

public class UploadEntity {

    public static class ImageResult {
        private String fileName;
        private String time;
        private String url;

        public String getFileName() {
            return this.fileName;
        }

        public void setFileName(String str) {
            this.fileName = str;
        }

        public String getUrl() {
            return this.url;
        }

        public void setUrl(String str) {
            this.url = str;
        }

        public String getTime() {
            return this.time;
        }

        public void setTime(String str) {
            this.time = str;
        }

        public String toString() {
            return "ImageResult{fileName='" + this.fileName + "', url='" + this.url + "', time='" + this.time + "'}";
        }
    }

    public static class FileResult {
        private int code;
        private String data;
        private String msg;

        public int getCode() {
            return this.code;
        }

        public void setCode(int i) {
            this.code = i;
        }

        public String getMsg() {
            return this.msg;
        }

        public void setMsg(String str) {
            this.msg = str;
        }

        public String getData() {
            return this.data;
        }

        public void setData(String str) {
            this.data = str;
        }

        public String toString() {
            return "VideoResult{code=" + this.code + ", msg='" + this.msg + "', data='" + this.data + "'}";
        }
    }
}
