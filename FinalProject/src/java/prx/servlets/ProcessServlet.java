/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package prx.servlets;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import prx.utils.CrawlUtils;
import prx.utils.FileUtils;
import prx.utils.XMLUtils;

/**
 *
 * @author hiepp
 */
public class ProcessServlet extends HttpServlet {

    private final String HOME_PAGE = "index.html";
    private final String XML_PATH = "WEB-INF/studentAccounts.xml";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String url = HOME_PAGE;

//        String realPath = getServletContext().getRealPath("/");
//        String filePath = realPath + XML_PATH;
//
//        String xmlFileDes = realPath + "WEB-INF/studentAccounts.xml";
//        xmlFileDes = xmlFileDes.replace("\\build", "");
//        FileUtils.getHTMLContent("https://www.kimovil.com/en/all-smartphone-brands", xmlFileDes);
            // run crawler
            DOMResult rs = CrawlUtils.crawl("D:\\PRX\\Projects\\FinalProject\\src\\java\\config\\ultimate.xml", "D:\\PRX\\Projects\\FinalProject\\src\\java\\config\\product.xsl");
            // init transformer
            TransformerFactory factory = TransformerFactory.newInstance();
            Transformer transformer = factory.newTransformer();
            StreamResult result = new StreamResult(new FileOutputStream("D:\\PRX\\Projects\\FinalProject\\src\\java\\config\\ultimate_rs.xml"));
            // transform to xml file
            transformer.transform(new DOMSource(rs.getNode()), result);

            response.sendRedirect(url);

        } catch (TransformerException ex) {
            Logger.getLogger(ProcessServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
//        try {
//            String url = HOME_PAGE;
//
//            String realPath = getServletContext().getRealPath("/");
//            String filePath = realPath + XML_PATH;
//
//            String xmlFileDes = realPath + "WEB-INF/studentAccounts.xml";
//            xmlFileDes = xmlFileDes.replace("\\build", "");
//            FileUtils.getHTMLContent("https://www.kimovil.com/en/all-smartphone-brands", xmlFileDes);
//            response.sendRedirect(url);
//            InputStream is = FileUtils.getInputStreamFromUrl("https://www.kimovil.com/en/all-smartphone-brands");
//            if (is != null) {
//                Document document = XMLUtils.parseInputStreamToDOM(is);
//                is.close();
//                String exp = "//*[@id='inline-search-list']/li[@class='item']";
//                XPath xPath = XMLUtils.getXPath();
//                NodeList brands = (NodeList) xPath.evaluate(exp, document, XPathConstants.NODESET);
//                if (brands != null) {
//                    for (int i = 0; i < brands.getLength(); i++) {
//                        exp = "div/a/@href";
//                        String link = (String) xPath.evaluate(exp, brands.item(i), XPathConstants.STRING);
//                        System.out.println(link);
//                        exp = "div/a/div/img/@data-src";
//                        String image = (String) xPath.evaluate(exp, brands.item(i), XPathConstants.STRING);
//                        System.out.println(image);
//                        exp = "div/a/div/h3";
//                        String brandName = (String) xPath.evaluate(exp, brands.item(i), XPathConstants.STRING);
//                        System.out.println(brandName);
//                        exp = "div/a/div/p";
//                        String quantity = (String) xPath.evaluate(exp, brands.item(i), XPathConstants.STRING);
//                        System.out.println(quantity);
//                        System.out.println("-------------");
//                    }
//                }
//            }
//        } catch (SAXException | ParserConfigurationException | XPathExpressionException ex) {
//            Logger.getLogger(ProcessServlet.class.getName()).log(Level.SEVERE, null, ex);
//        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
