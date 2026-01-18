import 'package:flutter/material.dart';
import '../services/agent_service.dart';

class AgentPage extends StatefulWidget {
  const AgentPage({super.key});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  List<Map<String, dynamic>> _agents = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAgents();
  }

  Future<void> _loadAgents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await AgentService.getAgentList();
      setState(() {
        _agents = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAgents,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _agents.isEmpty
              ? const Center(
                  child: Text('暂无Agent', style: TextStyle(fontSize: 16)),
                )
              : RefreshIndicator(
                  onRefresh: _loadAgents,
                  child: ListView.builder(
                    itemCount: _agents.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final agent = _agents[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.smart_toy),
                          title: Text(agent['name'] ?? '未命名'),
                          subtitle: Text(
                            agent['description'] ?? '暂无描述',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Navigate to agent detail
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show create agent dialog
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
