package com.pdf;

import java.io.ByteArrayOutputStream;
import java.util.Base64;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

public class jsontoPdf {
    public static String jsontopdf(String content) {
        try {
            Document document = new Document();
            ByteArrayOutputStream baos = new ByteArrayOutputStream();

            PdfWriter.getInstance(document, baos);
            document.open();
            document.add(new Paragraph(content));
            document.close();

            return Base64.getEncoder().encodeToString(baos.toByteArray());
        } catch (DocumentException e) {
            e.printStackTrace();
            return null;
        }
    }
}