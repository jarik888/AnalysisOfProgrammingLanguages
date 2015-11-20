import org.antlr.v4.gui.Trees;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.io.*;
import java.util.List;
import java.util.Map;

public class Main {

    public static String INPUT_FILE = "input.json";
    public static boolean SHOW_TREE = false;
    public static boolean PRINT = false;

    public static void main(String[] args) {

        InputStream is;
        try {
            is = new FileInputStream(INPUT_FILE);
        } catch (FileNotFoundException e) {
            System.err.println("File was not found.");
            return;
        }

        JSONLexer lexer;
        try {
            lexer = new JSONLexer(new ANTLRInputStream(is));
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        CommonTokenStream token = new CommonTokenStream(lexer);

        JSONParser parser = new JSONParser(token);

        if (SHOW_TREE) {
            ParserRuleContext ruleContext = parser.json();
            Trees.inspect(ruleContext, parser);
        } else {
            ParseTree tree = parser.json();
            ParseTreeWalker walker =  new ParseTreeWalker();
            JSONLoader loader = new JSONLoader();
            walker.walk(loader, tree);

            String outputXML = objectsToXmlText(loader.objects);

            if (PRINT) {
                System.out.println(outputXML);
            } else {
                writeToFile(outputXML);
            }
        }
    }

    private static String objectsToXmlText(List<Map<String, String>> objects) {
        String result = "<file>\r\n";
        for (Map<String, String> object : objects) {
            result += "<film>\r\n";
            for (String key : object.keySet()) {
                result += "<" + key + ">";
                result += object.get(key);
                result += "</" + key + ">\r\n";
            }
            result += "</film>\r\n";
        }
        result += "</file>\r\n";
        return result;
    }

    private static void writeToFile(String text) {
        try {
            FileWriter fileWriter = new FileWriter("output.xml");
            fileWriter.write(text);
            fileWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
