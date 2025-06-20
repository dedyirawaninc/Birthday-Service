import express from 'express';
import bodyParser from 'body-parser';
import { PrismaClient, MessageLog } from '@prisma/client';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import timezone from 'dayjs/plugin/timezone';
import cron from 'node-cron';
import axios from 'axios';

dayjs.extend(utc);
dayjs.extend(timezone);

const prisma = new PrismaClient();
const app = express();
app.use(bodyParser.json());

const EMAIL_SERVICE_URL = 'https://email-service.digitalenvision.com.au/send-email';

type MessageType = 'BIRTHDAY';

const sendMessage = async (
  user: { firstName: string; lastName: string; id: number; timezone: string },
  type: MessageType,
  date: Date
) => {
  const fullName = `${user.firstName} ${user.lastName}`;

  try {
    await axios.post(EMAIL_SERVICE_URL, {
      to: `${user.firstName}.${user.lastName}@example.com`,
      subject: 'Happy Birthday!',
      message: `Hey, ${fullName} it’s your birthday`,
    });

    await prisma.messageLog.create({
      data: {
        userId: user.id,
        date: date,
        type,
      },
    });
  } catch (err) {
    console.error(`[SEND ERROR] ${fullName} on ${type} :: `, err.message);
  }
};

const checkBirthdays = async () => {
  const nowUtc = dayjs.utc();
  const users = await prisma.user.findMany();

  for (const user of users) {
    const localTime = nowUtc.tz(user.timezone);
    const birthdayToday =
      localTime.format('MM-DD') === dayjs(user.birthday).format('MM-DD');
    const isNineAM = localTime.format('HH:mm') === '09:00';

    if (birthdayToday && isNineAM) {
      const alreadySent = await prisma.messageLog.findFirst({
        where: {
          userId: user.id,
          date: localTime.startOf('day').toDate(),
          type: 'BIRTHDAY',
        },
      });

      if (!alreadySent) {
        await sendMessage(user, 'BIRTHDAY', localTime.startOf('day').toDate());
      }
    }
  }
};

const retryUnsentMessages = async () => {
  const yesterday = dayjs.utc().subtract(1, 'day');
  const users = await prisma.user.findMany();

  for (const user of users) {
    const localTime = yesterday.tz(user.timezone);
    const birthdayYesterday =
      localTime.format('MM-DD') === dayjs(user.birthday).format('MM-DD');

    if (birthdayYesterday) {
      const alreadySent = await prisma.messageLog.findFirst({
        where: {
          userId: user.id,
          date: localTime.startOf('day').toDate(),
          type: 'BIRTHDAY',
        },
      });

      if (!alreadySent) {
        await sendMessage(user, 'BIRTHDAY', localTime.startOf('day').toDate());
      }
    }
  }
};

app.post('/user', async (req, res) => {
  try {
    const { firstName, lastName, birthday, timezone } = req.body;
    const user = await prisma.user.create({
      data: {
        firstName,
        lastName,
        birthday: new Date(birthday),
        timezone,
      },
    });
    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.delete('/user/:id', async (req, res) => {
  try {
    const { id } = req.params;
    await prisma.user.delete({ where: { id: parseInt(id) } });
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

cron.schedule('* * * * *', checkBirthdays);
cron.schedule('0 0 * * *', retryUnsentMessages);

app.listen(3000, () => {
  console.log('Birthday message service running on port 3000');
});
