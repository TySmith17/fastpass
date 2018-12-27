require "colorize"
require "http/client"
require "admiral"
require "./helper"

class Fastpass::CLI::CheckStatus < Admiral::Command
  include Helper
  @runtime : Float64?

  class UnknownStatus < Exception
  end

  rescue_from Exception do |e|
    log e.message, :light_red, @error_io
    Process.exit(1)
  end

  define_help description: "Checks a fastpass status."
  define_flag shell, short: s, description: "the shell to run in", default: "/bin/bash"
  define_flag shell_args, short: a, description: "arguments passed to the shell", default: "-leo pipefail"

  def run
    start = Time.now
    check
  end

  private def check
    log "checking status", :light_yellow
    response = HTTP::Client.get uri
    raise UnknownStatus.new("Status Not Reported") unless response.status_code == 202
    log "Aleady Reported", :light_green
  rescue e : UnknownStatus
    log "#{e.message}", :light_yellow, @error_io
  rescue e
    log "#{e.message}", :light_red, @error_io
  end
end