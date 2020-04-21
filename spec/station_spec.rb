require './lib/station'

describe Station do
  it "has a name" do
    expect(subject).to respond_to(:name)
  end

  it "has a zone" do
    expect(subject).to respond_to(:zone)
  end
end
