part of '../main.dart';

class DropdownWidget extends StatefulWidget {
  DropdownWidget({ this.key: null, this.hint: null, this.value: null, this.items: null, this.required: false, this.onChanged: null });
  GlobalKey<DropdownWidgetState> key = null;
  String hint = null;
  String value = null;
  Map<String, String> items = null;
  bool required = false;
  ValueChanged<String> onChanged = null;

  @override
  DropdownWidgetState createState() {
    return DropdownWidgetState(hint, value, items, required, onChanged);
  }
}

class DropdownWidgetState extends State<DropdownWidget> {
  DropdownWidgetState(this.hint, this.value, this.items, this.required, this.onChanged);
  String hint = null;
  String value = null;
  Map<String, String> items = null;
  bool required = false;
  ValueChanged<String> onChanged = null;

  String _validationMessage = null;

  void setValue(value) {
    this.value = value;
  }
  void resetValidation() {
    _validationMessage = null;
  }

  @override
  initState() {
    super.initState();
    _validationMessage = null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) {
        if (this.required && value == null) {
          // return 'Required';
          _validationMessage = 'Required';
        } else {
          _validationMessage = null;
        }
      },
      onSaved: (value) {
        this.value = value;
      },
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonHideUnderline(
              child: Container(
                decoration: new BoxDecoration(
                  color: dropdownBackgroundColour,
                  border: _validationMessage != null
                  ? Border(bottom: BorderSide(width: 1.0, color: dropdownValidationColour))
                  : Border(bottom: BorderSide(width: 1.5, color: dropdownBorderColour)),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: dropdownHorizontalSpacing),
                  child: DropdownButton<String>(
                    hint: Text(
                      this.hint,
                      style: TextStyle(color: dropdownHintColour),
                    ),
                    style: TextStyle(
                      fontSize: dropdownFontSize,
                      color: dropdownColour
                    ),
                    value: this.value,
                    isExpanded: true,
                    onChanged: (String value) {
                      state.didChange(value);
                      this.value = value;
                      this.onChanged(value);
                    },
                    items: items.entries
                      .map<DropdownMenuItem<String>>(
                        (MapEntry<String, String> country) => DropdownMenuItem<String>(
                          value: country.key,
                          child: Text(country.value),
                        ))
                      .toList(),
                  )
                )
              )
            ),
            _validationMessage != null
            ? Container(
              margin: EdgeInsets.only(top: 8.0, left: 10.0, bottom: 1.0),
              child: Text(_validationMessage, 
                style: TextStyle(fontSize: dropdownValidationFontSize, color: dropdownValidationColour),
              )
            )
            : Container(),
          ]
        );
      }
    );
  }
}
