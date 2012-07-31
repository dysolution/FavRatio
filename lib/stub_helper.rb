module StubHelper
  def create_string_stubs(id, mock_obj, strings)
    strings.each do |str|
      mock_obj.stub(str).and_return("fake_data#{id}")
    mock_obj
    end
  end
end
