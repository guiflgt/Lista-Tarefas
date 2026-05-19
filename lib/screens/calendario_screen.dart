import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/tarefa.dart';
import 'login_screen.dart';

class CalendarioScreen extends StatefulWidget {
  final String nomeUsuario;

  const CalendarioScreen({super.key, required this.nomeUsuario});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen>
    with TickerProviderStateMixin {
  DateTime _diaSelecionado = DateTime.now();
  DateTime _diaFocado = DateTime.now();
  final Map<String, List<Tarefa>> _tarefasPorDia = {};
  late AnimationController _fabAnimController;

  String _chaveData(DateTime data) {
    return DateFormat('yyyy-MM-dd').format(data);
  }

  List<Tarefa> _getTarefas(DateTime dia) {
    final tarefas = _tarefasPorDia[_chaveData(dia)] ?? [];
    tarefas.sort((a, b) {
      if (a.concluida == b.concluida) {
        return a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
      }
      return a.concluida ? 1 : -1;
    });
    return tarefas;
  }

  void _adicionarTarefa() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B2838),
                  Color(0xFF0D1B2A),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF00BFA6).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00BFA6).withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00BFA6), Color(0xFF00E5CC)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.add_task_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Nova Tarefa',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat('dd/MM/yyyy').format(_diaSelecionado),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF00E5CC),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: controller,
                  autofocus: true,
                  style: const TextStyle(color: Color(0xFF0D1B2A)),
                  decoration: InputDecoration(
                    hintText: 'Descreva sua tarefa...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.edit_note_rounded,
                      color: Color(0xFF00BFA6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white70,
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.2)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancelar',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.text.trim().isNotEmpty) {
                              setState(() {
                                final chave = _chaveData(_diaSelecionado);
                                _tarefasPorDia.putIfAbsent(
                                    chave, () => []);
                                _tarefasPorDia[chave]!.add(
                                  Tarefa(titulo: controller.text.trim()),
                                );
                              });
                              Navigator.pop(ctx);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00BFA6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            'Adicionar',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removerTarefa(int index) {
    final tarefas = _getTarefas(_diaSelecionado);
    final tarefa = tarefas[index];
    setState(() {
      _tarefasPorDia[_chaveData(_diaSelecionado)]!.remove(tarefa);
      if (_tarefasPorDia[_chaveData(_diaSelecionado)]!.isEmpty) {
        _tarefasPorDia.remove(_chaveData(_diaSelecionado));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '"${tarefa.titulo}" removida',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFFF6B6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              final chave = _chaveData(_diaSelecionado);
              _tarefasPorDia.putIfAbsent(chave, () => []);
              _tarefasPorDia[chave]!.add(tarefa);
            });
          },
        ),
      ),
    );
  }

  void _toggleConcluida(int index) {
    final tarefas = _getTarefas(_diaSelecionado);
    setState(() {
      tarefas[index].concluida = !tarefas[index].concluida;
    });
  }

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fabAnimController.forward();
  }

  @override
  void dispose() {
    _fabAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tarefas = _getTarefas(_diaSelecionado);
    final dataFormatada = DateFormat('dd/MM/yyyy').format(_diaSelecionado);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B2A),
              Color(0xFF1B2838),
              Color(0xFF0D1B2A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bem Vindo,',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white54,
                            ),
                          ),
                          Text(
                            '${widget.nomeUsuario}!',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.logout_rounded,
                            color: Color(0xFFFF6B6B)),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        },
                        tooltip: 'Sair',
                      ),
                    ),
                  ],
                ),
              ),

              // Calendar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF00BFA6),
                      Color(0xFF008C7A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00BFA6).withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                  child: TableCalendar(
                    locale: 'pt_BR',
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _diaFocado,
                    selectedDayPredicate: (day) =>
                        isSameDay(_diaSelecionado, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _diaSelecionado = selectedDay;
                        _diaFocado = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _diaFocado = focusedDay;
                    },
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Mês',
                    },
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      rightChevronIcon: const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      titleTextStyle: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                      weekendStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      weekendTextStyle: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                      outsideTextStyle: GoogleFonts.poppins(
                        color: Colors.white24,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      selectedDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFFF8E53),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Color(0xFFFFD93D),
                        shape: BoxShape.circle,
                      ),
                      markersMaxCount: 3,
                      markerSize: 6,
                      markerMargin: const EdgeInsets.symmetric(horizontal: 1),
                    ),
                    eventLoader: (day) {
                      return _tarefasPorDia[_chaveData(day)] ?? [];
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Task list header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Dia $dataFormatada',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (tarefas.isNotEmpty)
                      Text(
                        '${tarefas.where((t) => t.concluida).length}/${tarefas.length} concluídas',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Legend
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4FC3F7),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Em andamento',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00E676),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Concluída',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Task list
              Expanded(
                child: tarefas.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_rounded,
                              size: 64,
                              color: Colors.white.withOpacity(0.15),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Nenhuma tarefa para este dia',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white30,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Toque em + para adicionar',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white20,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: tarefas.length,
                        itemBuilder: (context, index) {
                          final tarefa = tarefas[index];
                          return Dismissible(
                            key: ValueKey(tarefa.hashCode),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => _removerTarefa(index),
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B6B),
                                    Color(0xFFFF3D3D),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              child: const Icon(
                                Icons.delete_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.07),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: tarefa.concluida
                                      ? const Color(0xFF00E676)
                                          .withOpacity(0.3)
                                      : const Color(0xFF4FC3F7)
                                          .withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                leading: GestureDetector(
                                  onTap: () => _toggleConcluida(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      gradient: tarefa.concluida
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFF00E676),
                                                Color(0xFF00C853),
                                              ],
                                            )
                                          : null,
                                      border: tarefa.concluida
                                          ? null
                                          : Border.all(
                                              color: const Color(0xFF4FC3F7),
                                              width: 2,
                                            ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: tarefa.concluida
                                        ? const Icon(
                                            Icons.check_rounded,
                                            size: 18,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                                title: Text(
                                  tarefa.titulo,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: tarefa.concluida
                                        ? Colors.white38
                                        : Colors.white,
                                    decoration: tarefa.concluida
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor: Colors.white38,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white.withOpacity(0.3),
                                    size: 20,
                                  ),
                                  onPressed: () => _removerTarefa(index),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabAnimController,
          curve: Curves.elasticOut,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00BFA6), Color(0xFF00E5CC)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00BFA6).withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _adicionarTarefa,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add_rounded, size: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
