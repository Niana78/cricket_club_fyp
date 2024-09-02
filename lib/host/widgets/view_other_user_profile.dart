import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

import '../../configurations/config.dart';
import '../../constants/color_theme.dart';

class ViewOtherUserProfile extends StatefulWidget {
  final String userId;

  const ViewOtherUserProfile({Key? key, required this.userId}) : super(key: key);

  @override
  State<ViewOtherUserProfile> createState() => _ViewOtherUserProfileState();
}

class _ViewOtherUserProfileState extends State<ViewOtherUserProfile> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String _profilePictureUrl = '';

  @override
  void initState() {
    print("initState called");
    super.initState();
    _fetchUserDetails();
    // _mockUserData(); // Uncomment this line to use mock data
  }

  Future<void> _fetchUserDetails() async {
    print("Fetching user details..."); // This should print first
    try {
      final response = await http.get(Uri.parse('$getuserdetails${widget.userId}'));

      print("Server response status: ${response.statusCode}");
      print("Server response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("Decoded JSON: $data");

        if (data['status'] == true && data.containsKey('user')) {
          final user = data['user'];

          print("User Data: $user"); // Print user data
          final String? profilePictureUrl = user['profilePictureUrl'];
          final String fullProfilePictureUrl = profilePictureUrl != null
              ? '$baseurl$profilePictureUrl'.replaceAll('\\', '/')
              : _profilePictureUrl;

          setState(() {
            _userData = user;
            _isLoading = false;
            _profilePictureUrl = fullProfilePictureUrl;
          });

          print("Profile picture URL set: $_profilePictureUrl");
        } else {
          print('Invalid response structure or status.');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('Failed to load user details. Status code: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching user details: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _mockUserData() {
    _userData = {
      'name': 'John Doe',
      'role': 'Batsman',
      'team': 'National Team',
      'profilePictureUrl': '/profile/johndoe.png',
      'matches': 100,
      'runs': 4000,
      'wickets': 150,
      'average': 50.0,
      'strikeRate': 120.5,
      'bestScore': '200*',
      'matchLog': [
        {'match': 'Match 1', 'runs': '50', 'wickets': '2', 'performance': 'Good'},
        {'match': 'Match 2', 'runs': '75', 'wickets': '3', 'performance': 'Very Good'},
        {'match': 'Match 3', 'runs': '100', 'wickets': '1', 'performance': 'Excellent'},
      ],
      'achievements': ['Man of the Match', 'Best Batsman', 'Century'],
    };
    print("Mock Data: $_userData");
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'User Profile',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: CricketClubTheme().white,
          ),
        ),
        backgroundColor: CricketClubTheme().eeriesturquoise,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlayerOverview(),
            SizedBox(height: 16.0),
            _buildPerformanceMetrics(),
            SizedBox(height: 16.0),
            _buildCharts(),
            SizedBox(height: 16.0),
            _buildAchievements(),
            SizedBox(height: 16.0),
            _buildMatchLog(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerOverview() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: _profilePictureUrl.isNotEmpty
              ? NetworkImage(Uri.encodeFull(_profilePictureUrl))
              : AssetImage('assets/images/main_logo.png') as ImageProvider,
        ),
        SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _userData?['name'] ?? 'N/A',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              _userData?['role'] ?? 'Batsman',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            Text(
              _userData?['team'] ?? 'National Team',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerformanceMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Performance Metrics',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMetricCard(
                'Matches', _userData?['matches']?.toString() ?? 'N/A'),
            _buildMetricCard('Runs', _userData?['runs']?.toString() ?? 'N/A'),
            _buildMetricCard(
                'Wickets', _userData?['wickets']?.toString() ?? 'N/A'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMetricCard(
                'Average', _userData?['average']?.toString() ?? 'N/A'),
            _buildMetricCard(
                'Strike Rate', _userData?['strikeRate']?.toString() ?? 'N/A'),
            _buildMetricCard('Best Score', _userData?['bestScore'] ?? 'N/A'),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Card(
      elevation: 4,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text(
                title, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget _buildCharts() {
    if (_userData == null || _userData?['matchLog'] == null) {
      print('User data or match log is null.');
      return Text('No match data available.');
    }

    List<dynamic>? matchLog = _userData?['matchLog'];
    if (matchLog is! List) {
      print("Match log is not a list: $matchLog");
      return Text('Invalid match log data.');
    }

    List<FlSpot> chartData = [];
    for (int i = 0; i < matchLog.length; i++) {
      final log = matchLog[i];
      final runs = double.tryParse(log['runs'].toString()) ?? 0.0;
      chartData.add(FlSpot(i.toDouble(), runs));
    }

    if (chartData.length < 2) {
      chartData.add(FlSpot(1, chartData[0].y));
    }

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: chartData.length.toDouble() - 1,
          minY: 0,
          maxY: chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 10,
          lineBarsData: [
            LineChartBarData(
              spots: chartData,
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.3),
              ),
              dotData: FlDotData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(value.toString());
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(value.toString());
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black12, width: 1),
          ),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    List<dynamic>? achievements = _userData?['achievements'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: achievements!.map((achievement) =>
              _buildAchievementCard(achievement)).toList(),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(String title) {
    return Card(
      elevation: 4,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.star, size: 30, color: Colors.amber),
            SizedBox(height: 8.0),
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchLog() {
    List<dynamic>? matchLog = _userData?['matchLog'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Match Log',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        DataTable(
          columns: [
            DataColumn(label: Text('Match')),
            DataColumn(label: Text('Runs')),
            DataColumn(label: Text('Wickets')),
            DataColumn(label: Text('Performance')),
          ],
          rows: matchLog!.map<DataRow>((log) {
            return DataRow(cells: [
              DataCell(Text(log['match'] ?? 'N/A')),
              DataCell(Text(log['runs'].toString())),
              DataCell(Text(log['wickets'].toString())),
              DataCell(Text(log['performance'] ?? 'N/A')),
            ]);
          }).toList(),
        ),
      ],
    );
  }
}
