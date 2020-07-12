/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package prx.servlets;

import prx.utils.CrawlUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
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

            String realPath = getServletContext().getRealPath("/");
            System.out.println(realPath + "\\crawl-xml\\novabench\\gpu\\ultimate_rs.xml");
            realPath = realPath.replace("\\build", "") + "WEB-INF";
//            // run crawler
//            DOMResult cpuDOMRs = CrawlUtils.crawl(realPath + "\\crawl-xml\\novabench\\cpu\\ultimate.xml",
//                    realPath + "\\crawl-xml\\novabench\\cpu\\product.xsl");
//            XMLUtils.transformDOMToFile(cpuDOMRs.getNode(), realPath + "\\crawl-xml\\novabench\\cpu\\ultimate_rs.xml");
//
//            DOMResult gpuDOMRs = CrawlUtils.crawl(realPath + "\\crawl-xml\\novabench\\cpu\\ultimate.xml",
//                    realPath + "\\crawl-xml\\novabench\\cpu\\product.xsl");
//            XMLUtils.transformDOMToFile(gpuDOMRs.getNode(), realPath + "\\crawl-xml\\novabench\\cpu\\ultimate_rs.xml");

//            DOMResult lpDOMRs = CrawlUtils.crawl(realPath + "\\crawl-xml\\mega\\ram\\laptop\\ultimate.xml",
//                    realPath + "\\crawl-xml\\mega\\ram\\laptop\\product.xsl");
//            XMLUtils.transformDOMToFile(lpDOMRs.getNode(), realPath + "\\crawl-xml\\mega\\ram\\laptop\\ultimate_rs.xml");

            DOMResult storageDOMRs = CrawlUtils.crawl(realPath + "\\crawl-xml\\mega\\cpu\\ultimate.xml",
                    realPath + "\\crawl-xml\\mega\\cpu\\product.xsl");
            XMLUtils.transformDOMToFile(storageDOMRs.getNode(), realPath + "\\crawl-xml\\mega\\cpu\\ultimate_rs.xml");
//            
//            DOMResult ramDOMRs = CrawlUtils.crawl(realPath + "\\crawl-xml\\mega\\mainboard\\ultimate.xml",
//                    realPath + "\\crawl-xml\\mega\\mainboard\\product.xsl");
//            XMLUtils.transformDOMToFile(ramDOMRs.getNode(), realPath + "\\crawl-xml\\mega\\mainboard\\ultimate_rs.xml");
            response.sendRedirect(url);

        } catch (TransformerException ex) {
            Logger.getLogger(ProcessServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

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
