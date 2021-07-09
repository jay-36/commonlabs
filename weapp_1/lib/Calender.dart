import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';


class CalenderDemo extends StatefulWidget {
  @override
  _CalenderDemoState createState() => _CalenderDemoState();
}

class _CalenderDemoState extends State<CalenderDemo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();

  DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars;
  Calendar _selectedCalendar;
  List<Event> _calendarEvents;
  Map<String, dynamic> mapMin = {};
  List<Reminder> reminders = [Reminder(minutes: 1)];

  _CalenderDemoState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }

  @override
  void initState() {
    super.initState();
    _retrieveCalendars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Event'),
      ),
      body: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 150.0),
            child: ListView.builder(
              itemCount: _calendars?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    await _retrieveCalendarEvents(_calendars[index].id);
                    setState(() {
                      _selectedCalendar = _calendars[index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            _calendars[index].name,
                            style: TextStyle(fontSize: 25.0),
                          ),
                        ),
                        Icon(_calendars[index].isReadOnly
                            ? Icons.lock
                            : Icons.lock_open)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: ListView.builder(
                itemCount: _calendarEvents?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return EventItem(
                      _calendarEvents[index], _deviceCalendarPlugin, () async {
                    await _retrieveCalendarEvents(_selectedCalendar.id);
                  });
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: !(_selectedCalendar?.isReadOnly ?? true)
          ? FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: TextFormField(
                      controller: title,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Enter Something..";
                        } else {
                          return null;
                        }
                      },
                      decoration:
                      InputDecoration(hintText: "Enter Title"),
                    ),
                  ),
                  actions: [
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          final now =
                          DateTime.now().add(Duration(minutes: 1));
                          final eventToCreate =
                          Event(_selectedCalendar.id);
                          eventToCreate.title = title.text;
                          eventToCreate.start = now;
                          eventToCreate.reminders = reminders;
                          eventToCreate.description = "Testing Event";
                          eventToCreate.location = "Surat, Uttran";
                          eventToCreate.end = now.add(Duration(hours: 1));
                          final createEventResult =
                          await _deviceCalendarPlugin
                              .createOrUpdateEvent(eventToCreate);
                          if (createEventResult.isSuccess &&
                              (createEventResult.data?.isNotEmpty ??
                                  false)) {
                            _retrieveCalendarEvents(_selectedCalendar.id);
                          }
                          Navigator.pop(context);
                          title.text = "";
                          setState(() {});
                        }
                      },
                      child: Text("Done"),
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      )
          : Container(),
    );
  }

  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _calendars = calendarsResult?.data;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future _retrieveCalendarEvents(String calendarId) async {
    try {
      final startDate = DateTime.now().add(Duration(days: -30));
      final endDate = DateTime.now().add(Duration(days: 30));
      final retrieveEventsParams =
      RetrieveEventsParams(startDate: startDate, endDate: endDate);
      final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendarId, retrieveEventsParams);
      setState(() {
        _calendarEvents = eventsResult?.data;
      });
    } catch (e) {
      print(e);
    }
  }
}


class EventItem extends StatelessWidget {
  final Event _calendarEvent;
  final DeviceCalendarPlugin _deviceCalendarPlugin;
  final Function onDeleteSucceeded;

  EventItem(
      this._calendarEvent, this._deviceCalendarPlugin, this.onDeleteSucceeded);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            title: Text("Title : " + _calendarEvent.title ?? ''),
            subtitle: Column(
              children: [
                Row(
                  children: [
                    Text("Description : " + _calendarEvent.description ?? ''),
                  ],
                ),
                Row(
                  children: [
                    Text('All day : '),
                    Text(_calendarEvent.allDay != null && _calendarEvent.allDay
                        ? 'Yes'
                        : 'No'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Location : '),
                    Text(
                      _calendarEvent?.location ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () async {
                final deleteResult = await _deviceCalendarPlugin.deleteEvent(
                    _calendarEvent.calendarId, _calendarEvent.eventId);
                if (deleteResult.isSuccess && deleteResult.data) {
                  onDeleteSucceeded();
                }
              },
              icon: Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}