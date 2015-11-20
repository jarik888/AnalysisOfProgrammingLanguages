import org.antlr.v4.runtime.tree.ParseTreeListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class JSONLoader extends JSONBaseListener implements ParseTreeListener {

    List<Map<String, String>> objects;
    Map<String, String> currentObject;

    @Override
    public void enterJson(JSONParser.JsonContext ctx) {
        objects = new ArrayList<Map<String, String>>();
    }

    @Override
    public void enterObject(JSONParser.ObjectContext ctx) {
        currentObject = new HashMap<String, String>();
    }

    @Override
    public void exitObject(JSONParser.ObjectContext ctx) {
       objects.add(currentObject);
    }

    @Override
    public void enterPair(JSONParser.PairContext ctx) {
        currentObject.put(removeQuotes(ctx.key.getText()), removeQuotes(ctx.value.getText()));
    }

    private static String removeQuotes(String text) {
        return text.replace("\"", "");
    }

}
