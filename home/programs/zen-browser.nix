{ zen-browser, system, ... }:
{
  home.packages = [
    zen-browser.packages.${system}.default
  ];

  xdg.desktopEntries = {
    zen-work = {
      name = "Zen - Work";
      genericName = "Web Browser";
      comment = "Open the Zen work profile";
      exec = ''zen --no-remote -P "work-zen-profile" %U'';
      icon = "zen";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
    };

    zen-personal = {
      name = "Zen - Personal";
      genericName = "Web Browser";
      comment = "Open the Zen personal profile";
      exec = ''zen --no-remote -P "personal-zen-profile" %U'';
      icon = "zen";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
    };

    zen-profile-chooser = {
      name = "Zen - Profile Chooser";
      genericName = "Web Browser";
      comment = "Choose a Zen profile, including while Zen is already running";
      exec = "zen --no-remote --ProfileManager";
      icon = "zen";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
    };
  };
}
