cask "missionstrike" do
  version "2.10.0"
  sha256 "31013ff6d146233f121b576a1999c8f4450788969d70ba21ba35b5a54c3da6e1"

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
  depends_on arch: :arm64

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
