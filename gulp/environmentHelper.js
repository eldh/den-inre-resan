var util = require('gulp-util');

var environmentHelper = function (util) {

    var logInfo = function (key, value, valueType) {
        util.log('Variable', valueType, util.colors.blue(key), util.colors.magenta(value));
        util.log('You may set the ' + key + ' with --' + key);
    };

    return function get(key, fallbackValue) {
        var value = util.env[key];
        var valueType = 'value';

        if (typeof value === 'undefined') {
            value = fallbackValue;
            valueType = 'fallbackValue';
        }

        // logInfo(key, value, valueType);

        return value;
    };
}(util);

exports.get = environmentHelper;
