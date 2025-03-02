import { HmNavBar, HmCard, HmCardItem, DelayParamsTypeModel, DelayParamsType, CommonRouterParams, delay } from 'basic'
import { promptAction, router } from '@kit.ArkUI'
import dayjs from '@hview/dayjs'

@Entry
@Component
struct Delay {
  @State maxSizeNumber:number = 50
  @State delayForm: DelayParamsTypeModel = new DelayParamsTypeModel({} as DelayParamsType)
  @State oldTime: string = ""
  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if(params && params.id && params.oldTime) {
      this.delayForm.id = params.id
      this.oldTime = params.oldTime
    }
  }
  build() {
    Column() {

      HmCard() {
        HmNavBar({ title: '延迟提货' })
        HmCardItem({ leftTitle: '原定时间', rightText: this.oldTime, showRightIcon: false })
        HmCardItem({
          leftTitle: '延迟时间', rightText: this.delayForm.delayTime || '',
          onRightClick: () => {
            DatePickerDialog.show({
              useMilitaryTime: true,
              showTime: true,
              onDateAccept: (value) => {
                // this.delayForm.delayTime = DateFormat(value)
                this.delayForm.delayTime = dayjs(value).format('YYYY-MM-DD HH:mm')
              }
            })
          }
        })
        TextArea({ placeholder: '请输入延迟提货原因', text: this.delayForm.delayReason  })
          .maxLength(this.maxSizeNumber)
          .backgroundColor($r('app.color.background_page'))
          .margin({ top: 20 })
          .borderRadius(8)
          .height(130)
          .placeholderColor($r('app.color.text_secondary'))
          .fontSize(14)
          .onChange((value) => {
            this.delayForm.delayReason = value
          })
        Text(`${this.delayForm.delayReason?.length || 0}/${this.maxSizeNumber}`)
          .margin({top: -30})
          .textAlign(TextAlign.End)
          .width('100%')
          .padding({ right: 15 })
          .fontColor($r('app.color.text_secondary'))
        Row() {
          Button("提交").height(50).width(207)
            .backgroundColor(this.getBtnEnable() ?  $r('app.color.primary') : $r('app.color.primary_disabled'))
            .enabled(this.getBtnEnable())
            .onClick(() => {
              this.onDelay()
            })
        }.justifyContent(FlexAlign.Center).padding({ top: 20, bottom: 20 })

      }
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
  getBtnEnable() {
    return !!(this.delayForm.id && this.delayForm.delayReason && this.delayForm.delayTime)
  }
  async onDelay() {
    await delay(this.delayForm)
    promptAction.showToast({
      message: '延迟收货成功'
    })
    router.back()
  }
}