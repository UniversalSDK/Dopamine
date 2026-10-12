cask "dopamine" do
  version "1.2.0"
  sha256 "ed532bf2ef028abeb00b89ea8355b0b1136bea7194bc0b7fc299544ddd37424f"

  url "https://dopamine.33rd.pro/Dopamine.dmg"
  name "Dopamine"
  desc "Keep-awake power utility with closed-lid display backlight cutoff for Apple Silicon"
  homepage "https://dopamine.33rd.pro"

  auto_updates true
  depends_on macos: ">= :monterey"
  depends_on arch: :arm64

  app "Dopamine.app"

  zap trash: [
    "~/Library/Application Support/Dopamine",
    "~/Library/Caches/com.alexey.Dopamine",
    "~/Library/HTTPStorages/com.alexey.Dopamine",
    "~/Library/Preferences/com.alexey.Dopamine.plist",
  ]
end
