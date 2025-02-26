import { HmNavBar, HmCard, HmCardItem, TaskDetailInfo, TaskDetailInfoModel, CommonRouterParams,
  getTaskDetail,
  HmCheckBox,
  CarRecordType,
  carRecord} from 'basic'
import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
struct CarRecord {
  @State carRecord: CarRecordType = {} as CarRecordType
  @State taskDetailData: TaskDetailInfo = new TaskDetailInfoModel({} as TaskDetailInfo)
  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if(params && params.id) {
      this.getTaskDetail(params.id)
    }
  }
  async getTaskDetail (id: string) {
    this.taskDetailData = await getTaskDetail(id)
  }
  transTimeFormat(value: Date) {
    // 2023-12-23 05:12
    return value.getFullYear() + "-" + (value.getMonth() + 1).toString().padStart(2, "0") + '-'
      + value.getDate().toString().padStart(2, "0") + " " +
    value.getHours().toString().padStart(2, "0") + ":"
      + value.getMinutes().toString().padStart(2, "0")
  }
  build() {
    Column() {
      HmNavBar({ title: '回车登记' })
      Scroll() {
        Column() {
          HmCard(){
            HmCardItem({
              leftTitle: '出车时间',
              rightText: this.taskDetailData.actualArrivalTime
            })
            HmCheckBox({
              value: !!this.carRecord.isBreakRules, title: '车辆违章',
              checkChange: (value) => {
                this.carRecord.isBreakRules = value
              }
            })
            HmCheckBox({
              value: !!this.carRecord.isFault, title: '车辆故障',
              checkChange: (value) => {
                this.carRecord.isFault = value
              }
            })
            HmCheckBox({
              value: !!this.carRecord.isAccident, title: '车辆事故',
              checkChange: (value) => {
                this.carRecord.isAccident = value
              }
            })
            HmCardItem({
              leftTitle: '回车时间',
              rightText: this.carRecord.endTime || '请选择',
              showBottomBorder: false,
              onRightClick: () => {
                DatePickerDialog.show({
                  showTime: true,
                  useMilitaryTime: true,
                  onDateAccept: (value: Date) => {
                    // 结束时间
                    this.carRecord.endTime = this.transTimeFormat(value)
                    //this.carRecord.endTime = dayjs(value).format('YYYY-MM-DD HH:mm')
                  }
                })
              }
            })
          }
        }
        .height('100%')
      }
      .layoutWeight(1)
      // 底部内容
      Row() {
        Button("交车",{ type: ButtonType.Capsule })
          .backgroundColor($r('app.color.primary'))
          .width(207)
          .height(50)
          .onClick(()=>{
            this.btnCarRecord()
          })
      }
      .backgroundColor($r('app.color.white'))
      .height(70)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }
    .backgroundColor($r('app.color.background_page'))
    .height('100%')
  }
  async btnCarRecord() {
    if (!this.carRecord.endTime) {
      promptAction.showToast({ message: '请选择回车时间' })
      return
    }
    this.carRecord.startTime = this.taskDetailData.actualDepartureTime
    // 运输任务id
    this.carRecord.id = this.taskDetailData.transportTaskId // 注意注意再注意
    await carRecord(this.carRecord)
    promptAction.showToast({ message: '回车登记成功' })
    router.clear() // 清空页面栈
    router.replaceUrl({ url: 'pages/Index/Index' })
  }
}