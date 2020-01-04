### 高德地图定位Android,iOS采用gps定位(该定位为持续定位)
本插件利用高德地图提供的定位功能。
cordova-android >= 7.0.0
#### 申请密钥
请参照：
<br>
[申请android密钥定位SDK](http://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key/)
<br>
[申请ios密钥定位SDK](https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key)

#### 安装插件
```
cordova plugin add cordova-gaode-plugin --variable  ANDROID_API_KEY=your android key --variable  IOS_API_KEY=your ios key
npm i cordova-gaode-plugin --save
```
#### js/ionic2、3、4使用方法

```
// js项目调用
window.GaoDe.getCurrentPosition(successCallback, failedCallback,['start'/'stop']);
// ts项目调用。
(<any>window).GaoDe.getCurrentPosition(successCallback, failedCallback,['start'/'stop']);

(<any>window).GaoDe.getCurrentPosition(data => console.warn(data), msg => console.warn(msg), ["start"]);
```

#### 获得定位信息，返回JSON格式数据:

```
{
  accuracy: 水平精度

  adcode: 邮编

  address: 具体地址

  city: 城市

  citycode: 国家编码

  country: 国家

  district: 区域

  latitude: 经度

  longitude: 纬度

  poi: 地址名称

  province: 省

  status: 是否成功

  type: ""
}
```

