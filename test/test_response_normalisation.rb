require 'minitest/autorun'
require 'zanox_api'

class ResponseNormalisationTestt < Minitest::Test
  def test_response_normalisation
    test_response_object = { key: :value }
    assert_equal [ test_response_object ],
      Zanox::API.normalize_response({ items: "1", some_items: { some_item: [ test_response_object ] } })
  end
end
