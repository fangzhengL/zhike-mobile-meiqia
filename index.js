// @flow

import {
  NativeModules,
  Platform,
} from 'react-native';
import ZKCookieManager from 'zhike-cookie-manager';
const { ZKMeqiaBasicChatManager } = NativeModules;

export function initMeqiaWithKey(key, callback) {
  ZKMeqiaBasicChatManager.initMeqiaWithKey(key, callback);
}

export function showMeiqiaMessageView(ctx) {
  ZKCookieManager.getCookieUUID((error, uuid) => {
    uuid = (typeof uuid === 'string' || error) ? uuid.replace(/-/g, '') : '';
    ZKMeqiaBasicChatManager.showChatView(uuid, ctx || {}, () => null);
  })
}
