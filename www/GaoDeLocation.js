var exec = require('cordova/exec');

var GaoDe = {
    // 老接口（持续定位）
    getCurrentPosition:function (successFn,errorFn,parameter) {
        exec(successFn, errorFn, 'GaoDeLocation', 'getCurrentPosition', parameter);
    },
    // 先不要调用，未完成。
    // 单次定位
    singleLocation: function(successFn, errorFn) {
        exec(successFn, errorFn, 'GaoDelocation', 'singleLocation', []);
    },
    // 持续定位开始
    startUpdatePosition: function(successFn, errorFn) {
        exec(successFn, errorFn, 'GaoDelocation', 'startUpatePosition', []);
    },
    // 持续定位停止
    stopUpdatePosition: function(successFn, errorFn) {
        exec(successFn, errorFn, 'GaoDelocation', 'stopUpdatePosition', []);
    }
};

module.exports = GaoDe;
