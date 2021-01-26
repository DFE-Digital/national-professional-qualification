require "rails_helper"

RSpec.describe User, type: :model do
  describe "#admin?" do
    it "returns for non admin roles" do
      subject = create(:user)
      expect(subject.admin?).to be_falsy
    end

    it "returns true for admin roles" do
      subject = create(:user, :admin)
      expect(subject.admin?).to be_truthy
    end
  end
end
