describe Appsignal::Extension do
  if ENV["_TEST_APPSIGNAL_EXTENSION_FAILURE"]
    require "open3"

    context "when the extension library cannot be loaded" do
      it "foo" do
        `cd ext && ruby extconf.rb && make`
        _stdout, stderr, _status = Open3.capture3("bin/appsignal")
        expect(stderr).to include("ERROR: AppSignal failed to load extension")
        expect(stderr).to include("LoadError: cannot load such file")
      end
    end
  end
end
