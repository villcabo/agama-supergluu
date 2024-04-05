package org.gluu.agama.supergluu.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class ScimFidoDeviceResponseDTO implements Serializable {

    private static final long serialVersionUID = -3465236599853658766L;

    @JsonProperty("totalResults")
    private Integer count;

    @JsonProperty("Resources")attachDeviceRegistrationToUser
    private List<ScimFidoDeviceDTO> items = new ArrayList<>();

    public ScimFidoDeviceResponseDTO() {
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    public List<ScimFidoDeviceDTO> getItems() {
        return items;
    }

    public void setItems(List<ScimFidoDeviceDTO> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "ScimFidoDeviceResponseDTO{" +
                "count=" + count +
                ", items=" + items +
                '}';
    }
}
