// module.exports.handler = (event, context, callback) => {
//   console.log('-----lambda is triggered-----');
//   console.log('Event received', JSON.stringify(event));
//   console.log(Date.now());
// }

'use strict';

const apiHandler = (payload, context, callback) => {
    console.log(`Function apiHandler called with payload ${JSON.stringify(payload)}`);
    callback(null, {
        statusCode: 201,
        body: JSON.stringify({
            message: 'Hello World',
            input: 'This is the rest of the message.'
        }),
        headers: {
            'X-Custom-Header': 'ASDF'
        }
    });
}

module.exports = {
    apiHandler,
}
