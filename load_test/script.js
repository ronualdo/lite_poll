import http from 'k6/http';
import { check, group } from 'k6';

function selectOption(options) {
  if (options === undefined) {
    return {};
  }
  const optionIndex = Math.floor(Math.random() * 2);
  return options[optionIndex];
}

export const options = {
  scenarios: {
    getResults: {
      exec: 'getResults',
      executor: 'ramping-arrival-rate',
      startTime: '30s', // the ramping API test starts a little later
      startRate: 1,
      timeUnit: '1s', // we start at 2 iterations per second
      stages: [
        // { target: 20, duration: '15m' }, 
        // { target: 20, duration: '15m' }, 
        { target: 10, duration: '10m' }, 
        { target: 10, duration: '5m' }, 
        { target: 15, duration: '5m' }, 
        { target: 15, duration: '5m' }, 
        { target: 22, duration: '5m' }, 
        { target: 22, duration: '5m' }, 
        { target: 33, duration: '5m' }, 
        { target: 33, duration: '5m' }, 
      ],
      preAllocatedVUs: 2, // how large the initial pool of VUs would be
      maxVUs: 100
    },
    vote: {
      exec: 'vote',
      executor: 'ramping-arrival-rate',
      startTime: '30s', // the ramping API test starts a little later
      startRate: 1,
      timeUnit: '1s', // we start at 2 iterations per second
      stages: [
        // { target: 20, duration: '15m' }, 
        // { target: 20, duration: '15m' }, 
        { target: 10, duration: '10m' }, 
        { target: 10, duration: '5m' }, 
        { target: 15, duration: '5m' }, 
        { target: 15, duration: '5m' }, 
        { target: 22, duration: '5m' }, 
        { target: 22, duration: '5m' }, 
        { target: 33, duration: '5m' }, 
        { target: 33, duration: '5m' }, 
      ],
      preAllocatedVUs: 2, // how large the initial pool of VUs would be
      maxVUs: 100
    }
  },
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<200']
  },
}

export function setup() {
  const payload = JSON.stringify({
    poll: {
      question: "What is the best console?",
      options_attributes: [
        { label: "Playstation" },
        { label: "Xbox" }
      ]
    }
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  const pollResponse = http.post(`${__ENV.LITE_POLL_URL}/polls`, payload, params);
  const poll = JSON.parse(pollResponse.body);
  return { poll: poll };
}

export function getResults(poll) {
  const poll_results = http.get(`${__ENV.LITE_POLL_URL}/polls/${poll.id}/results`);
  check(poll_results, {
    'results response': (r) => r.status === 200
  });
}

export function vote(poll) {
  const res = http.get(`${__ENV.LITE_POLL_URL}/polls/${poll.id}`);
  check(res, {
    'poll retrieval successfull': (r) => r.status === 200
  });
  const retrievedPoll = res.status === 200 ? JSON.parse(res.body) : [];
  const selectedOption = selectOption(retrievedPoll.options);
  const payload = JSON.stringify({
    poll_id: '1',
    option_id: selectedOption.id,
    user: 'random user'
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  const votesResponse = http.post(`${__ENV.LITE_POLL_URL}/polls/1/votes`, payload, params);
  check(votesResponse, {
    'vote response': (r) => res.status === 200 && r.status === 200
  });
}
