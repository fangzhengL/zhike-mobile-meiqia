// @flow

import {
  NativeModules,
  Platform,
} from 'react-native';
import ZKCookieManager from 'zhike-cookie-manager';
const { ZKMeqiaBasicChatManager } = NativeModules;

type AnyFunc = (...args: Array<any>) => any;
const noop = () => {};

export function initMeqiaWithKey(key: string, callback?: AnyFunc = noop) {
  ZKMeqiaBasicChatManager.initMeqiaWithKey(key, callback);
}

export function showMeiqiaMessageView(groupId:number | string, ctx?: Object = {}, callback?: AnyFunc = noop) {
  ZKCookieManager.getCookieUUID((error, uuid) => {
    uuid = (typeof uuid === 'string' || error) ? uuid.replace(/-/g, '') : '';
    ZKMeqiaBasicChatManager.showChatView(uuid, groupId, ctx, callback);
  });
}
