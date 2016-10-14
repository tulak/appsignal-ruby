require "appsignal/cli"

describe Appsignal::CLI do
  let(:out_stream) { StringIO.new }
  let(:output) { out_stream.string }
  let(:cli) { Appsignal::CLI }
  around do |example|
    Dir.chdir(project_fixture_path) do
      capture_stdout(out_stream) { example.run }
    end
  end

  it "prints the help with no arguments, -h and --help" do
    [nil, "-h", "--help"].each do |arg|
      expect do
        cli.run([nil, arg])
      end.to raise_error(SystemExit)

      expect(output).to include "appsignal <command> [options]"
      commands = described_class::COMMANDS.keys.map { |k| "\n  #{k}" }

      expect(output).to include(*commands)
    end
  end

  it "prints the version with -v and --version" do
    ["-v", "--version"].each do |arg|
      expect do
        cli.run([nil, arg])
      end.to raise_error(SystemExit)

      expect(output).to include "AppSignal #{Appsignal::VERSION}"
    end
  end

  context "when a command does not exist" do
    it "prints a notice that the command does not exist" do
      expect do
        cli.run(["nonsense"])
      end.to raise_error(SystemExit)

      expect(output).to include "Command 'nonsense' does not exist, run "\
        "appsignal --help to see the help"
    end
  end
end
