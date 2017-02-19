describe Appsignal::Hooks::RedisHook do
  before do
    Appsignal.config = project_fixture_config
  end

  context "with redis" do
    before :context do
      class Redis
        class Client
          def process(_commands)
            1
          end
        end
        VERSION = "1.0"
      end
    end
    after(:context) { Object.send(:remove_const, :Redis) }

    context "with instrumentation enabled" do
      before do
        Appsignal.config.config_hash[:instrument_redis] = true
        Appsignal::Hooks::RedisHook.new.install
      end

      describe "#dependencies_present?" do
        subject { described_class.new.dependencies_present? }

        it { is_expected.to be_truthy }
      end

      it "should instrument a redis call" do
        Appsignal::Transaction.create("uuid", Appsignal::Transaction::HTTP_REQUEST, "test")
        expect(Appsignal::Transaction.current).to receive(:start_event)
          .at_least(:once)
        expect(Appsignal::Transaction.current).to receive(:finish_event)
          .at_least(:once)
          .with("query.redis", nil, nil, 0)

        client = Redis::Client.new

        expect(client.process([])).to eq 1
      end
    end

    context "with instrumentation disabled" do
      before do
        Appsignal.config.config_hash[:instrument_redis] = false
      end

      describe "#dependencies_present?" do
        subject { described_class.new.dependencies_present? }

        it { is_expected.to be_falsy }
      end
    end
  end

  context "without redis" do
    describe "#dependencies_present?" do
      subject { described_class.new.dependencies_present? }

      it { is_expected.to be_falsy }
    end
  end
end
