import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pofel_app/src/ui/components/pofel_modal.dart';

class SimpleDateTimePicker extends StatefulWidget {
  const SimpleDateTimePicker({
    super.key,
    required this.onChanged,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.labelText = 'Datum a cas',
  });

  final ValueChanged<DateTime> onChanged;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String labelText;

  @override
  State<SimpleDateTimePicker> createState() => _SimpleDateTimePickerState();
}

class _SimpleDateTimePickerState extends State<SimpleDateTimePicker> {
  static const _pickerLocale = Locale('cs', 'CZ');
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final formattedValue = _selectedDateTime == null
        ? widget.labelText
        : DateFormat('dd.MM.yyyy HH:mm', 'cs_CZ').format(_selectedDateTime!);

    return InkWell(
      onTap: _pickDateTime,
      child: InputDecorator(
        decoration: pofelModalInputDecoration(
          labelText: widget.labelText,
          hintText: 'Vyber datum a čas',
          prefixIcon: Icons.event_rounded,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formattedValue),
            const Icon(Icons.calendar_today_rounded),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final firstDate = widget.firstDate ?? DateTime(now.year - 10);
    final lastDate = widget.lastDate ?? DateTime(now.year + 20);
    final currentDate = _clampDate(
        _selectedDateTime ?? widget.initialDate ?? now, firstDate, lastDate);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: _pickerLocale,
    );
    if (pickedDate == null || !mounted) {
      return;
    }

    final initialTime =
        TimeOfDay.fromDateTime(_selectedDateTime ?? currentDate);
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (pickedTime == null) {
      return;
    }

    final pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _selectedDateTime = pickedDateTime;
    });
    widget.onChanged(pickedDateTime);
  }

  DateTime _clampDate(DateTime value, DateTime firstDate, DateTime lastDate) {
    if (value.isBefore(firstDate)) {
      return firstDate;
    }
    if (value.isAfter(lastDate)) {
      return lastDate;
    }
    return value;
  }
}
