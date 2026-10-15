cask "missionstrike" do
  version "2.7.0"
  sha256 "e1124ce433aaa08a4ced26e7e3c179fa131305d13edb58c672802398a3dd5891"

  url "https://github.com/SchoofsEbert/MissionStrike/releases/download/v#{version}/MissionStrike.app.zip"
  name "MissionStrike"
  desc "Close, minimize and manage windows directly from Mission Control"
  homepage "https://github.com/SchoofsEbert/MissionStrike"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sonoma

  app "MissionStrike.app"

  # Releases are signed with a self-signed certificate, not an Apple Developer ID,
  # so Gatekeeper would block the quarantined app. MissionStrike verifies its own
  # updates against its pinned signing certificate.
  postflight_steps do
    if_path_exists "{{appdir}}/MissionStrike.app" do
      run "/usr/bin/xattr",
          args: ["-dr", "com.apple.quarantine", "{{appdir}}/MissionStrike.app"]
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
