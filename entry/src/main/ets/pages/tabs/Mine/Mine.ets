import { getUserInfo, UserInfoModel } from "basic"

@Preview
@Component
struct Mine {

  @Consume @Watch("getUserInfo") currentName:string
  @State userInfo:UserInfoModel = new UserInfoModel()
  async getUserInfo() {
    if(this.currentName=="mine") {
      this.userInfo = await getUserInfo()
    }
  }




  build() {
    Column(){
      Column(){
        Image($r(this.userInfo.avatar)).width(67).height(67)
          .borderRadius(34.5)
          .backgroundColor($r('app.color.white'))
        Text(this.userInfo.name).fontSize(18)
          .fontWeight(600)
          .lineHeight(22)
          .margin({top:9,bottom:9})
          .fontColor($r('app.color.white'))
        Text('司机编号：'+this.userInfo.number).fontSize(16)
          .margin({top:9,bottom:9})
          .fontColor($r('app.color.white'))
        Text('手机号：'+ this.userInfo.phone).fontSize(16)
          .margin({top:9,bottom:9})
          .fontColor($r('app.color.white'))
      }.backgroundImage($r('app.media.bg_page_my'))
      .backgroundImageSize(ImageSize.Cover)
      .width('100%')
      .height(292)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .margin({top:-2})


      // 本月任务
      Column() {
        Text("- 本月任务").fontSize(14).fontColor($r('app.color.text_secondary')).lineHeight(20)
        Row() {
          Column() {
            Text("1000").fontSize(18).fontColor($r('app.color.text_primary')).lineHeight(25)
              .margin({ bottom: 17 })
            Text("任务总量").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)
          Column() {
            Text("1000")
              .fontSize(18)

              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({ bottom: 17 })
            Text("完成任务量").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)

          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)
          Column() {
            Text("1000")
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({ bottom: 17 })
            Text("运输里程(km)").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)}
          .justifyContent(FlexAlign.SpaceAround).layoutWeight(1)
        }.justifyContent(FlexAlign.SpaceBetween).width('100%').layoutWeight(1)
      }
      .backgroundColor($r('app.color.white'))
      .borderRadius(8)
      .margin({ left: 14.5, right: 14.5,
        top: -55, bottom: 15 })
      .height(134)
      .padding({ top: 13.5, bottom: 13.5 })
      .justifyContent(FlexAlign.SpaceBetween)

      Column(){
          Row(){
            Text('车辆信息').fontSize(16)
              .fontWeight(600)
            Image($r('app.media.ic_btn_more')).size({width:24,height:24})
          }.justifyContent(FlexAlign.SpaceBetween)
          .border({width:{bottom:1},color:$r('app.color.background_page')})
        .width('100%')
        .height(60)
        Row(){
          Text('任务数据').fontSize(16)
            .fontWeight(600)
          Image($r('app.media.ic_btn_more')).size({width:24,height:24})
        }.justifyContent(FlexAlign.SpaceBetween)
        .border({width:{bottom:1},color:$r('app.color.background_page')})
        .width('100%')
        .height(60)
        Row(){
          Text('系统设置').fontSize(16)
            .fontWeight(600)
          Image($r('app.media.ic_btn_more')).size({width:24,height:24})
        }.justifyContent(FlexAlign.SpaceBetween)
        .border({width:{bottom:1},color:$r('app.color.background_page')})
        .width('100%')
        .height(60)
      }.backgroundColor($r('app.color.white'))
      .borderRadius(8)
      .padding({
        left:15,
        right:15
      })
      .margin({
        left:14.5,right:14.5
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}

export default Mine