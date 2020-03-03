require('dotenv').config()
const TeleBot = require('telebot');

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
  msg.reply.text('DRAW!');
});

bot.start();
