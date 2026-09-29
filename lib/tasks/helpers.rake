# frozen_string_literal: true

def show_spinner(msg_start, msg_end = "Done!")
  spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :arrow_pulse)
  spinner.auto_spin
  yield
  spinner.success("(#{msg_end})")
end

def quiet_system(cmd)
  success = system(cmd, out: File::NULL, err: File::NULL)
  abort("Failed: #{cmd}") unless success
end

def export_via_controller(controller_class, filename, user: nil)
  controller_class.skip_before_action(:authenticate_user!, raise: false)
  controller_class.skip_before_action(:require_admin!, raise: false)

  request = ActionController::TestRequest.create(controller_class)
  response = ActionDispatch::TestResponse.create
  controller = controller_class.new
  controller.define_singleton_method(:current_user) { user } if user
  controller.dispatch(:export, request, response)

  unless response.successful?
    abort("Export failed for #{controller_class}: HTTP #{response.status}")
  end

  data = JSON.parse(response.body)
  File.write(
    Rails.root.join("db/seeds", filename),
    "#{JSON.pretty_generate(data)}\n",
  )
end
