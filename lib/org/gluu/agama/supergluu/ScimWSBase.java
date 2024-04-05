package org.gluu.agama.supergluu;

import com.nimbusds.oauth2.sdk.ParseException;
import com.nimbusds.oauth2.sdk.http.HTTPRequest;
import com.nimbusds.oauth2.sdk.http.HTTPResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.*;

import static java.nio.charset.StandardCharsets.UTF_8;

public class ScimWSBase {

    public static final String SCOPE_PREFIX = "https://jans.io/scim";

    private static final int TOKEN_EXP_GAP = 2000;

    //making it static prevents a serialization error...
    protected static final Logger log = LoggerFactory.getLogger(ScimWSBase.class);

    private String basicAuthnHeader;
    private String serverBase;
    private String token;
    private long tokenExp;
    private String scope;
    protected String apiBase;

    public ScimWSBase() throws IOException {
        this(false, null);
    }

    //constructor added to prevent serialization error...
    public ScimWSBase(boolean doHealthCheck, ScimSetting scimSetting) throws IOException {
        serverBase = NetworkUtils.urlBeforeContextPath();
        apiBase = serverBase + "/jans-scim/restv1";

        if (doHealthCheck) {
            ensureScimAvailability();
        }

        if (scimSetting != null) {
            String authz = scimSetting.getScimClientId() + ":" + scimSetting.getScimClientSecret();
            String authzEncoded = new String(Base64.getEncoder().encode(authz.getBytes(UTF_8)), UTF_8);
            basicAuthnHeader = "Basic " + authzEncoded;
            log.debug("Scim loaded successfully, basicAuthnHeader: {}, apiBase: {}", authz, apiBase);
        }
    }

    protected void setScope(String scope) {
        this.scope = scope;
    }


    protected String getApiBase() {
        return apiBase;
    }

    protected HTTPResponse sendRequest(HTTPRequest request, boolean checkOK, boolean withToken) throws IOException, ParseException {
        setTimeouts(request);
        if (withToken) {
            refreshToken();
            request.setAuthorization("Bearer " + token);
        }

        HTTPResponse r = request.send();
        if (checkOK) {
            log.debug("=====> Parent Response -> status: {}, body: {}", r.getStatusCode(), r.getContent());
            r.ensureStatusCode(200);
        }
        return r;
    }

    protected String encode(String str) {
        return URLEncoder.encode(str, UTF_8);
    }

    private void ensureScimAvailability() throws IOException {
        try {
            URL url = new URL(serverBase + "/jans-scim/sys/health-check");
            log.debug("Scim health-check url: {}", url);
            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.GET, url);
            sendRequest(request, true, false);
        } catch (Exception e) {
            log.warn("SCIM not installed or not running?");
            throw new IOException("SCIM health-check request did not succeed", e);
        }
    }

    private void refreshToken() throws IOException {
        long currentTime = System.currentTimeMillis();
        long expiration = tokenExp - TOKEN_EXP_GAP;
        if (currentTime < expiration) {
            log.debug("No need to generate a new token: {}, currentTime: {}, expiration: {}", token, currentTime, expiration);
            return;
        }

        StringJoiner joiner = new StringJoiner("&");
        Map.of("grant_type", "client_credentials", "scope", scope)
                .forEach((k, v) -> joiner.add(k + "=" + v));

        HTTPRequest request = new HTTPRequest(HTTPRequest.Method.POST, new URL(serverBase + "/jans-auth/restv1/token"));
        setTimeouts(request);
        request.setQuery(joiner.toString());
        request.setAuthorization(basicAuthnHeader);

        try {
            Map<String, Object> jobj = request.send().getContentAsJSONObject();
            long exp = Long.parseLong(jobj.get("expires_in").toString());
            long expX1000 = exp * 1000;
            tokenExp = System.currentTimeMillis() + expX1000;
            token = jobj.get("access_token").toString();
            log.info("New token generated: {}, exp: {}, expX1000: {}, expiration: {}", token, exp, expX1000, tokenExp);

        } catch (Exception e) {
            throw new IOException(e.getMessage(), e);
        }
    }

    private void setTimeouts(HTTPRequest request) {
        request.setConnectTimeout(3500);
        request.setReadTimeout(3500);
    }
}
