import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/welcome_repository.dart';
import '../ui/welcome/view_models/welcome_view_model.dart';

List<SingleChildWidget> buildGlobalProviders() => [
  Provider<WelcomeRepository>(
    create: (_) => WelcomeRepositoryImpl(),
  ),
  ChangeNotifierProvider<WelcomeViewModel>(
    create: (ctx) => WelcomeViewModel(ctx.read<WelcomeRepository>()),
  ),
];
