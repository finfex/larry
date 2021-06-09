# frozen_string_literal: true

require 'rails_helper'

describe AmlClientSupport do
  let!(:aml_status) { create :aml_status, :default }
  let!(:aml_agreement) { create :aml_agreement }
  let(:user) { create :user, agreement_ids: [aml_agreement.id] }
  let(:aml_client) { user.aml_client }
  let(:client_agreements) { aml_client.client_agreements }

  before do
    allow_any_instance_of(User).to receive(:create_aml_client?).and_return true
  end

  it do
    expect(user).to be_persisted
    expect(client_agreements).to be_any
    expect(client_agreements.where(aml_agreement_id: aml_agreement.id)).to be_exists
  end
end
