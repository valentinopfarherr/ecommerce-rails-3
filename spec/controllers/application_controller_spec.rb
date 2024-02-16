require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#paginate_collection' do
    let(:collection) { double('Collection') }

    context 'when per_page param is present' do
      it 'paginates the collection with the specified per_page value' do
        allow(controller.params).to receive(:[]).with(:per_page).and_return('20')
        allow(controller.params).to receive(:[]).with(:page).and_return(nil)

        expect(collection).to receive(:page).with(nil).and_return(collection)
        expect(collection).to receive(:per).with('20')

        controller.send(:paginate_collection, collection)
      end
    end

    context 'when per_page param is not present' do
      it 'paginates the collection with a default per_page value of 10' do
        allow(controller.params).to receive(:[]).with(:per_page).and_return(nil)
        allow(controller.params).to receive(:[]).with(:page).and_return(nil)

        expect(collection).to receive(:page).with(nil).and_return(collection)
        expect(collection).to receive(:per).with(10)

        controller.send(:paginate_collection, collection)
      end
    end
  end

  describe '#render_error_response' do
    it 'renders the model errors as JSON with the correct status code' do
      model = double('Model', errors: double('Errors', full_messages: ['Error 1', 'Error 2']))
      expected_response = { error: 'Error 1, Error 2' }

      expect(controller).to receive(:render).with(json: expected_response, status: :unprocessable_entity)

      controller.send(:render_error_response, model)
    end
  end
end
