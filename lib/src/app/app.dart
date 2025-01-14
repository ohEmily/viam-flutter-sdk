import 'dart:async';

import '../gen/app/v1/app.pbgrpc.dart';

/// gRPC client for connecting to Viam's App Service
///
/// All calls must be authenticated.
class AppClient {
  final AppServiceClient _client;

  AppClient(this._client);

  /// List all the [Organization] the currently authenticated user has access to
  Future<List<Organization>> listOrganizations() async {
    final listOrganizationsRequest = ListOrganizationsRequest();
    final ListOrganizationsResponse response = await _client.listOrganizations(listOrganizationsRequest);
    return response.organizations;
  }

  /// Get a specific [Organization] by ID
  Future<Organization> getOrganization(String organizationId) async {
    final getOrganizationRequest = GetOrganizationRequest()..organizationId = organizationId;
    final GetOrganizationResponse response = await _client.getOrganization(getOrganizationRequest);
    return response.organization;
  }

  /// List the [Location] of a specific [Organization] that the currently authenticated user has access to
  Future<List<Location>> listLocations(Organization organization) async {
    final listLocationsRequest = ListLocationsRequest()..organizationId = organization.id;
    final ListLocationsResponse response = await _client.listLocations(listLocationsRequest);
    return response.locations;
  }

  /// Get a specific [Location] by ID
  Future<Location> getLocation(String locationId) async {
    final getLocationRequest = GetLocationRequest()..locationId = locationId;
    final GetLocationResponse response = await _client.getLocation(getLocationRequest);
    return response.location;
  }

  /// List the [Robot] of a specific [Location] that the currently authenticated user has access to
  Future<List<Robot>> listRobots(Location location) async {
    final listRobotsRequest = ListRobotsRequest()..locationId = location.id;
    final ListRobotsResponse response = await _client.listRobots(listRobotsRequest);
    return response.robots;
  }

  /// Get a specific [Robot] by ID
  Future<Robot> getRobot(String robotId) async {
    final getRobotRequest = GetRobotRequest()..id = robotId;
    final GetRobotResponse response = await _client.getRobot(getRobotRequest);
    return response.robot;
  }

  /// List the [RobotPart] of a specific [Robot] that the currently authenticated user has access to
  Future<List<RobotPart>> listRobotParts(Robot robot) async {
    final getRobotPartsRequest = GetRobotPartsRequest()..robotId = robot.id;
    final response = await _client.getRobotParts(getRobotPartsRequest);
    return response.parts;
  }

  /// Get a specific [RobotPart] by ID
  Future<RobotPart> getRobotPart(String partId) async {
    final getRobotPartRequest = GetRobotPartRequest()..id = partId;
    final response = await _client.getRobotPart(getRobotPartRequest);
    return response.part;
  }

  /// Get a stream of [LogEntry] for a specific [RobotPart]. Logs are sorted by descending time (newest first)
  Stream<List<LogEntry>> tailLogs(RobotPart part, {bool errorsOnly = false}) {
    final request = TailRobotPartLogsRequest()
      ..id = part.id
      ..errorsOnly = errorsOnly;
    final response = _client.tailRobotPartLogs(request);
    final stream = response.map((event) => event.logs);
    return stream.asBroadcastStream(onCancel: (_) => response.cancel());
  }
}
