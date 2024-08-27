import 'package:earthquake_app/pages/map_page.dart';
import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:earthquake_app/settings_page.dart';
import 'package:earthquake_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    Provider.of<AppDataProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake App'),
        actions: [
          IconButton(
            onPressed: _showSortingDialog,
            icon: const Icon(Icons.sort)
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
            icon: const Icon(Icons.settings)
          )
        ],
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) => provider.hasDataLoaded ?
          provider.earthquakeModel!.features!.isEmpty ?
          const Center(child: Text('No records found')) :
          Padding(
            padding: const EdgeInsets.all(14),
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemCount: provider.earthquakeModel!.features!.length,
              itemBuilder: (context, index) {
                final data = provider.earthquakeModel!.features![index].properties;
                final geometry = provider.earthquakeModel!.features![index].geometry;
                final title = data!.place ?? data.title ?? 'Unknown';
                double longitude = geometry!.coordinates![0].toDouble();
                double latitude = geometry.coordinates![1].toDouble();

                return ListTile(
                  title: Text(title),
                  subtitle: Text(getFormattedDateTime(data.time!, 'EEE MMM dd yyyy hh:mm a')),
                  contentPadding: EdgeInsets.zero,
                  trailing: Chip(
                    avatar: data.alert == null ? null : CircleAvatar(backgroundColor: provider.getAlertColor(data.alert!)),
                    label: Text('${data.mag}')
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage(latitude: latitude, longitude: longitude, title: title)));
                  }
                );
              }
            ),
          )
          : const Center(child: Text('Please wait...'))
      )
    );
  }

  void _showSortingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort By'),
        content: Consumer<AppDataProvider>(
          builder: (context, provider, child) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioGroup(
                groupValue: provider.orderBy,
                value: 'magnitude',
                label: 'Magnitude Descending',
                onChange: (value) {
                  provider.setOrder(value!);
                }
              ),

              RadioGroup(
                groupValue: provider.orderBy,
                value: 'magnitude-asc',
                label: 'Magnitude Ascending',
                onChange: (value) {
                  provider.setOrder(value!);
                }
              ),

              RadioGroup(
                groupValue: provider.orderBy,
                value: 'time',
                label: 'Time Descending',
                onChange: (value) {
                  provider.setOrder(value!);
                }
              ),

              RadioGroup(
                groupValue: provider.orderBy,
                value: 'time-asc',
                label: 'Time Ascending',
                onChange: (value) {
                  provider.setOrder(value!);
                }
              ),
            ]
          )
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close')
          )
        ]
      )
    );
  }
}

class RadioGroup extends StatelessWidget {
  final String groupValue;
  final String value;
  final String label;
  final Function(String?) onChange;

  const RadioGroup({super.key, required this.groupValue, required this.value, required this.label, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChange,
        ),
        Text(label)
      ]
    );
  }
}
