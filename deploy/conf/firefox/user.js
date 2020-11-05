//

// Tab options
user_pref("toolkit.tabbox.switchByScrolling", true);

// Full screen options
user_pref("full-screen-api.transition.timeout", 0);
user_pref("full-screen-api.macos-native-full-screen", true);
user_pref("full-screen-api.warning.delay", -1);
user_pref("full-screen-api.warning.timeout", 0);
user_pref("full-screen-api.transition-duration.leave", "0 0");
user_pref("full-screen-api.transition-duration.enter", "0 0");

// Network protocols
user_pref("network.protocol-handler.warn-external-default", true);
user_pref("network.protocol-handler.external.http", false);
user_pref("network.protocol-handler.external.https", false);
user_pref("network.protocol-handler.external.javascript", false);
user_pref("network.protocol-handler.external.moz-extension", false);
user_pref("network.protocol-handler.external.ftp", false);
user_pref("network.protocol-handler.external.file", false);
user_pref("network.protocol-handler.external.about", false);
user_pref("network.protocol-handler.external.chrome", false);
user_pref("network.protocol-handler.external.blob", false);
user_pref("network.protocol-handler.external.data", false);
user_pref("network.protocol-handler.expose-all", false);
user_pref("network.protocol-handler.expose.http", true);
user_pref("network.protocol-handler.expose.https", true);
user_pref("network.protocol-handler.expose.javascript", true);
user_pref("network.protocol-handler.expose.moz-extension", true);
user_pref("network.protocol-handler.expose.ftp", true);
user_pref("network.protocol-handler.expose.file", true);
user_pref("network.protocol-handler.expose.about", true);
user_pref("network.protocol-handler.expose.chrome", true);
user_pref("network.protocol-handler.expose.blob", true);
user_pref("network.protocol-handler.expose.data", true);

// Disable Telemetry
user_pref("toolkit.telemetry.archive.enabled = false");
user_pref("toolkit.telemetry.server = ''");
user_pref("toolkit.telemetry.unified = false");
user_pref("browser.newtabpage.activity-stream.feeds.telemetry = false");
user_pref("browser.newtabpage.activity-stream.telemetry = false");
user_pref("browser.ping-centre.telemetry = false");
user_pref("toolkit.telemetry.archive.enabled = fals");
user_pref("toolkit.telemetry.bhrPing.enabled = false");
user_pref("toolkit.telemetry.firstShutdownPing.enabled = false");
user_pref("toolkit.telemetry.newProfilePing.enabled = false");
user_pref("toolkit.telemetry.firstShutdownPing.enabled = false");
user_pref("toolkit.telemetry.reportingpolicy.firstRun = false");
user_pref("toolkit.telemetry.shutdownPingSender.enabled = false");
user_pref("toolkit.telemetry.updatePing.enabled = false");

// PREF: Updates addons automatically
// https://blog.mozilla.org/addons/how-to-turn-off-add-on-updates/
user_pref("extensions.update.enabled", true);

// PREF: Disable Flash Player NPAPI plugin
// http://kb.mozillazine.org/Flash_plugin
user_pref("plugin.state.flash", 0);

// PREF: Disable Java NPAPI plugin
user_pref("plugin.state.java", 0);

// PREF: Disable remote debugging
// https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_Firefox_Desktop
// https://developer.mozilla.org/en-US/docs/Tools/Tools_Toolbox#Advanced_settings
user_pref("devtools.debugger.remote-enabled", false);
user_pref("devtools.chrome.enabled", false);
user_pref("devtools.debugger.force-local", true);

user_pref("extensions.pocket.enabled", false);
user_pref("toolkit.zoomManager.zoomValues", ".3,.5,.67,.8,.9,1,1.1,1.2,1.25,1.3,1.4,1.5,1.7,2,2.4,3")

//
// Option to enable when using AMD graphics and hardware acceleration
//
user_pref("layers.acceleration.force-enabled", true);
user_pref("webgl.force-enabled", true);
user_pref("media.hardware-video-decoding.force-enabled", true);
user_pref("browser.tabs.remote.autostart", true);
