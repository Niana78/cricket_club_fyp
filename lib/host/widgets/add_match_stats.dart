import 'package:flutter/material.dart';
import '../../constants/color_theme.dart';

class AddMatchStats extends StatefulWidget {
  const AddMatchStats({super.key});

  @override
  State<AddMatchStats> createState() => _AddMatchStatsState();
}

class _AddMatchStatsState extends State<AddMatchStats> {
  final CricketClubTheme theme = CricketClubTheme();

  final List<PlayerStats> teamAStats = List.generate(
    11,
        (index) => PlayerStats(playerName: 'Team A - Player ${index + 1}'),
  );

  final List<PlayerStats> teamBStats = List.generate(
    11,
        (index) => PlayerStats(playerName: 'Team B - Player ${index + 1}'),
  );

  // Match summary variables
  int totalRunsTeamA = 0;
  int totalWicketsTeamA = 0;
  int totalOversTeamA = 0;

  int totalRunsTeamB = 0;
  int totalWicketsTeamB = 0;
  int totalOversTeamB = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Match Stats',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.maincolor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white,),
            onPressed: () {
              // Logic to save the stats
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTeamSection(teamName: "Team A", playerStats: teamAStats),
              const SizedBox(height: 20),
              _buildTeamSection(teamName: "Team B", playerStats: teamBStats),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.maincolor, // Button color
                  foregroundColor: Colors.white, // Text color
                ),
                onPressed: () {
                  // Logic to submit the stats
                },
                child: const Text('Submit Stats'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSection({required String teamName, required List<PlayerStats> playerStats}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          teamName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildPlayerStatsList(playerStats),
        _buildMatchSummary(teamName),
      ],
    );
  }

  Widget _buildPlayerStatsList(List<PlayerStats> playerStats) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: playerStats.length,
      itemBuilder: (context, index) {
        return _buildPlayerCard(playerStats[index]);
      },
    );
  }

  Widget _buildPlayerCard(PlayerStats player) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Row(
          children: [
            Checkbox(
              value: player.didPlay,
              onChanged: (value) {
                setState(() {
                  player.didPlay = value ?? false;
                });
              },
            ),
            Text(player.playerName, style: TextStyle(color: theme.maincolor)),
          ],
        ),
        children: player.didPlay
            ? [
          _buildStatField(
            label: "Runs",
            value: player.runs.toString(),
            onChanged: (val) => setState(() => player.runs = int.tryParse(val) ?? 0),
          ),
          _buildStatField(
            label: "Balls Faced",
            value: player.ballsFaced.toString(),
            onChanged: (val) => setState(() => player.ballsFaced = int.tryParse(val) ?? 0),
          ),
          _buildStatField(
            label: "Wickets",
            value: player.wickets.toString(),
            onChanged: (val) => setState(() => player.wickets = int.tryParse(val) ?? 0),
          ),
          _buildStatField(
            label: "Overs Bowled",
            value: player.oversBowled.toString(),
            onChanged: (val) => setState(() => player.oversBowled = int.tryParse(val) ?? 0),
          ),
        ]
            : [],
      ),
    );
  }

  Widget _buildStatField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              onChanged: onChanged,
              controller: TextEditingController(text: value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchSummary(String teamName) {
    int totalRuns, totalWickets, totalOvers;
    if (teamName == "Team A") {
      totalRuns = totalRunsTeamA;
      totalWickets = totalWicketsTeamA;
      totalOvers = totalOversTeamA;
    } else {
      totalRuns = totalRunsTeamB;
      totalWickets = totalWicketsTeamB;
      totalOvers = totalOversTeamB;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$teamName Summary', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        _buildStatField(
          label: "Total Runs",
          value: totalRuns.toString(),
          onChanged: (val) {
            setState(() {
              if (teamName == "Team A") {
                totalRunsTeamA = int.tryParse(val) ?? 0;
              } else {
                totalRunsTeamB = int.tryParse(val) ?? 0;
              }
            });
          },
        ),
        _buildStatField(
          label: "Total Wickets",
          value: totalWickets.toString(),
          onChanged: (val) {
            setState(() {
              if (teamName == "Team A") {
                totalWicketsTeamA = int.tryParse(val) ?? 0;
              } else {
                totalWicketsTeamB = int.tryParse(val) ?? 0;
              }
            });
          },
        ),
        _buildStatField(
          label: "Total Overs",
          value: totalOvers.toString(),
          onChanged: (val) {
            setState(() {
              if (teamName == "Team A") {
                totalOversTeamA = int.tryParse(val) ?? 0;
              } else {
                totalOversTeamB = int.tryParse(val) ?? 0;
              }
            });
          },
        ),
      ],
    );
  }
}

class PlayerStats {
  final String playerName;
  bool didPlay;
  int runs;
  int ballsFaced;
  int wickets;
  int oversBowled;

  PlayerStats({
    required this.playerName,
    this.didPlay = false,
    this.runs = 0,
    this.ballsFaced = 0,
    this.wickets = 0,
    this.oversBowled = 0,
  });
}
