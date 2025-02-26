import {
  CommonRouterParams,
  ExceptionParamsType, ExceptionParamsTypeModel,
  exceptionReport,
  HmCard, HmCardItem, HmNavBar,
  HmSelectCard,
  HmUpload,
  ImageList} from 'basic'
import { promptAction, router } from '@kit.ArkUI'
import dayjs from '@hview/dayjs'

@Entry
@Component
struct ExceptionReport {
  maxNumber: number = 50
  @State selectedIndex: number = -1
  @State exceptErrorList: string[] = ["发动机启动困难", "不着车、漏油", "照明失灵", "有异常响动", "排烟异常、温度异常", "其他问题"]
  @State exceptionForm: ExceptionParamsTypeModel = new ExceptionParamsTypeModel({} as ExceptionParamsType)
  onPageShow():void {
    const params = router.getParams() as CommonRouterParams
    if (params &&  params.location) {
      this.exceptionForm.exceptionPlace = params.location
    }
    if (params && params.id) {
      this.exceptionForm.transportTaskId = params.id
    }
  }
  async btnReport() {
    await exceptionReport(this.exceptionForm)
    promptAction.showToast({
      message: '上报异常成功'
    })
    router.back({
      url: 'pages/TaskDetail/TaskDetail',
      params: {
        addExcept: true
      }
    })
  }
  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if(params && params.id) {
      this.exceptionForm.transportTaskId = params.id
    }
  }
  /** 单个的渲染选项 */
  @Builder getSingleItem(item: string, index: number, showBorder: boolean) {
    Row() {
      Text(item)
        .fontSize(14)
        .fontColor($r("app.color.text_primary"))
      Image(this.selectedIndex === index ? $r("app.media.ic_check_true") : $r("app.media.ic_check_false"))
        .width(32)
        .height(32)
    }
    .onClick(() => {
      this.selectedIndex = index // 赋值索引
    })
    .height(60)
    .width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    .border({
      color: $r("app.color.background_divider"),
      width: { bottom: showBorder ? 1 : 0 }
    })
  }

  /** 传入HmSelectCard组件 */
  @Builder getCardContent() {
    ForEach(this.exceptErrorList, (item: string, index: number) => {
      this.getSingleItem(item, index, index !== this.exceptErrorList.length - 1)
    })
  }

  /** 异常类型弹层 */
  selectTypeDialog: CustomDialogController = new CustomDialogController({
    builder: HmSelectCard({
      cardContent: () => {
        this.getCardContent() // 必须调用一个builder的函数
      },
      title: '请选择异常类型',
      confirm: () => {
        if (this.selectedIndex === -1) {
          promptAction.showToast({ message: '请选择' })
          return
        }
        this.exceptionForm.exceptionType = this.exceptErrorList[this.selectedIndex]
        this.selectTypeDialog.close()
      }
    }),
    customStyle: true,
    alignment: DialogAlignment.Bottom
  })
  build() {
    Column() {
      HmNavBar({ title: '上报异常' })
      Scroll() {
        Column() {
          HmCard() {
            HmCardItem({leftTitle: '异常时间', rightText: this.exceptionForm.exceptionTime || '请选择',
              onRightClick: () => {
                DatePickerDialog.show({
                  showTime: true,
                  useMilitaryTime: true,
                  onDateAccept: (value) => {
                    this.exceptionForm.exceptionTime = dayjs(value).format('YYYY-MM-DD HH:mm')
                  }
                })
              }
            })
            HmCardItem({ leftTitle: '上报位置', rightText:  this.exceptionForm.exceptionPlace || '请选择', onRightClick: () => {
              router.pushUrl({
                url: 'pages/SelectLocation/SelectLocation'
              })
            }})
            HmCardItem({ leftTitle: '异常类型', rightText: this.exceptionForm.exceptionType || '请选择', showBottomBorder: false,
              onRightClick: () => {
                this.selectTypeDialog.open()
              }
            })
            HmCardItem({
              leftTitle: '异常描述',
              rightText: '',
              showRightIcon: false,
              showBottomBorder: false
            })
            TextArea({placeholder: '请输入异常描述',text: this.exceptionForm.exceptionDescribe! })
              .height(130).borderRadius(8).placeholderColor($r('app.color.text_secondary'))
              .fontSize(14).maxLength(this.maxNumber)
              .onChange((value) => {
                this.exceptionForm.exceptionDescribe = value
              })
            Text(`${this.exceptionForm.exceptionDescribe?.length || 0}/${this.maxNumber}`)
              .margin({top: -30 })
              .textAlign(TextAlign.End)
              .width('100%')
              .padding({ right: 15 })
              .fontColor($r('app.color.text_secondary'))


          }

          HmCard() {
            HmUpload({
              title: '上传图片(最多6张)',
              maxSelectNumber: 6,
              canUpload: true,
              imgList: this.exceptionForm.exceptionImagesList || [],
              onListChange: (list: ImageList[]) => {
                this.exceptionForm.exceptionImagesList = list
              }
            })
            Row().height(20)
          }
        }
      }.padding({ bottom: 80 })
      .layoutWeight(1)


      Row() {
        Button("提交").height(50).width(207).backgroundColor($r('app.color.primary_disabled'))
          .enabled(this.getBtnEnable())
          .onClick(()=>{this.btnReport()})
      }
      .position({ y: '100%' })
      .height(70)
      .translate({ y: -70 })
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.white'))
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
  getBtnEnable () {
    return !!(this.exceptionForm.exceptionDescribe &&
    this.exceptionForm.exceptionPlace &&
    this.exceptionForm.exceptionTime &&
    this.exceptionForm.exceptionType &&
    this.exceptionForm.exceptionDescribe)
  }
}