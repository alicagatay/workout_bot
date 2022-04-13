/// The implementation of the ChatMessage class.
///
/// A ChatMessage class represents a message sent by either the user or by the system.
class ChatMessage {
  String messageContent;
  String sentfromWho;

  /// Creates a new ChatMessage object.
  ///
  /// The constructor takes 2 parameters:
  /// - String [messageContent]: The content of the message.
  /// - String [sentfromWho]: The user(sender or receiver in this case) who sent the message.
  ChatMessage({required this.messageContent, required this.sentfromWho});
}
