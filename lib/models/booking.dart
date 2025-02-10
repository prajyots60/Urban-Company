class Booking {
  final String id;
  final String serviceId;
  final String serviceName;
  final DateTime dateTime;
  final String status;
  final double amount;

  Booking({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.dateTime,
    required this.status,
    required this.amount,
  });
}
