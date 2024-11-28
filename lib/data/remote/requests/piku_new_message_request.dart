

import 'package:image_picker/image_picker.dart';


class PikuNewMessageRequest {

  final String content;

  final List<XFile?>? attachments;

  final String echoId;

  const PikuNewMessageRequest({required this.content, required this.attachments, required this.echoId});



}
