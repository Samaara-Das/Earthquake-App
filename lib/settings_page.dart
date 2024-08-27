import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:earthquake_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Scaffold(
        body: Consumer<AppDataProvider>(
          builder: (context, provider, child) =>
          ListView(
            padding: EdgeInsets.all(8),
            children: [
              Text('Time Settings', style: Theme.of(context).textTheme.titleMedium),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Start date'),
                      subtitle: Text(provider.startTime),
                      trailing: IconButton(
                        onPressed: () async {
                          final date = await selectDate();
                          if(date != null) {
                            provider.setStartTime(date);
                          }
                        },
                        icon: Icon(Icons.calendar_month)
                      ),
                    ),

                    ListTile(
                      title: Text('End date'),
                      subtitle: Text(provider.endTime),
                      trailing: IconButton(
                        onPressed: () async {
                          final date = await selectDate();
                          if(date != null) {
                            provider.setEndTime(date);
                          }
                        },
                        icon: Icon(Icons.calendar_month)
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        provider.getEarthquakeData();
                        showMsg(context, 'Dates are updated!');
                      },
                      child: Text('Update Date Changes')
                    )
                  ],
                )
              ),

              Text('Location Settings', style: Theme.of(context).textTheme.titleMedium),

              Card(
                child: SwitchListTile(
                  title: Text(provider.currentCity ?? 'Your city is unknown'),
                  subtitle: provider.currentCity == null ? null:Text('Earthquake data will be shown within a ${provider.maxRadiusKm.toDouble().round()}km radius from ${provider.currentCity}'),
                  value: provider.shouldUseLocation,
                  onChanged: (value) async {
                    EasyLoading.show(status: 'Getting location');
                    await provider.setLocation(value);
                    EasyLoading.dismiss();
                  }
                )
              ),

              Text('Minimum Magnitude', style: Theme.of(context).textTheme.titleMedium),

              Card(
                child: Column(
                  children: [
                    Slider(
                      value: double.parse(provider.minMagnitude),
                      min: 1,
                      max: 10,
                      onChanged: (double value) {
                        setState(() {
                          provider.setMinMagnitude(value);
                        });
                      },
                      divisions: 10,
                      label: provider.minMagnitude,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        provider.getEarthquakeData();
                        showMsg(context, 'Minimum magnitude is updated!');
                      },
                      child: const Text('Update Minimum Magnitude')
                    ),
                  ],
                )
              ),

              Text('Maximum Radius', style: Theme.of(context).textTheme.titleMedium),

              Card(
                child: Column(
                  children: [
                    Slider(
                      value: provider.maxRadiusKm,
                      min: 500,
                      max: provider.maxRadiusKmThreshold,
                      onChanged: (double value) {
                        setState(() {
                          provider.setMaxRadiusKm(value);
                        });
                      },
                      divisions: 10,
                      label: provider.maxRadiusKm.toString(),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        provider.getEarthquakeData();
                        showMsg(context, 'Maximum radius is updated!');
                      },
                      child: const Text('Update Maximum Radius')
                    ),
                  ],
                )
              )

            ]
          ),
        ),
      ),
    );
  }

  Future<String?>? selectDate() async {
    final dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    return dt != null ? getFormattedDateTime(dt.millisecondsSinceEpoch) : null;
  }
}
