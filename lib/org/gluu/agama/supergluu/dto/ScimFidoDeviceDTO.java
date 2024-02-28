package org.gluu.agama.supergluu.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.io.Serializable;

public class ScimFidoDeviceDTO implements Serializable {

    private static final long serialVersionUID = -5251787450685020046L;

    @JsonProperty("creationDate")
    private String creationDate;

    @JsonProperty("displayName")
    private String displayName;

    public ScimFidoDeviceDTO() {
    }

    public String getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(String creationDate) {
        this.creationDate = creationDate;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    @Override
    public String toString() {
        return "ScimFidoDeviceDTO{" +
                "creationDate='" + creationDate + '\'' +
                ", displayName='" + displayName + '\'' +
                '}';
    }
}
