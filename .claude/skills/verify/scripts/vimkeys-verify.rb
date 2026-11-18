#!/Users/tuan/.local/share/mise/installs/ruby/latest/bin/ruby --disable-gems
# frozen_string_literal: true
# vimkeys-verify.rb -- start, check, capture and stop a throwaway Claude Code TUI
# that loads the vim-cheatsheet plugin from the checkout under test.
# PATTERN: none -- one verb dispatch over testenv and tmux, below the design-pattern threshold
# STYLE: ruby-script skill -- exit 0/1/2 + errors as data with a hint (AXI), argv-array Open3

require "json"
require "open3"
require "optparse"
require "fileutils"

module VimkeysVerify
  TESTENV = File.expand_path("~/.claude/bin/testenv.rb")
  SHOOT = File.expand_path("~/.claude/bin/shoot-proof.rb")
  ENV_BASE = "/private/tmp/cc-testenv"
  COLS = 160
  ROWS = 80
  ANSI = /\e\][^\a\e]*(?:\a|\e\\)|\e\[[0-9;?]*[ -\/]*[@-~]/ # OSC (links) and CSI (colours)
  USAGE = <<~TXT
    usage: vimkeys-verify.rb <verb> [--name NAME] [args]

    verbs:
      up            build env NAME from the checkout you stand in, start claude with
                    --plugin-dir on it, resize the pane to #{COLS}x#{ROWS}
      doctor        read-only: env, source sha, tui, plugin manifest, editorMode
      snap <stem>   write <stem>.txt (screen text) and <stem>.png (rendered screen)
      down          stop the tui and remove env NAME (--dry-run: list only)

    options:
      --name NAME   testenv name (default: vimkeys-verify)
      --dry-run     down only: print the targets, remove nothing
      -h, --help    this help

    examples:
      vimkeys-verify.rb up
      vimkeys-verify.rb doctor
      vimkeys-verify.rb snap .claude/cycles/<cycle>/verify/open-pane/01-pane

    drive between up and down with: testenv.rb tui <NAME> send|keys|read (testenv.rb tui --help)
    exit: 0 ok · 1 failure (error: + hint: lines) · 2 usage error
  TXT

  Failure = Class.new(StandardError)
  Usage = Class.new(StandardError)

  module_function

  def run(argv)
    name = "vimkeys-verify"
    dry = false
    parser = OptionParser.new do |o|
      o.on("--name NAME") { |v| name = v }
      o.on("--dry-run") { dry = true }
      o.on("-h", "--help") { puts USAGE; return 0 }
    end
    args = parser.parse(argv)
    verb = args.shift
    raise Usage, "--dry-run belongs to down only" if dry && verb != "down"

    case verb
    when "up" then up(name)
    when "doctor" then doctor(name)
    when "snap" then snap(name, args.first || raise(Usage, "snap needs <stem>"))
    when "down" then down(name, dry:)
    when nil then raise Usage, "missing verb"
    else raise Usage, "unknown verb #{verb} (up, doctor, snap, down)"
    end
  rescue OptionParser::ParseError, Usage => e
    puts "error: #{e.message}\nhint: vimkeys-verify.rb --help"
    2
  rescue Failure => e
    puts e.message
    1
  end

  def fail!(msg, hint) = raise(Failure, "error: #{msg}\nhint: #{hint}")

  def sh(*cmd)
    out, st = Open3.capture2e(*cmd)
    [out, st.success?]
  end

  def must(*cmd, hint:)
    out, ok = sh(*cmd)
    fail!("#{cmd.first(3).join(" ")} failed\n#{out.strip}", hint) unless ok

    out
  end

  def root
    out, ok = sh("git", "rev-parse", "--show-toplevel")
    fail!("not inside a git checkout", "cd into the vim-cheatsheet checkout or cycle worktree") unless ok

    out.strip
  end

  def env_root(name) = File.join(ENV_BASE, name)
  def tmux_socket(name) = "cc-testenv-#{name}"

  def up(name)
    src = root
    must(TESTENV, "up", name, "--from", src, hint: "testenv.rb down #{name}, then up again")
    started = must(TESTENV, "tui", name, "start", "--", "--plugin-dir", env_root(name),
                   hint: "testenv.rb tui #{name} read shows the screen; down + up resets")
    must("tmux", "-L", tmux_socket(name), "resize-window", "-t", "claude", "-x", COLS.to_s, "-y", ROWS.to_s,
         hint: "the tui is not running: vimkeys-verify.rb down, then up")
    puts started.lines.first(6).join
    puts "plugin: #{env_root(name)} (copy of #{src})"
    puts "next: vimkeys-verify.rb doctor --name #{name}"
    0
  end

  def doctor(name)
    problems = []
    meta_path = File.join(env_root(name), ".testenv", "meta.json")
    unless File.exist?(meta_path)
      puts "doctor: env #{name} absent\nhint: vimkeys-verify.rb up --name #{name}"
      return 1
    end
    meta = JSON.parse(File.read(meta_path))
    src = root
    head, = sh("git", "-C", src, "rev-parse", "HEAD")
    dirty, = sh("git", "-C", src, "status", "--porcelain")
    puts "env: #{env_root(name)} from #{meta["from"]} @ #{meta["head"][0, 7]}"
    problems << "env built from #{meta["from"]}, you stand in #{src}" unless File.realpath(meta["from"]) == File.realpath(src)
    problems << "env head #{meta["head"][0, 7]} != checkout HEAD #{head.strip[0, 7]}" unless meta["head"] == head.strip
    puts "note: checkout has uncommitted changes; the env holds them as of #{meta["created_at"]}" unless dirty.strip.empty?
    manifest = File.join(env_root(name), ".claude-plugin", "plugin.json")
    if File.exist?(manifest)
      puts "plugin: #{JSON.parse(File.read(manifest))["version"]}"
    else
      problems << "no .claude-plugin/plugin.json in the env"
    end
    tui, ok = sh(TESTENV, "tui", name)
    state = tui[/^state: (.*)$/, 1] || "unknown"
    puts "tui: #{state} #{tui[/^claude-pid: (\d+)/, 1]}"
    problems << "tui not running" unless ok && state == "running"
    settings = File.join(env_root(name), "settings.json")
    mode = File.exist?(settings) ? JSON.parse(File.read(settings))["editorMode"] : nil
    puts "editorMode: #{mode || "normal (unset)"}"
    if problems.empty?
      puts "doctor: ok"
      return 0
    end
    problems.each { |p| puts "problem: #{p}" }
    puts "hint: vimkeys-verify.rb down --name #{name}, then up"
    1
  end

  def snap(name, stem)
    FileUtils.mkdir_p(File.dirname(File.expand_path(stem)))
    out, ok = sh(SHOOT, "-L", tmux_socket(name), "claude", stem)
    FileUtils.rm_f("#{stem}.raw.txt")
    fail!("no screen captured\n#{out.strip}", "vimkeys-verify.rb doctor --name #{name}") unless File.exist?("#{stem}.txt")
    File.write("#{stem}.txt", File.read("#{stem}.txt").gsub(ANSI, ""))
    puts "snap: #{stem}.txt#{ok ? " #{stem}.png" : " (png render failed, text kept)"}"
    0
  end

  def down(name, dry:)
    if dry
      puts "would remove: tmux server #{tmux_socket(name)}, env #{env_root(name)}#{File.exist?(env_root(name)) ? "" : " (absent)"}"
      return 0
    end
    out = must(TESTENV, "down", name, hint: "run it from outside the env's own session")
    puts out.lines.last(3).join
    0
  end
end

exit VimkeysVerify.run(ARGV) if $PROGRAM_NAME == __FILE__
