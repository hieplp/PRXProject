/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package prx.utils;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.stream.StreamSource;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.Serializable;

/**
 *
 * @author hiepp
 */
public class CrawlUtils implements Serializable {

    public static DOMResult crawl(String configPath, String xslPath) throws TransformerConfigurationException, TransformerException, FileNotFoundException {
        // init files
        StreamSource xslCate = new StreamSource(xslPath);
        InputStream is = new FileInputStream(configPath);

        // init transformer api
        TransformerFactory factory = TransformerFactory.newInstance();
        DOMResult domResult = new DOMResult();
        UltimateURIResolver resolver = new UltimateURIResolver();
        // apply uri resolver
        factory.setURIResolver(resolver);
        Transformer transformer = factory.newTransformer(xslCate);
        // transformer xml config by input xsl
        transformer.transform(new StreamSource(is), domResult);
        return domResult;
    }

}
