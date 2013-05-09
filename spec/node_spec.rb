require "spec_helper"

describe Mecab::Ext::Node do

  shared_context %{with MeCab::Node like mock which given "test string"}, mecab: :node do
    let(:first_node) do
      n = mock("node").tap {|o| o.stub(:surface).and_return("") }
      n.tap {|o| o.stub(:next).and_return(second_node) }
    end
    let(:second_node) do
      n = mock("node").tap {|o| o.stub(:surface).and_return("test") }
      n.tap {|o| o.stub(:next).and_return(third_node) }
    end
    let(:third_node) do
      n = mock("node").tap {|o| o.stub(:surface).and_return("string") }
      n.tap {|o| o.stub(:next).and_return(fourth_node) }
    end
    let(:fourth_node) do
      n = mock("node").tap {|o| o.stub(:surface).and_return("") }
      n.tap {|o| o.stub(:next).and_return(nil) }
    end
    let(:generator) { double("generator", call: first_node) }
    let(:tests) { Array.new }
  end

  describe "#each" do
    context "with generator mock" do
      let(:generator) { mock("generator").tap {|o| o.should_receive(:call).and_return(nil) } }
      subject { described_class.new(generator) }

      it "calls given generator's :call" do
        subject.each {}
      end

      it "returns self" do
        expect(subject.each {}).to equal subject
      end
    end

    context "with node mocks" do
      let(:node) { mock("node").tap {|o| o.stub(:next).and_return(nil) } }
      let(:parent_node) { mock("node").tap {|o| o.should_receive(:next).and_return(node) } }
      let(:generator) { double("generator").tap {|o| o.stub(:call).and_return(parent_node) } }
      subject { described_class.new(generator) }

      it "calls node#next" do
        subject.each {}
      end

      it " yields sub node" do
        subject.each {|test| expect(test).to equal node }
      end
    end

    context "with mecab nodes", mecab: :node do
      subject { described_class.new(generator) }

      it "yields nodes" do
        subject.each {|test| expect(test).to be_instance_of RSpec::Mocks::Mock }
      end

      it "yields 3 times" do
        subject.each {|test| tests.push test }
        expect(tests).to have(3).yielded_items
      end

      it %{yields nodes that each node have "test", "string", ""} do
        subject.each {|test| tests.push test.surface }
        expect(tests).to eq ["test", "string", ""]
      end
    end
  end

end
