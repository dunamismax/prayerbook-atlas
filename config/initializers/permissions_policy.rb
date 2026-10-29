# The site asks for no device features. Audio (BUILD.md P22) may later need
# autoplay for read-aloud, started only by the person.
Rails.application.config.permissions_policy do |policy|
  policy.camera :none
  policy.microphone :none
  policy.geolocation :none
  policy.usb :none
  policy.payment :none
  policy.gyroscope :none
  policy.accelerometer :none
  policy.magnetometer :none
  policy.fullscreen :self
end
