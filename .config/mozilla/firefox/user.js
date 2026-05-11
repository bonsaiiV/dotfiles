// privacy
user_pref("browser.privatebrowsing.autostart", true);
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.resistFingerprinting.exemptedDomains", "*.vhs.cloud, *.netflix.com, *.nflxvideo.net, *.nflxext.com, *.fachschaften.org, [::1], localhost");
// user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.fingerprintingProtection", true);
user_pref("privacy.query_stripping.enabled", true);
user_pref("browser.contentblocking.category", "strict");

user_pref("signon.rememberSignons", false);
user_pref("browser.formfill.enable", false);

// https only mode
user_pref("dom.security.https_only_mode", true);
user_pref("services.sync.prefs.sync-seen.dom.security.https_only_mode", true);
user_pref("browser.xul.error_pages.expert_bad_cert", true);

// disable telemetry
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.usage.uploadEnabled", false);

// deactivate ai-features
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.enable", false);
user_pref("browser.tabs.groups.smart.enabled", false);
user_pref("browser.tabs.groups.smart.userEnabled", false);
user_pref("extensions.ml.enabled", false);

// newtab
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);

// warnings
user_pref("browser.aboutConfig.showWarning", false);

// other stuff
user_pref("browser.download.useDownloadDir", false);
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
user_pref("sidebar.visibility", "hide-sidebar");
user_pref("browser.translations.neverTranslateLanguages", "de");
user_pref("browser.search.region", "NL");

// search
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.suggest.clipboard", false);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.openpage", false);

// print
user_pref("print.printer_Print_to_File.print_margin_bottom", "0.100000001490116");
user_pref("print.printer_Print_to_File.print_margin_left", "0.100000001490116");
user_pref("print.printer_Print_to_File.print_margin_right", "0.100000001490116");
user_pref("print.printer_Print_to_File.print_margin_top", "0.100000001490116");
