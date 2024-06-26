package org.gluu.agama.supergluu;

import io.jans.as.common.model.session.SessionId;
import io.jans.as.common.service.common.fido2.RegistrationPersistenceService;
import io.jans.as.model.configuration.AppConfiguration;
import io.jans.as.server.service.SessionIdService;
import io.jans.model.custom.script.model.CustomScript;
import io.jans.orm.model.fido2.Fido2RegistrationEntry;
import io.jans.service.cdi.util.CdiUtil;
import io.jans.service.custom.CustomScriptService;
import io.jans.util.Pair;
import jakarta.servlet.http.HttpServletRequest;
import net.minidev.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SGValidator {

    private static final String APP_ID_PROPERTY = "supergluu_app_id";

    private static final String ATTRS_NOT_FOUND_SESSION = "One or more required attributes were not found in the session";

    private static final Logger logger = LoggerFactory.getLogger(SGValidator.class);

    private static String issuer = null;

    public static String appId = null;

    public SGValidator() {
    }

    public String QRRequest(String method) {
        String state = getSessionId().getId();
        logger.debug("Generating QR code request for SG enrollment");

        Map<String, String> req = Map.of(
                "app", appId,
                "issuer", issuer,
                "state", state,
                "created", Instant.now().toString());

        if (method != null) {
            req = new HashMap<>(req);
            req.put("method", method);
        }
        return JSONObject.toJSONString(req);
    }

    public Pair<String, String> validateEnrolledDevice() {
        String msg = null;
        Map<String, String> sessAttrs = getSessionId().getSessionAttributes();
        logger.debug("session Attributes: {}", sessAttrs);
        boolean present = List.of(
                //"super_gluu_request", this one is missing if you already have an enrollment with a different user
                "super_gluu_u2f_device_user_inum").stream().allMatch(sessAttrs::containsKey);

        String sessionCustomState = sessAttrs.get("session_custom_state");
        String superGluuU2fDeviceEnroll = sessAttrs.get("super_gluu_u2f_device_enroll");
        String superGluuU2fDeviceOneStep = sessAttrs.get("super_gluu_u2f_device_one_step");

        if ("approved".equals(sessionCustomState) && "true".equals(superGluuU2fDeviceEnroll)
                && "true".equals(superGluuU2fDeviceOneStep)) {
            String deviceDn = sessAttrs.get("super_gluu_u2f_device_dn");
            String deviceId = sessAttrs.get("super_gluu_u2f_device_id");

            if (deviceDn != null && deviceId != null) {
                Fido2RegistrationEntry device = CdiUtil.bean(RegistrationPersistenceService.class)
                        .findOneStepUserDeviceRegistration(deviceDn);

                if (device == null) {
                    msg = "Device was not found";

                } else if (!appId.equals(device.getRpId())) {
                    logger.error("Device id = {}", deviceId);
                    msg = "Device was not associated to application " + appId;

                } else return new Pair<>(deviceDn, null);

            } else {
                msg = ATTRS_NOT_FOUND_SESSION;
            }

        } else {
            msg = ATTRS_NOT_FOUND_SESSION;
        }

        logger.error(msg);
        return new Pair<>(null, msg);
    }

    public String validateDevice(String inum) {
        String msg = null;
        Map<String, String> sessAttrs = getSessionId().getSessionAttributes();

        String sessionCustomState = sessAttrs.get("session_custom_state");
        String superGluuU2fDeviceUserInum = sessAttrs.get("super_gluu_u2f_device_user_inum");
            String deviceId = sessAttrs.get("super_gluu_u2f_device_id");

        logger.debug("*** -> sessionCustomState: {}", sessionCustomState);
        logger.debug("*** -> superGluuU2fDeviceUserInum: {}", superGluuU2fDeviceUserInum);

        if ("approved".equals(sessionCustomState) && inum.equals(superGluuU2fDeviceUserInum)) {

            Fido2RegistrationEntry device = CdiUtil.bean(RegistrationPersistenceService.class)
                    .findRegisteredUserDevice(inum, deviceId);

            if (device == null) {
                msg = "Device not associated to this user";

            } else if (!appId.equals(device.getRpId())) {
                logger.error("Device id = {}", deviceId);
                msg = "Device is not associated to application " + appId;

            } else return null;

        } else {
            msg = ATTRS_NOT_FOUND_SESSION;
        }

        logger.error(msg);
        return msg;
    }

    public boolean attach(String userId, String deviceId, String displayName) {
        return CdiUtil.bean(RegistrationPersistenceService.class)
                .attachDeviceRegistrationToUser(userId, deviceId, displayName);
    }

    private SessionId getSessionId() {
        SessionIdService sis = CdiUtil.bean(SessionIdService.class);
        //sis.getSessionId() returns null as well as
        //CdiUtil.bean(io.jans.as.server.security.Identity.class).getSessionId() ... why?

        //My workaround:
        return sis.getSessionId(CdiUtil.bean(HttpServletRequest.class));
    }

    static {
        issuer = CdiUtil.bean(AppConfiguration.class).getIssuer();

        logger.info("Checking casa custom script");
        CustomScript casaScr = CdiUtil.bean(CustomScriptService.class).getScriptByDisplayName("casa");

        logger.info("Retrieving 'supergluu_app_id' property");
        appId = casaScr.getConfigurationProperties().stream()
                .filter(p -> APP_ID_PROPERTY.equals(p.getValue1())).findAny().get().getValue2();
    }
}
