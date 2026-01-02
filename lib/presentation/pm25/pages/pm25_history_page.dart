import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plab_api/domain/enums/pm_province_enum.dart';
import 'package:plab_app/presentation/pm25/blocs/pm25_bloc.dart';
import 'package:plab_app/presentation/pm25/blocs/pm25_event.dart';
import 'package:plab_app/presentation/pm25/blocs/pm25_state.dart';
import 'package:plab_app/utlis.dart';

class Pm25HistoryPage extends StatefulWidget {
  const Pm25HistoryPage({super.key});

  static const String routerName = 'pm25_history_page';

  @override
  State<Pm25HistoryPage> createState() => _Pm25HistoryPageState();
}

class _Pm25HistoryPageState extends State<Pm25HistoryPage> {
  @override
  void initState() {
    super.initState();
    log('Pm25HistoryPage: initState ~');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadList();
    });
  }

  _loadList() {
    context.read<Pm25Bloc>().add(loadPm25History(search: ''));
  }

  Future<void> _onRefresh() async {
    _loadList();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Color _getAqiColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow.shade700;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.brown;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Pm25Bloc, Pm25State>(
      builder: (context, state) {
        if (state is Pm25Loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is Pm25HasHasData) {
          if (state.datas.isEmpty) {
            return const Center(child: Text('ไม่มีข้อมูล'));
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.datas.length,
              itemBuilder: (context, index) {
                final item = state.datas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getAqiColor(item.aqi),
                      child: Text(
                        '${item.aqi.toInt()}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text('${PMProvinceEnum.toDisplayName(item.code)}',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PM2.5: ${item.pm25.toStringAsFixed(1)}'),
                        Text('AQI: ${item.aqi}'),
                        Text(
                          'Location: ${item.latitude.toStringAsFixed(2)}, ${item.longitude.toStringAsFixed(2)}',
                        ),
                        if (item.time != null) Text('Time: ${item.time}'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          );
        }

        if (state is Pm25Error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadList,
                  icon: const Icon(Icons.refresh),
                  label: const Text('ลองใหม่อีกครั้ง'),
                ),
              ],
            ),
          );
        }

        // Pm25Initial state
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('กดปุ่มด้านบนเพื่อโหลดข้อมูล'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loadList,
                icon: const Icon(Icons.refresh),
                label: const Text('โหลดข้อมูล PM2.5'),
              ),
            ],
          ),
        );
      },
    );
  }
}
