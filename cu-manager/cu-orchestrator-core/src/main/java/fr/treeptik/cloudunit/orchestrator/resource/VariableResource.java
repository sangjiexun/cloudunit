package fr.treeptik.cloudunit.orchestrator.resource;

import fr.treeptik.cloudunit.orchestrator.core.Variable;
import org.springframework.hateoas.ResourceSupport;

import java.util.Map;

/**
 * Created by nicolas on 07/03/2017.
 */
public class VariableResource extends ResourceSupport {

    private String key;
    private String value;

    public VariableResource() {
    }

    public VariableResource(Variable variable) {
        this.key = variable.getKey();
        this.value = variable.getValue();
    }

    public VariableResource(String key, String value) {
        this.key = key;
        this.value = value;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}