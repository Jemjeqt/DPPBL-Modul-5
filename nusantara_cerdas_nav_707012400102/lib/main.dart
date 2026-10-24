import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme.dart';
import 'bloc/favorit_bloc.dart';
import 'bloc/laporan_bloc.dart';
import 'bloc/pengajuan_bloc.dart';
import 'navigation/app_routes.dart';

void main() {
  runApp(const AplikasiNusantaraCerdas());
}

class AplikasiNusantaraCerdas extends StatelessWidget {
  const AplikasiNusantaraCerdas({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FavoritBloc()),
        BlocProvider(create: (_) => PengajuanBloc()),
        BlocProvider(create: (_) => LaporanBloc()),
      ],
      child: MaterialApp(
        title: 'Nusantara Cerdas Mobile',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.tema,
        initialRoute: AppRoutes.beranda,
        routes: AppRoutes.daftarRoute(),
        onGenerateRoute: AppRoutes.bentukRoute,
        onUnknownRoute: AppRoutes.routeTidakDikenal,
      ),
    );
  }
}
