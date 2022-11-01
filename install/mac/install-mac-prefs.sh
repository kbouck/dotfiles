#!/bin/sh

# more options, see see https://github.com/mihaliak/dotfiles/blob/master/macos/defaults.sh

osascript -e 'tell application "System Preferences" to quit'


# Prompt up-front for sudo priviledges
sudo -v


# Keyboard
# ========

# Set key repeat rate (these are faster than can be set in the settings gui)
defaults write NSGlobalDomain InitialKeyRepeat -int 15   # unit is 15s, so 15*15=225 ms)
defaults write NSGlobalDomain KeyRepeat -int 2           # unit is 15s, so 2*15=30 ms)


# Screenshots
# ===========

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable screenshot shadow
defaults write com.apple.screencapture disable-shadow -bool true


# Dashboard
# =========

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true


# Finder
# ======

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false


# Network
# =======

# Show/Hide icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true


# Safari
# ======

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true


# Misc
# ====

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Disable smart quotes and dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Set format of date & hours in menu bar
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm"

# Set dark mode (restart required to take effect)
defaults write "Apple Global Domain" "AppleInterfaceStyle" "Dark"


# Kill Main Apps
# ==============
for app in "Address Book" "Calendar" "Contacts" "Dock" "Finder" "Mail" "Safari" "SystemUIServer" "iCal"; do
  killall "${app}" &> /dev/null
done


