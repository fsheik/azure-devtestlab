module.exports = {
    apps: [{
        name: "eth-netstats",
        script: "./app.js",
        env: {
            "NODE_ENV": "production1",
            "PORT": 3000,
            "WS_SECRET": "HI77W9KSWPT0NOB6BRBS1332"
        }
    }]
}