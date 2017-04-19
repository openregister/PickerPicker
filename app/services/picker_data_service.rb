class PickerDataService
  def generate(registerUri, fieldName)
    path = Rails.root.join("app", "assets", "static", "picker-input.sample.json");
    return File.read(path);
  end
end
