class TransportationSchedule {
  final String id;
  final String direction; // 'to' or 'from'
  final String time; // e.g., '8:00 AM'
  final List<RouteBus> routes;

  TransportationSchedule({
    required this.id,
    required this.direction,
    required this.time,
    required this.routes,
  });
}

class RouteBus {
  final int routeNumber;
  final List<String> busNumbers;

  RouteBus({required this.routeNumber, required this.busNumbers});
}
