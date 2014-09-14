require 'webrick'
require 'phase5/params'
require 'phase5/controller_base'

describe Phase5::Params do
  before(:all) do
    class CatsController < Phase5::ControllerBase
      def index
        @cats = ["Gizmo"]
      end
    end
  end
  after(:all) { Object.send(:remove_const, "CatsController") }

  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:cats_controller) { CatsController.new(req, res) }

  it "handles an empty request" do
    expect { Phase5::Params.new(req) }.to_not raise_error
  end

  context "query string" do
    it "handles single key and value" do
      req.query_string = "key=val"
      params = Phase5::Params.new(req)
      params["key"].should == "val"
    end

    it "handles multiple keys and values" do
      req.query_string = "key=val&key2=val2"
      params = Phase5::Params.new(req)
      params["key"].should == "val"
      params["key2"].should == "val2"
    end

    it "handles nested keys" do
      req.query_string = "user[address][street]=main"
      params = Phase5::Params.new(req)
      params["user"]["address"]["street"].should == "main"
    end
  end

  context "post body" do
    it "handles single key and value" do
      req.stub(:body) { "key=val" }
      params = Phase5::Params.new(req)
      params["key"].should == "val"
    end

    it "handles multiple keys and values" do
      req.stub(:body) { "key=val&key2=val2" }
      params = Phase5::Params.new(req)
      params["key"].should == "val"
      params["key2"].should == "val2"
    end

    it "handles nested keys" do
      req.stub(:body) { "user[address][street]=main" }
      params = Phase5::Params.new(req)
      params["user"]["address"]["street"].should == "main"
    end
  end

  context "route params" do
    it "handles route params" do
      params = Phase5::Params.new(req, {"id" => 5, "user_id" => 22})
      params["id"].should == 5
      params["user_id"].should == 22
    end
  end
end
