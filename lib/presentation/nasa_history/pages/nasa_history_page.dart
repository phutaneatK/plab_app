import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plab_api/domain/entities/nasa_entity.dart';
import 'package:plab_app/presentation/nasa_history/widgets/nasa_history_card.dart';

import '../bloc/nasa_history_bloc.dart';
import '../bloc/nasa_history_event.dart';
import '../bloc/nasa_history_state.dart';
import '../cubit/nasa_search_query_cubit.dart';
import '../cubit/nasa_search_query_state.dart';
import 'nasa_settings_page.dart';

class NasaHistoryPage extends StatefulWidget {
  const NasaHistoryPage({super.key});

  @override
  State<NasaHistoryPage> createState() => _NasaHistoryPageState();
}

class _NasaHistoryPageState extends State<NasaHistoryPage> {
  @override
  void initState() {
    super.initState();
    // โหลดข้อมูลครั้งแรกหลังจาก build เสร็จ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadList();
    });
  }

  void _loadList() {
    final selectedQuery = context.read<NasaSearchQueryCubit>().state.selectedQuery;
    context.read<NasaHistoryBloc>().add(
      LoadNasaHistory(
        count: 10,
        query: selectedQuery,
      ),
    );
  }

  // สำหรับ RefreshIndicator ต้องคืน Future
  Future<void> _onRefresh() async {
    _loadList();
    // รอให้ bloc ทำงานเสร็จก่อนปิด refresh indicator
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NASA History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'ตั้งค่า',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NasaSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocListener<NasaSearchQueryCubit, NasaSearchQueryState>(
        listenWhen: (previous, current) {
          // ฟังเฉพาะเมื่อ query เปลี่ยนจริงๆ ไม่ฟังตอน init
          return previous.selectedQuery != current.selectedQuery;
        },
        listener: (context, state) {
          // เมื่อ query เปลี่ยนจาก Cubit ให้โหลดข้อมูลใหม่
          _loadList();
        },
        child: Column(
          children: [
            // แสดง query ที่เลือกอยู่ปัจจุบัน
            BlocBuilder<NasaSearchQueryCubit, NasaSearchQueryState>(
              builder: (context, queryState) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Text(
                        'กำลังค้นหา: ${queryState.selectedQuery.displayName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<NasaHistoryBloc, NasaHistoryState>(
                builder: (context, state) {
                  if (state is NasaHistoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is NasaHistoryHasData) {
                    return _buildList(state.items);
                  }

                  if (state is NasaHistoryError) {
                    return _buildError(state.message);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<NasaEntity> items) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return NasaCard(item: item);
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(child: Text(message)),
          ),
        ],
      ),
    );
  }
}
