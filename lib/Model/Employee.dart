class Employee {
  final int id;
  final String employee_name;

  Employee({required this.id, required this.employee_name});

  factory Employee.fromJson(Map<String, dynamic> json) =>
      Employee(id: json["id"], employee_name: json["employee_name"]);

  Map<String, dynamic> toJson() => {"id": id, "employee_name": employee_name};
}
