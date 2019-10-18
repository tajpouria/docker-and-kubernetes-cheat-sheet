import "dotenv/config";
import express from "express";

const app = express();

app.get("/", (_req, res) => {
    res.send("hello");
});

const port = process.env.PORT;

if (port) {
    app.listen(port, () => {
        console.info(`Server is running on port ${port} `);
    });
}
