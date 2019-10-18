import "dotenv/config";
import express from "express";
import redis from "redis";

const client = redis.createClient({ host: "redis-server", port: 6379 });

const app = express();

client.set("visits", "0");

app.get("/", (_req, res) => {
    client.get("visits", (err, visits) => {
        if (err) {
            process.exit(1);
        }

        res.send(`you visit this url ${visits} times.`);
        client.set("visits", (parseInt(visits, 10) + 1).toString());
    });
});

const port = process.env.PORT;

if (port) {
    app.listen(port, () => {
        console.info(`Server is listening on port ${port}`);
    });
}
