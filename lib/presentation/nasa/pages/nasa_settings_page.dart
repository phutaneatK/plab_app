import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plab_api/domain/enums/nasa_search_enum.dart';

import '../cubit/nasa_search_query_cubit.dart';
import '../cubit/nasa_search_query_state.dart';

class NasaSettingsPage extends StatefulWidget {
  const NasaSettingsPage({super.key});

  static const String routerName = 'nasa_settings_page';

  @override
  State<NasaSettingsPage> createState() => _NasaSettingsPageState();
}

class _NasaSettingsPageState extends State<NasaSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่าการค้นหา'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset เป็นค่าเริ่มต้น',
            onPressed: () {
              context.read<NasaSearchQueryCubit>().resetToDefault();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('รีเซ็ตเป็นค่าเริ่มต้นแล้ว')),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NasaSearchQueryCubit, NasaSearchQueryState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'เลือกหัวข้อการค้นหา',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'การเปลี่ยนแปลงจะมีผลทันทีในหน้ารายการ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<NasaSearchEnum>(
                        value: state.selectedQuery,
                        decoration: const InputDecoration(
                          labelText: 'หัวข้อค้นหา',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                        items: NasaSearchEnum.values.map((query) {
                          return DropdownMenuItem(
                            value: query,
                            child: Row(
                              children: [
                                _getIcon(query),
                                const SizedBox(width: 12),
                                Text(query.displayName),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            context.read<NasaSearchQueryCubit>().changeQuery(
                              value,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ตัวเลือกทั้งหมด',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ...NasaSearchEnum.values.map((query) {
                        final isSelected = state.selectedQuery == query;
                        return ListTile(
                          leading: _getIcon(query),
                          title: Text(query.displayName),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                )
                              : const Icon(Icons.circle_outlined),
                          onTap: () {
                            context.read<NasaSearchQueryCubit>().changeQuery(
                              query,
                            );
                          },
                          selected: isSelected,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _getIcon(NasaSearchEnum query) {
    switch (query) {
      case NasaSearchEnum.earth:
        return const Icon(Icons.public, color: Colors.blue);
      case NasaSearchEnum.sun:
        return const Icon(Icons.wb_sunny, color: Colors.orange);
      case NasaSearchEnum.moon:
        return const Icon(Icons.nightlight_round, color: Colors.grey);
    }
  }
}
