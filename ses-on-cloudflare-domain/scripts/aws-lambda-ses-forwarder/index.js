var LambdaForwarder = require("aws-lambda-ses-forwarder");

exports.handler = function (event, context, callback) {
  var overrides = {
    config: {
      allowPlusSign: process.env.EMAIL_ALLOW_PLUS_SIGN,
      emailBucket: process.env.EMAIL_BUCKET_NAME,
      emailKeyPrefix: process.env.EMAIL_BUCKET_PATH,
      forwardMapping: JSON.parse(process.env.EMAIL_MAPPING),
      fromEmail: process.env.EMAIL_FROM,
    },
  };
  LambdaForwarder.handler(event, context, callback, overrides);
};
