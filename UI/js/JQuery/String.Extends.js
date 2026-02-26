String.prototype.encode = function() {
    if (this.length == 0) {
        return "";
    }
    var rs = this;
    rs = rs.replace(/&/g,"&amp;");
    rs = rs.replace(/</g,"&lt;");
    rs = rs.replace(/>/g,"&gt;");
    rs = rs.replace(/ /g,"&nbsp;");
    rs = rs.replace(/\'/g,"&#39;");
    rs = rs.replace(/\"/g,"&quot;");
    return rs;
}

String.prototype.decode = function() {
    if (this.length == 0) {
        return "";
    }
    var rs = this;
    rs = rs.replace(/&amp;/g,"&");
    rs = rs.replace(/&lt;/g,"<");
    rs = rs.replace(/&gt;/g,">");
    rs = rs.replace(/&nbsp;/g," ");
    rs = rs.replace(/&#39;/g,"\'");
    rs = rs.replace(/&quot;/g,"\"");
    return rs;
}