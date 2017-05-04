# Picker Picker

This service uses the following tools to generate a working picker based on register data

- accessible-typeahead (https://unpkg.com/accessible-typeahead)
- openregister-picker-engine (https://unpkg.com/openregister-picker-engine)

### Building and running

```
brew install chicken
chicken-install medea csv-xml clojurian list-utils vector-lib utf8

git clone -b picker-picker --single-branch git@github.com:openregister/kibitz.git
git clone git@github.com:openregister/morc.git

cd morc
chicken-install

cd PickerPicker
bundle stall
rails server
```