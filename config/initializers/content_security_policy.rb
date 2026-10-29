# Be sure to restart your server when you modify this file.

# The site loads nothing from anywhere else: no remote fonts, scripts, styles,
# images, or frames (docs/decisions.md entry 31). Importmap's inline script
# and Turbo's progress-bar style carry a fresh nonce on every request.
# See https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.base_uri :self
    policy.connect_src :self
    policy.font_src :self
    policy.form_action :self
    policy.frame_ancestors :none
    policy.img_src :self, :data
    policy.manifest_src :self
    policy.object_src :none
    policy.script_src :self
    policy.style_src :self
    policy.worker_src :self
  end

  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src style-src]
end
