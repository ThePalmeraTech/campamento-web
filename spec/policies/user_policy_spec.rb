require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class.new(user, record) }

  let(:record) { FactoryBot.create(:user) }

  context "being an admin" do
    let(:user) { FactoryBot.create(:user, :admin) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context "being a coder" do
    let(:user) { FactoryBot.create(:user, :coder) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "being a student" do
    let(:user) { FactoryBot.create(:user, :estudiante) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end
end
