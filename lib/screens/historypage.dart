import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '_homepageClone.dart';

class Historypage extends StatefulWidget {
  const Historypage({super.key});

  @override
  State<Historypage> createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  final List<Map<String, dynamic>> chats = [
  {
  'name': 'Charlie',
  'message': 'Let’s grab coffee!',
  'time': 'Yesterday',
  'online': true,
  'pinned': true,
},
{
'name': 'Diana',
'message': 'Project files sent.',
'time': '2:00 PM',
'online': false,
'pinned': false,
},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[300],
                  child: Text(chat['name'][0]),
                ),
                if (chat['online'])
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Row(
              children: [
                Text(chat['name']),
                if (chat['pinned']) ...[
                  SizedBox(width: 8),
                  Icon(Icons.push_pin, size: 16, color: Colors.grey),
                ],
              ],
            ),
            subtitle: Text(chat['message'], maxLines: 1),
            trailing: Text(chat['time']),
            onLongPress: () {
              // Show context menu
            },
          );
        },
      ),
    );
  }
}
