require('dotenv').config()

const express = require("express");
const app = express();

const bp = require("body-parser");

const amqp = require("amqplib");
const amqpServer = process.env.AMQP_URL;
var channel, connection;
const orders = [];

connectToQueue();

async function connectToQueue() {
    try {
        connection = await amqp.connect(amqpServer);
        channel = await connection.createChannel();
        await channel.assertQueue("order");
        channel.consume("order", data => {
            const orderData = JSON.parse(data.content.toString());
            console.log(`Order received: ${Buffer.from(data.content)}`);
            console.log("** Will be shipped soon! **\n")
            orders.push({
                ...orderData,
                receivedAt: new Date().toISOString()
            });
            channel.ack(data);
        });
    } catch (ex) {
        console.error(ex);
    }
}

app.get("/health", (req, res) => {
    res.json({
        status: "ok",
        service: "shipping-service"
    });
});

/**
 * GET all received orders
 */
app.get("/shipping", (req, res) => {
    res.json({
        total: orders.length,
        data: orders
    });
});

/**
 * GET last order
 */
app.get("/shipping/latest", (req, res) => {
    if (orders.length === 0) {
        return res.status(404).json({ message: "No shipping yet" });
    }

    res.json(orders[orders.length - 1]);
});

app.listen(process.env.PORT, () => {
    console.log(`Server running at ${process.env.PORT}`);
});
