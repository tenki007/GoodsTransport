import { getUserInfo, UserInfoModel,HmCard,HmCardItem, UserTaskInfoModel, UserTaskInfo,
  UserTaskInfoParams,
  UserTaskInfoParamsModel,
  getUserTaskInfo,
  UserInfo} from "basic"
import { router } from "@kit.ArkUI"
import HmSkeleton from "basic/src/main/ets/components/HmSkeleton"

@Preview
@Component
struct Mine {

  @State userTaskInfo:UserTaskInfoModel = new UserTaskInfoModel({} as UserTaskInfo)
  queryTaskParams:UserTaskInfoParamsModel = new UserTaskInfoParamsModel({year:new Date().getFullYear().toString(),
    month: (new Date().getMonth()+1).toString()} as UserTaskInfoParams)
  @State loading: boolean = true
  @Consume @Watch("getUserInfo") currentName:string
  @State userInfo:UserInfoModel = new UserInfoModel({} as UserInfo)
  async getUserInfo() {
    if(this.currentName=="mine") {
      this.loading = true
      this.userInfo = await getUserInfo()
      this.userTaskInfo = await getUserTaskInfo(this.queryTaskParams)
      this.loading = false
    }
    // if (this.currentName === 'mine') {
    //
    //   setTimeout(()=>{},5000)//模拟网络延迟
    //   this.userInfo = await getUserInfo()
    //   this.userTaskInfo = await
    //   getUserTaskInfo(this.queryTaskParams)
    //   this.loading = false
    // }
  }
  // async getUserTaskInfo() {
  //   this.userTaskInfo = await getUserTaskInfo(this.queryTaskParams)
  // }


  build() {
    if(this.loading){
      HmSkeleton({count:4})
    }else {
      Column() {
        Column() {
          Image($r(this.userInfo.avatar)).width(67).height(67)
            .borderRadius(34.5)
            .backgroundColor($r('app.color.white'))
          Text(this.userInfo.name)
            .fontSize(18)
            .fontWeight(600)
            .lineHeight(22)
            .margin({ top: 9, bottom: 9 })
            .fontColor($r('app.color.white'))
          Text('司机编号：' + this.userInfo.number).fontSize(16)
            .margin({ top: 9, bottom: 9 })
            .fontColor($r('app.color.white'))
          Text('手机号：' + this.userInfo.phone).fontSize(16)
            .margin({ top: 9, bottom: 9 })
            .fontColor($r('app.color.white'))
        }
        .backgroundImage($r('app.media.bg_page_my'))
        .backgroundImageSize(ImageSize.Cover)
        .width('100%')
        .height(292)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .margin({ top: -2 })


        // 本月任务
        Column() {
          Text("- 本月任务").fontSize(14).fontColor($r('app.color.text_secondary')).lineHeight(20)
          Row() {
            Column() {
              Text(this.userTaskInfo.taskAmounts?.toString())
                .fontSize(18)
                .fontColor($r('app.color.text_primary'))
                .lineHeight(25)
                .margin({ bottom: 17 })
              Text("任务总量").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
            }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)

            Column() {
              Text(this.userTaskInfo.completedAmounts?.toString())
                .fontSize(18)

                .fontColor($r('app.color.text_primary'))
                .lineHeight(25)
                .margin({ bottom: 17 })
              Text("完成任务量").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)

            }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)

            Column() {
              Text(this.userTaskInfo.transportMileage?.toString())
                .fontSize(18)
                .fontColor($r('app.color.text_primary'))
                .lineHeight(25)
                .margin({ bottom: 17 })
              Text("运输里程(km)").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
            }
            .justifyContent(FlexAlign.SpaceAround).layoutWeight(1)
          }.justifyContent(FlexAlign.SpaceBetween).width('100%').layoutWeight(1)
        }
        .backgroundColor($r('app.color.white'))
        .borderRadius(8)
        .margin({
          left: 14.5,
          right: 14.5,
          top: -55,
          bottom: 15
        })
        .height(134)
        .padding({ top: 13.5, bottom: 13.5 })
        .justifyContent(FlexAlign.SpaceBetween)

        Column() {

          HmCard() {
            HmCardItem({
              leftTitle: '车辆信息',
              rightText: ''
            })
            HmCardItem({
              leftTitle: '任务设置',
              rightText: ''
            })
            HmCardItem({
              leftTitle: '系统设置',
              rightText: '',
              showBottomBorder: false,
              onRightClick: () => {
                router.pushUrl({
                  url:
                  'pages/Setting/Setting'
                })
              }
            })
          }
        }
      }
      .height('100%')
      .width('100%')
      .backgroundColor($r('app.color.background_page'))

    }
  }
}

export default Mine