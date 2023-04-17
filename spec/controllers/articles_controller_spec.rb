require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let!(:article) { FactoryBot.create(:article) }

  before { subject }

  shared_examples_for 'articles controller actions' do
    it 'assigns instance variable' do
      expect(assigned_var).to eq(expected_value)
    end

    it 'renders the expected template' do
      expect(response).to render_template(template)
    end
  end

  describe "GET index" do
    subject { get :index }
    let(:template) { "index" }
    let(:assigned_var) { assigns(:articles) }
    let(:expected_value) { [article] }

    it_should_behave_like 'articles controller actions'
  end

  describe "GET show" do
    subject { get :show, params: { id: article.id } }
    let(:template) { "show" }
    let(:assigned_var) { assigns(:article) }
    let(:expected_value) { article }

    it_should_behave_like 'articles controller actions'
  end

  describe "POST create" do
    context 'when article fails body validation' do
      subject { post :create, params: { article: { title: 'A test', body: 'invalid' } } }

      it 'should render new view' do
        expect(response).to render_template(:new)
      end

      it 'should have unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when article fails title validation' do
      subject { post :create, params: { article: { body: 'this is a valid body' } } }

      it 'should render new view' do
        expect(response).to render_template(:new)
      end

      it 'should have unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when article is saved successfully' do
      subject { post :create, params: { article: { title: 'A title', body: 'this is a valid body' } } }

      it 'should redirect to show path' do
        created_article = Article.find_by(title: 'A title', body: 'this is a valid body')
        expect(response).to redirect_to("/articles/#{created_article.id}")
      end

      it 'should create a new article' do
        created_article = Article.find_by(title: 'A title', body: 'this is a valid body')
        expect(created_article).not_to be_nil
      end
    end
  end
end
