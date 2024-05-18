const pollForm = document.getElementById("radioForm");
const resultsDiv = document.getElementById('results');
const resetButton = document.getElementById('reset');

import { poll_backend } from "../../declarations/poll_backend";

const pollResults = {
  "Golang": 0,
  "Motoko": 0,
  "Javascript": 0,
  "Php": 0
};

document.addEventListener("DOMContentLoaded", async (e) => {
  e.preventDefault();

  // get question for poll backend
  const question = await poll_backend.getQuestion();
  document.getElementById("question").innerText = question;

  // get votes from poll backend 
  const votes = await poll_backend.getVotes();
  updateVotes(votes);
  displayResult();

  return false
},false);

pollForm.addEventListener('submit', async (e) => {
  e.preventDefault();

  const formData = new FormData(pollForm);
  const checkedValue = formData.get("option");

  console.log("options", checkedValue);

  const updatedVoteCounts = await poll_backend.vote(checkedValue);

  console.log(updatedVoteCounts);

  updateVotes(updatedVoteCounts);
  displayResult();
  return false;
}, false);

resetButton.addEventListener("click", async (e) => {
  e.preventDefault();

  // reset votes in poll backend
  await poll_backend.resetVotes();
  let votes = await poll_backend.getVotes();
  updateVotes(votes);
  displayResult();

}, false);

function updateVotes(votesArray) {
  for (let voteArray of votesArray) {
    // ["Motoko","0"]
    let voteOption = voteArray[0];
    let voteCount = voteArray[1];
    pollResults[voteOption] = voteCount;
  }
};

function displayResult() {
  let votesHtml = '<ul>';
  for (const key in pollResults) {
    votesHtml += '<li><strong>' + key + '</strong>:' + pollResults[key] +'</li>';
  }
  votesHtml += '</ul>'
  resultsDiv.innerHTML = votesHtml
};