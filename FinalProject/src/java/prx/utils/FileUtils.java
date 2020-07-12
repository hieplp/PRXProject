/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package prx.utils;

import prx.utils.checker.TextUtils;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author hiepp
 */
public class FileUtils implements Serializable {

    static int count = 0;

//    private static final WebDriver driver = new ChromeDriver();

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
            connection.setReadTimeout(3 * 1000);
            connection.setConnectTimeout(3 * 1000);
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
//
//    public static InputStream getInputStreamFromUrl(String urlString) {
//        driver.get(urlString);
//        WebDriverWait wait = new WebDriverWait(driver, 40);
//        //        wait.until((ExpectedCondition<Boolean>) wd
//        //                -> ((JavascriptExecutor) wd).executeScript("return document.readyState").equals("complete"));\
//
//        WebElement iFrame_checkbox
//                = driver.findElement(By.xpath("//*[contains(@class, 'recaptcha-checkbox-border')]"));
//        iFrame_checkbox.click();
//        ExpectedCondition<Boolean> jQueryLoad = (WebDriver f) -> {
//            try {
//                return ((Long) ((JavascriptExecutor) f).executeScript("return jQuery.active") == 0);
//            } catch (Exception e) {
//                return true;
//            }
//        };
//
//        ExpectedCondition<Boolean> jsLoad = (WebDriver f) -> ((JavascriptExecutor) f).executeScript("return document.readyState").toString().equals("complete");
//
//        wait.until(jsLoad);
//        wait.until(jQueryLoad);
//
//        String conent = driver.getPageSource();
//        conent = getString(new ByteArrayInputStream(conent.getBytes()));
//
//        conent = TextUtils.refineHTML(conent);
//
//        if (conent.contains("<body") && !conent.contains("xmlns=\"http://www.w3.org/1999/xhtml\"")) {
//            conent = conent.replace("<body", "<body xmlns=\"http://www.w3.org/1999/xhtml\"");
//        }
//        try (Writer writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("D:\\PRX\\Projects\\Assignment\\PRXProject\\FinalProject\\web\\WEB-INF\\crawl-xml\\mega\\test.xml"), StandardCharsets.UTF_8))) {
//            writer.write(conent);
//            writer.flush();
//        } catch (FileNotFoundException ex) {
//            Logger.getLogger(FileUtils.class.getName()).log(Level.SEVERE, null, ex);
//        } catch (IOException ex) {
//            Logger.getLogger(FileUtils.class.getName()).log(Level.SEVERE, null, ex);
//        }
//
//        return new ByteArrayInputStream(conent.getBytes(StandardCharsets.UTF_8));
//    }

    public static InputStream getInputStreamFromUrl(String urlString) {

        try {
            URL url = new URL(urlString);
            URLConnection connection = url.openConnection();
            connection.setReadTimeout(3 * 1000);
            connection.setConnectTimeout(3 * 1000);
            connection.setRequestProperty("User-Agent", "Mozilla/5.0");
            String content = getString(connection.getInputStream());
            content = TextUtils.refineHTML(content);
            if (content.contains("<body") && !content.contains("xmlns=\"http://www.w3.org/1999/xhtml\"")) {
                content = content.replace("<body", "<body xmlns=\"http://www.w3.org/1999/xhtml\"");
            }
            return new ByteArrayInputStream(content.getBytes(StandardCharsets.UTF_8));

        } catch (MalformedURLException ex) {
            Logger.getLogger(FileUtils.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(FileUtils.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }
}
