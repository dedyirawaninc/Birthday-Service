export enum MessageType {
  BIRTHDAY = 'BIRTHDAY',
  ANNIVERSARY = 'ANNIVERSARY',
}

export function getMessageContent(type: MessageType, user: { firstName: string; lastName: string }) {
  switch (type) {
    case MessageType.BIRTHDAY:
      return {
        subject: 'Happy Birthday!',
        message: `Hey, ${user.firstName} ${user.lastName} it’s your birthday`,
      };
    case MessageType.ANNIVERSARY:
      return {
        subject: 'Happy Anniversary!',
        message: `Hey, ${user.firstName} ${user.lastName} it’s your anniversary`,
      };
    default:
      throw new Error('Unknown message type');
  }
}