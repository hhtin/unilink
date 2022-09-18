import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/models/message.dart';
import 'package:unilink_flutter_app/view_model/message_view_model.dart';

class SocketService {
  IO.Socket socket;
  IO.Socket connectGroup(String group, var context) {
    socket = IO.io("https://${HOST_MESSAGE}", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'query': {"chatID": group}
    });
    socket.connect();
    socket.clearListeners();
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.on(
        'GROUP_MESSAGE',
        (data) => Provider.of<MessageViewModel>(context, listen: false)
            .addMessageToMessageOfGroup(Message.jsonFrom(data)));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
    return socket;
  }

  void disconnect() {
    if (socket != null) {
      socket.disconnect();
    }
    IO.cache.clear();
  }
}
