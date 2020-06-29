/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package prx.utils.checker;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author hiepp
 */
public class TextUtils {

    public static String refineHTML(String src) {
        src = getBody(src);
        src = removeMiscellaneousTags(src);

        XmlSyntaxChecker xmlSyntaxChecker = new XmlSyntaxChecker();

        src = xmlSyntaxChecker.check(src);

        src = getBody(src);
        return src;
    }

    public static String getBody(String src) {
        String result = src;

        String exp = "<body.*?</body>";
        Pattern pattern = Pattern.compile(exp);

        Matcher matcher = pattern.matcher(result);

        if (matcher.find()) {
            result = matcher.group(0);
        }
        return result;
    }

    public static String removeMiscellaneousTags(String src) {
        String result = src;

        // remove all <script> tags
        String exp = "<script.*?</script>";
        result = result.replaceAll(exp, "");

        // remove all commnet;
        exp = "<!--.*?-->";
        result = result.replace(exp, "");

        // remove all whitespace
        exp = "&nbsp;?";
        result = result.replaceAll(exp, "");

        return result;
    }
}
