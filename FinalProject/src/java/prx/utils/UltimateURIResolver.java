/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package prx.utils;

import java.io.InputStream;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;

/**
 *
 * @author hiepp
 */
public class UltimateURIResolver implements URIResolver {

    @Override
    public Source resolve(String href, String base) throws TransformerException {
        InputStream httpResult = FileUtils.getInputStreamFromUrl(href);
        StreamSource ss = new StreamSource(httpResult);
        return ss;
    }

}
