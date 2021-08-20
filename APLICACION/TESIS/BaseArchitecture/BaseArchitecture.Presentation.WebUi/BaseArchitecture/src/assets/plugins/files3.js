"use strict";
var fileS3 = {
    options: {
        bucket: ""
    },
    ParamS3: function (params) {
        this.options.bucket = new AWS.S3({
            accessKeyId:
                params.AwsAccessKey,
            secretAccessKey:
                params.AwsSecretKey,
            sessionToken: params.AwsSessionToken,
            region: 'us-east-1',
            endpoint: 'https://s3.amazonaws.com/'
        });
    },
    ParamsBucket: function (bucket, key, file) {
        return {
            Bucket: bucket,
            Key: key,
            Body: file,
            ACL: 'public-read',
            ContentType: file.type,
        };
    },
    UploadS3: function (params, callback) {
        return this.options.bucket
            .upload(params, callback);
    },
    DeleteS3: function (params, callback) {
        return this.options.bucket
            .deleteObject(params, callback);
    }
}