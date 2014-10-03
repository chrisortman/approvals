require 'spec_helper'
require 'approvals/namers/rspec_namer'

describe Approvals do

  let(:namer) { |example| Approvals::Namers::RSpecNamer.new(example) }

  it "fails" do
    Approvals::Dotfile.stub(:path => '/dev/null')
    lambda {
      Approvals.verify "this one doesn't exist", :namer => namer
    }.should raise_error Approvals::ApprovalError
  end

  it "verifies a string" do
    string = "We have, I fear, confused power with greatness."
    Approvals.verify string, :namer => namer, :format => :text
  end

  it "verifies an array" do
    array = [
      "abc",
      123,
      :zomg_fooooood,
      %w(cheese burger ribs steak bacon)
    ]
    Approvals.verify array, :namer => namer
  end

  it "verifies a hash" do
    hash = {
      :meal => 'breakfast',
      :proteins => '90%',
      :price => 38,
      :delicious => true
    }
    Approvals.verify hash, :namer => namer
  end

  it "verifies a complex object" do
    hello = Object.new
    def hello.to_s
      "Hello, World!"
    end

    def hello.inspect
      "#<The World Says: Hello!>"
    end

    Approvals.verify hello, :namer => namer
  end

  it "verifies html" do
    html = <<-HTML
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd"><html><head><title>Approval</title></head><body><h1>An Approval</h1><p>It has a paragraph</p></body></html>
    HTML
    Approvals.verify html, :format => :html, :namer => namer
  end

  it "verifies a malformed html fragment" do
    html = <<-HTML
<!DOCTYPE html>
<html>
<title>Hoi</title>
<script async defer src="http://foo.com/bar.js"></script>
<h1>yo</h1>
    HTML
    Approvals.verify html, :format => :html, :namer => namer
  end

  it "verifies xml" do
    xml = "<xml char=\"kiddo\"><node><content name='beatrice' /></node><node aliases='5'><content /></node></xml>"
    Approvals.verify xml, :format => :xml, :namer => namer
  end

  it "verifies json" do
    #json = '{"pet":{"name":"Anthony","color":"green","species":"turtle"}}'
    json = '{"pet":{"species":"turtle","color":"green","name":"Anthony"}}'
    Approvals.verify json, :format => :json, :namer => namer
  end


  it "verifies json and is newline agnostic" do
    json = '{"pet":{"species":"turtle","color":"green","name":"Anthony"}}'
    Approvals.verify json, :format => :json, :namer => namer
  end

  it "verifies an array as json when format is set to json" do
    people = [
      {"name" => "Alice", "age" => 28},
      {"name" => "Bob", "age" => 22}
    ]

    Approvals.verify(people, :format => :json, :namer => namer)
  end

  it "verifies an executable" do
    executable = Approvals::Executable.new('SELECT 1') do |command|
      puts "your slip is showing (#{command})"
    end

    Approvals.verify executable, :namer => namer
  end

  it "passes approved files through ERB" do
    $what  = 'greatness'
    string = "We have, I fear, confused power with greatness."
    Approvals.verify string, :namer => namer
  end

  describe "supports excluded keys option" do
    let(:hash) { 
      {:object => {:id => rand(100), :created_at => Time.now, :name => 'test', :deleted_at => nil}} }

    before do
      Approvals.configure do |c|
        c.excluded_json_keys = {
          :id => /(\A|_)id$/,
          :date => /_at$/
        }
      end
    end

    it "verifies json with excluded keys" do
      Approvals.verify JSON.dump(hash), :format => :json, :namer => namer
    end

    it "also supports an array of hashes" do
      Approvals.verify JSON.dump([hash]), :format => :json, :namer => namer
    end

    it "supports the array writer" do
      Approvals.verify [hash], :format => :array, :namer => namer
    end

    it "supports the hash writer" do
      Approvals.verify hash, :format => :array, :namer => namer
    end
  end
end
