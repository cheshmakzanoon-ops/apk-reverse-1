package net.aihelp.core.net.http.pojo;

public class ErrorEntity {
    private String code;
    private String msg;
    private int status;

    public int getStatus() {
        return this.status;
    }

    public String getMsg() {
        return this.msg;
    }

    public void setStatus(int i) {
        this.status = i;
    }

    public void setMsg(String str) {
        this.msg = str;
    }

    public String getCode() {
        return this.code;
    }

    public void setCode(String str) {
        this.code = str;
    }

    public ErrorEntity() {
    }

    public ErrorEntity(String str) {
        this.msg = str;
    }

    public String toString() {
        return "ErrorEntity{status=" + this.status + ", msg='" + this.msg + "', code='" + this.code + "'}";
    }
}
