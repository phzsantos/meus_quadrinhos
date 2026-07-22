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
