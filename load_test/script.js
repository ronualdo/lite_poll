import http from 'k6/http';
import { check, group } from 'k6';

function selectOption(options) {
  const optionIndex = Math.floor(Math.random() * 2);
  return options[optionIndex];
}

export const options = {
  scenarios: {
    getResults: {
      exec: 'getResults',
      executor: 'ramping-arrival-rate',
      startTime: '30s', // the ramping API test starts a little later
      startRate: 50,
      timeUnit: '1s', // we start at 50 iterations per second
      stages: [
        { target: 200, duration: '30s' }, // go from 50 to 200 iters/s in the first 30 seconds
        { target: 200, duration: '3m30s' }, // hold at 200 iters/s for 3.5 minutes
        { target: 0, duration: '30s' }, // ramp down back to 0 iters/s over the last 30 second
      ],
      preAllocatedVUs: 50, // how large the initial pool of VUs would be
      maxVUs: 100
    },
    vote: {
      executor: 'ramping-vus',
      startTime: '5s',
      exec: 'vote',
      startVUs: 0,
      stages: [
        { target: 200, duration: '30s' }, // go from 50 to 200 iters/s in the first 30 seconds
        { target: 200, duration: '3m30s' }, // hold at 200 iters/s for 3.5 minutes
        { target: 0, duration: '30s' }, // ramp down back to 0 iters/s over the last 30 second
      ],
    }
  },
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<200']
  },
}

export function getResults() {
  const poll_results = http.get(`${__ENV.LITE_POLL_URL}/polls/1/results`);
  check(poll_results, {
    'results response': (r) => r.status === 200
  });
}

export function vote() {
  const res = http.get(`${__ENV.LITE_POLL_URL}/polls/1`);
  check(res, {
    'poll retrieval successfull': (r) => r.status === 200
  });
  const poll = JSON.parse(res.body);
  const selectedOption = selectOption(poll.options);
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
    'vote response': (r) => r.status === 200
  });
}
