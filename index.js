// @flow

import {
  NativeModules,
  Platform,
} from 'react-native';
import { getCookie } from 'zhike-cookie-manager';
import { parseCpsInfoStr } from 'ss-cps-info';
const { ZKMeqiaBasicChatManager } = NativeModules;

type AnyFunc = (...args: Array<any>) => any;
const noop = () => {};

export function initMeqiaWithKey(key: string, callback?: AnyFunc = noop) {
  ZKMeqiaBasicChatManager.initMeqiaWithKey(key, callback);
}

export function showMeiqiaMessageView(groupId:number | string, ctx?: Object = {}, callback?: AnyFunc = noop) {
  getCookie('cpsInfo')
  .then((cpsInfoStr) => {
    return parseCpsInfoStr(cpsInfoStr).cookie_id;
  })
  .catch(() => '')
  .then((uuid) => {
    const fixedUUID = (typeof uuid === 'string') ? uuid.replace(/-/g, '') : '';
    ZKMeqiaBasicChatManager.showChatView(fixedUUID, groupId, ctx, callback);
  });
}
