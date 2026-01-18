/// Agent列表查询结果
class AgentListResult {
  final List<Map<String, dynamic>> agents;
  final int total;

  AgentListResult({
    required this.agents,
    required this.total,
  });
}
