import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'src/pie_component.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  directives: const [materialDirectives, PieComponent],
  providers: const [materialProviders],
)
class AppComponent {}
