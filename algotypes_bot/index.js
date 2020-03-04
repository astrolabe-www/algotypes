require('dotenv').config()
const TeleBot = require('telebot');
const { cards } = require('./cards.js');

const bot = new TeleBot({
  token: process.env.API_TOKEN,
  polling: {
    interval: 1000,
    timeout: 0,
    limit: 100,
    retryTimeout: 5000
  },
  allowedUpdates: ["text"],
  usePlugins: []
});

bot.on(['/draw'], (msg) => {
  const mCard = cards[Math.floor(Math.random() * cards.length)];
  msg.reply.text(`Your cards is:\n${mCard.name}`).then(() => {
    bot.sendSticker(msg.chat.id, mCard.sticker_id).then(() => {
      msg.reply.text(`${mCard.message}`);
    });
  });
});

bot.start();
