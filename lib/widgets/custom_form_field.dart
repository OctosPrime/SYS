import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomFormField extends StatelessWidget {
  final bool obscureText;
  final String hintText;
  final String? Function(String?) validator;
  final Function(String?) onSaved;

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.validator,
    required this.onSaved,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(hintText: hintText),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}

class CustomDropdownField extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? Function(String?) validator;
  final Function(String?) onSaved;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.items,
    required this.validator,
    required this.onSaved,
  });

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: widget.hintText,
        ),
        value: selectedValue,
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
          });
        },
        validator: widget.validator,
        onSaved: widget.onSaved,
      ),
    );
  }
}

class CustomDatePickerField extends StatefulWidget {
  final String hintText;
  final Function(String?) onSaved;
  final String? Function(String?) validator;

  const CustomDatePickerField({
    super.key,
    required this.hintText,
    required this.onSaved,
    required this.validator,
  });

  @override
  _CustomDatePickerFieldState createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
        validator: widget.validator,
        onSaved: (value) {
          widget.onSaved(_controller.text);
        },
      ),
    );
  }
}

class CustomTimePickerField extends StatefulWidget {
  final String hintText;
  final Function(String?) onSaved;
  final String? Function(String?) validator;

  const CustomTimePickerField({
    super.key,
    required this.hintText,
    required this.onSaved,
    required this.validator,
  });

  @override
  _CustomTimePickerFieldState createState() => _CustomTimePickerFieldState();
}

class _CustomTimePickerFieldState extends State<CustomTimePickerField> {
  TextEditingController _controller = TextEditingController();
  TimeOfDay? _selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _controller.text = _selectedTime!.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
        ),
        readOnly: true,
        onTap: () => _selectTime(context),
        validator: widget.validator,
        onSaved: (value) {
          widget.onSaved(_controller.text);
        },
      ),
    );
  }
}

class CustomLargeTextField extends StatelessWidget {
  final String hintText;
  final String? Function(String?) validator;
  final Function(String?) onSaved;

  const CustomLargeTextField({
    super.key,
    required this.hintText,
    required this.validator,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
        maxLines:
            null, // Permite que a altura da caixa de texto seja expandida conforme necessário
        minLines: 5, // Define a altura mínima da caixa de texto
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
