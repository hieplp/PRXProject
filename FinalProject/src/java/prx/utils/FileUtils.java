/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package prx.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Serializable;
import java.io.Writer;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;
import prx.utils.checker.TextUtils;

/**
 *
 * @author hiepp
 */
public class FileUtils implements Serializable {

    static int count = 0;

    /**
     * Get string from input stream
     *
     * @param is
     * @return
     */
    public static String getString(InputStream is) {
        StringBuilder sb = new StringBuilder();
        String line;
        try (
                InputStreamReader isr = new InputStreamReader(is, StandardCharsets.UTF_8);
                BufferedReader br = new BufferedReader(isr);) {
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            System.out.println(++count);

        } catch (IOException ex) {
            Logger.getLogger(FileUtils.class.getName()).log(Level.SEVERE, null, ex);
        }

        return sb.toString();
    }

    public static void getHTMLContent(String urlString, String xmlFileDes) {
        try {
            URL url = new URL(urlString);
            URLConnection connection = url.openConnection();
            connection.setReadTimeout(8 * 1000);
            connection.setConnectTimeout(8 * 1000);
            connection.setRequestProperty("User-Agent", "Mozilla/5.0");

            String conent = getString(connection.getInputStream());
            conent = TextUtils.refineHTML(conent);

            String filePath = xmlFileDes;
            try (Writer writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filePath), StandardCharsets.UTF_8))) {
                writer.write(conent);
                writer.flush();
            }

        } catch (MalformedURLException ex) {
            Logger.getLogger(FileUtils.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(FileUtils.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public static InputStream getInputStreamFromUrl(String urlString) {
        InputStream is = null;
        try {
            URL url = new URL(urlString);
            URLConnection connection = url.openConnection();
            connection.setReadTimeout(8 * 1000);
            connection.setConnectTimeout(8 * 1000);
            connection.setRequestProperty("User-Agent", "Mozilla/5.0");

            String conent = getString(connection.getInputStream());
            conent = TextUtils.refineHTML(conent);
            if (conent.contains("<body") && !conent.contains("xmlns=\"http://www.w3.org/1999/xhtml\"")) {
                conent = conent.replace("<body", "<body xmlns=\"http://www.w3.org/1999/xhtml\"");
            }
            is = new ByteArrayInputStream(conent.getBytes(StandardCharsets.UTF_8));
        } catch (MalformedURLException ex) {
            Logger.getLogger(FileUtils.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(FileUtils.class.getName()).log(Level.SEVERE, null, ex);
        }
        return is;
    }

}
