import { LoginFormModel, login, UserSettingClass, TOKEN_KEY} from 'basic'
import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
struct Login {

  @State UserFrom:LoginFormModel =new LoginFormModel({
    account: 'username',//'hashtenki',
    password: 'password'//'tenki4687'
  })
  @State showLoading:boolean = false
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


        TextInput({placeholder:'请输入账号',text:this.UserFrom.account}).align(Alignment.Center)
          .fontSize('18')
          .loginStyle()
          .onChange((value:string)=>{
            this.UserFrom.account = value
          })
        TextInput({placeholder:'请输入密码',text:this.UserFrom.password}).align(Alignment.Center)
          .fontSize('18')
          .margin({top:'20'})
          .type(InputType.Password)
          .showPasswordIcon(true)
          .loginStyle()
          .onChange((value:string)=>{
            this.UserFrom.password = value
          })
          .onSubmit(()=>{
            if(this.isInput()){
              this.login()
            }
          })
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
        .backgroundColor(this.isInput()?$r('app.color.primary'):$r('app.color.primary_disabled'))
        .width('100%')
          .height(50)
          .margin({ top: 50 })
        .enabled(this.isInput())
        .onClick(()=>{
          this.login()
        })
      }
      .padding({ left: 32, right: 32 })
      .margin({ top: 40 })
    }
    .height('100%')
    .width('100%')
  }

  isInput(){
    if (this.UserFrom.account && this.UserFrom.password) {
      return true
    }
    return false
  }

  async login(){
    try {
      this.showLoading = true
      const token = await login(this.UserFrom)
      AppStorage.setOrCreate(TOKEN_KEY, token)
      new UserSettingClass(getContext(this)).setUserToken(token)
      router.replaceUrl({
        url: 'pages/Index/Index' // 跳转到登录页
      })
      promptAction.showToast({ message: '登录成功' })
      this.showLoading = false
    }catch (e){
      console.log(e)
    } finally {
      this.showLoading = false
    }
  }

}
