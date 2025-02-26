import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { AdvertClass, defaultAd, TOKEN_KEY, UserSettingClass } from 'basic';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import { BusinessError } from '@kit.BasicServicesKit';
import { pushService } from '@kit.PushKit';
import { notificationManager } from '@kit.NotificationKit';
import { common } from '@kit.AbilityKit';

const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;


export default class EntryAbility extends UIAbility {
  // onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
  //   hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  // }
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    //获取pushtoken
    try {
      const pushToken: string = await pushService.getToken();
      console.log('pushToken: ' + pushToken)
      hilog.info(0x0000, 'testTag', 'Succeeded in getting push token');
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      hilog.error(0x0000, 'testTag', 'Failed to get push token: %{public}d %{public}s', e.code, e.message);
    }


    let context = getContext(this) as common.UIAbilityContext;
    notificationManager.isNotificationEnabled().then((data: boolean) => {
      hilog.info(DOMAIN_NUMBER, TAG, "isNotificationEnabled success, data: " + JSON.stringify(data));
      if(!data){
        notificationManager.requestEnableNotification(context).then(() => {
          hilog.info(DOMAIN_NUMBER, TAG, `[ANS] requestEnableNotification success`);
        }).catch((err : BusinessError) => {
          if(1600004 == err.code){
            hilog.error(DOMAIN_NUMBER, TAG, `[ANS] requestEnableNotification refused, code is ${err.code}, message is ${err.message}`);
          } else {
            hilog.error(DOMAIN_NUMBER, TAG, `[ANS] requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
          }
        });
      }
    }).catch((err : BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, `isNotificationEnabled fail, code is ${err.code}, message is ${err.message}`);
    });


    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    let manger = abilityAccessCtrl.createAtManager()
    await manger.requestPermissionsFromUser(this.context,
      [
        'ohos.permission.LOCATION',
        'ohos.permission.APPROXIMATELY_LOCATION',
      ])
  }
  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    const setting = new UserSettingClass(this.context) //getContext拿到的是undefined
    //
    const ad = await new Promise<AdvertClass>((resolve, reject) => {
      setTimeout(() => {
        resolve(defaultAd) // 广告信息
      }, 500)
      // resolve()
    })
    await setting.setUserAd(ad) // 写入首选项
    if(ad.showAd) {
      // 展示广告的情况 展示广告页 有时限
      // 创建一个子窗口 子窗口加载广告 广告播完 窗口销毁
      const win = await windowStage.createSubWindow("ad_window")
      await win.showWindow()
      win.setUIContent("pages/start/start")
    }
    const token = await setting.getUserToken()
    AppStorage.setOrCreate(TOKEN_KEY,token)
    console.log(token)
    if(token){
      windowStage.loadContent('pages/Index/Index', (err) => {
        if (err.code) {
          hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
          return;
        }
        hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      });
    }else {
      windowStage.loadContent('pages/Login/Login')
    }

  }


  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
