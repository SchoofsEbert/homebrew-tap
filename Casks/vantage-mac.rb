cask "vantage-mac" do
  version "3.0.0"
  sha256 "0060b9a9f1508bb378fd72137af2b98c5a0d70f0209814bfae38165e511cbd3b"

  url "https://github.com/SchoofsEbert/vantage-mac/releases/download/v#{version}/Vantage.app.zip"
  name "Vantage"
  desc "Close windows from Mission Control and snap them side by side"
  homepage "https://github.com/SchoofsEbert/vantage-mac"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "Vantage.app"

  # A MissionStrike install renames itself to Vantage.app after updating in place, which
  # Homebrew would otherwise refuse to overwrite. Only removes our own app.
  preflight_steps do
    run "/bin/sh",
        args:           ["-c", 'id=$(/usr/bin/defaults read "$1/Contents/Info" CFBundleIdentifier 2>/dev/null); ' \
                               '[ "$id" = io.github.schoofsebert.missionstrike ] && /bin/rm -rf "$1"; exit 0',
                         "sh", "{{appdir}}/Vantage.app"],
        writable_paths: ["{{appdir}}/Vantage.app"]
  end

  # Releases are signed with a self-signed certificate, not an Apple Developer ID,
  # so Gatekeeper would block the quarantined app. Vantage verifies its own
  # updates against its pinned signing certificate.
  postflight_steps do
    if_path_exists "{{appdir}}/Vantage.app" do
      run "/usr/bin/xattr",
          args: ["-dr", "com.apple.quarantine", "{{appdir}}/Vantage.app"]
    end
  end

  # The identifier changed after 2.6.1; cover both.
  uninstall quit: [
    "com.vibecoded.missionstrike",
    "io.github.schoofsebert.missionstrike",
  ]

  zap trash: [
    "~/Library/Preferences/com.vibecoded.missionstrike.plist",
    "~/Library/Preferences/io.github.schoofsebert.missionstrike.plist",
  ]
end
