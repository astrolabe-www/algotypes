require('dotenv').config()
const TeleBot = require('telebot');
const { cards } = require('./cards.js');


function dayOfYear() {
  const now = new Date();
  const start = new Date(now.getFullYear(), 0, 0);
  const diff = now - start;
  const oneDay = 1000 * 60 * 60 * 24;
  const day = Math.floor(diff / oneDay);
  return day;
}

function dailyRandom(mSeed) {
  const x = Math.sin(mSeed) * 1e4;
  return x - Math.floor(x);
}

function getCard(msg) {
  const mIndex = Math.floor(cards.length * dailyRandom(msg.from.id + dayOfYear()));
  return cards[mIndex];
}

const bot = new TeleBot({
  token: process.env.API_TOKEN,
  polling: {
    interval: 1000,
    timeout: 0,
    limit: 100,
    retryTimeout: 5000
  },
  allowedUpdates: ['text'],
  usePlugins: []
});

bot.on('sticker', (msg) => {
  console.log(msg.sticker);
  return msg.reply.text(msg.sticker.file_id);
});

bot.on(['/draw'], (msg) => {
  const mCard = getCard(msg);
  msg.reply.text(`Your algorithm is:\n${mCard.name}`).then(() => {
    bot.sendSticker(msg.chat.id, mCard.sticker_id).then(() => {
      msg.reply.text(`${mCard.message}`).then(() => {
        msg.reply.text('🔮 Come back tomorrow for a new algorithm 🔮');
      });
    });
  });
});

bot.on(['/carta'], (msg) => {
  const mCard = getCard(msg);
  msg.reply.text(`O seu algoritmo de hoje é:\n${mCard.name.pt}`).then(() => {
    bot.sendSticker(msg.chat.id, mCard.sticker_id).then(() => {
      msg.reply.text(`${mCard.message.pt}`).then(() => {
        msg.reply.text('🔮 Volte amanhã para uma nova mensagem 🔮');
      });
    });
  });
});

bot.start();
