const express = require("express");
const childProcess = require("child_process");
const process = require("node:process");

async function runScript() {
  return new Promise((resolve, reject) => {
    const script = childProcess.fork(
      `./repo/${process.env.SCRIPT_PATH}/dist/index.js`
    );

    // listen for errors as they may prevent the exit event from firing
    script.on("error", function (err) {
      reject(err);
    });

    // execute the callback once the process has finished running
    script.on("exit", function (code) {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error("exit code " + code));
      }
    });
  });
}

const app = express();

app.get("/", async (req, res) => {
  try {
    await runScript();
    res.status(200);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.listen(8080);
