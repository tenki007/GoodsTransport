@Entry
@Component
struct Login {

  @Styles
  loginStyle() {
    .backgroundColor('#fff')
    .border({ color:
    $r('app.color.background_divider'), width:
    { bottom: 1 } })
    .width('100%')
    .height(58)
    .borderRadius(0)
  }
  @State showLoading:boolean = false
  build() {
    Column() {
      Column(){
        Text('货的帮').align(Alignment.Center)
          .fontSize('18')
          .fontColor($r('app.color.text_primary')).height('25')
        Row() {
          Text('账号登录').align(Alignment.Start)
            .fontSize('24')
            .fontColor($r('app.color.text_primary')).height('25')
          Row(){
            Text('密码登录').align(Alignment.End)
              .fontSize('18')
              .fontColor($r('app.color.primary')).height('25')
            Image($r('app.media.ic_angle')).width('10').height('10').margin({left:'10'})
          }
        }.justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .margin({top:'50',bottom:'50'})


        TextInput({placeholder:'请输入账号'}).align(Alignment.Center)
          .fontSize('18')
          .loginStyle()
        TextInput({placeholder:'请输入密码'}).align(Alignment.Center)
          .fontSize('18')
          .margin({top:'20'})
          .type(InputType.Password)
          .showPasswordIcon(true)
          .loginStyle()
          Button({ type: ButtonType.Capsule })
        {
          Row() {
            if(this.showLoading){
              LoadingProgress().width(20).height(20).margin({ right: 12 })
                .color($r('app.color.white'))
            }
            Text('登录').fontColor($r('app.color.white'))
          }
        }
        .backgroundColor($r('app.color.primary_disabled'))
        .width('100%')
          .height(50)
          .margin({ top: 50 })
      }
      .padding({ left: 32, right: 32 })
      .margin({ top: 40 })
    }
    .height('100%')
    .width('100%')
  }
}