cask "dopamine" do
  version "1.3.0"
  sha256 "b118b9abcf35ea1c873df7e06f185a508617452ae95ce82c321afee9ef73ea5b"

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
