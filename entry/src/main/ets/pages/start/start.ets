import { AdvertClass, UserSettingClass } from 'basic';
import { window } from '@kit.ArkUI';

@Entry
@Component
struct Start {
  @State message: string = 'Hello World';
  // 首选项的工具类
  userSetting: UserSettingClass = new UserSettingClass(getContext(this))
  // 广告配置类
  @State adObj: AdvertClass  = {
    showAd: false,
    adTime: 0
  }
  timer: number = -1//定时器的id,方便我们清空定时器
  isclose: boolean = false
  async aboutToAppear(): Promise<void> {
    this.adObj = await this.userSetting.getUserAd()

    this.timer = setInterval(() => {
      if(this.adObj.adTime === 0) {
        clearInterval(this.timer)
        //关闭窗口
        if (!this.isclose) {
          this.closeWin()
        }
        return
      }
      this.adObj.adTime--
    }, 1000)
  }

  closeWin () {
    this.isclose = true
    window.findWindow("ad_window").destroyWindow()
  }

  build() {

    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.adObj.adImg).objectFit(ImageFit.Cover)
      Text(`${this.adObj.adTime}秒后跳过`)
        .padding({ left: 10, right: 10 })
        .margin({ right: 20, top: 40 })
        .height(30)
        .fontSize(14)
        .borderRadius(15)
        .backgroundColor($r("app.color.background_page"))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          if (!this.isclose) {
            this.closeWin()
          }

        })

    }.height('100%').width('100%')

  }
}