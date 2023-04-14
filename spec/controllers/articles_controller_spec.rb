require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let!(:article) { FactoryBot.create(:article) }

  before { subject }

  shared_examples_for 'render template' do
    it 'renders the expected template' do
      expect(response).to render_template(template)
    end
  end

  describe "GET index" do
    subject { get :index }
    let(:template) { "index" }

    it "assigns @articles" do
      expect(assigns(:articles)).to eq([article])
    end

    it_should_behave_like 'render template'
  end

  describe "GET show" do
    subject { get :show, params: { id: article.id } }
    let(:template) { "show" }

    it "assigns @article" do
      expect(assigns(:article)).to eq(article)
    end

    it_should_behave_like 'render template'
  end
end
