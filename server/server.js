const express = require("express");
const cors = require("cors");
const { spawn } = require("child_process");
const path = require("path");

const app = express();
app.use(cors());
app.use(express.json());

// MIPS file in the same folder as server.js
const MIPS_FILE = "calculator.s";

app.post("/calc", (req, res) => {
  const { a, b, op } = req.body;

  if (a === undefined || b === undefined || !op) {
    return res.status(400).json({ error: "Missing a, b or op" });
  }

  const input = `${a}\n${b}\n${op}\n`;

  // Run MARS CLI (no GUI)
  const child = spawn("java", ["-jar", "Mars.jar", "nc", "100000", MIPS_FILE]);

  let output = "";
  let error = "";

  child.stdout.on("data", (data) => (output += data.toString()));
  child.stderr.on("data", (data) => (error += data.toString()));

  child.on("error", (err) => {
    res.status(500).json({
      error: "Failed to start MARS. Make sure Java is installed.",
      detail: err.message
    });
  });

  child.on("close", () => {
    res.json({
      stdout: output.trim(),
      stderr: error.trim()
    });
  });

  // send input to MARS
  child.stdin.write(input);
  child.stdin.end();
});

app.listen(4000, () => console.log("Backend running on http://localhost:4000"));
