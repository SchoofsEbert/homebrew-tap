cask "missionstrike" do
  version "2.8.0"
  sha256 "bafc0edfc74fc5b9c3eb10f7cdb6b0b821b2c8d724c7963d29c3f376dab32b06"

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
