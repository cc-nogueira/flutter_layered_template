import 'app_layer.dart';
import 'domain_provisioning.dart';

final domainLayer = DomainLayer();

class DomainLayer extends AppLayer {
  late final DataLayerProvision dataProvision;
  late final ServiceLayerProvision serviceProvision;

  void provisioning({required DataLayerProvision dataProvision, required ServiceLayerProvision serviceProvision}) {
    this.dataProvision = dataProvision;
    this.serviceProvision = serviceProvision;
  }
}
