import { TabClass } from 'basic';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  @State tabsData: TabClass[] = [{
    title: '任务',
    name: 'task',
    icon: $r("app.media.ic_tab_btn_task")
  },{
    title: '消息',
    name: 'message',
    icon:
    $r("app.media.ic_tab_btn_mess_nor")
  },{
    title: '我的',
    name: 'mine',
    icon:
    $r("app.media.ic_tab_btn_mine_nor")
  }]

  @Builder
  getTabBar(item: TabClass) {
    Column() {
      Image(item.icon).width(22).height(22)
        .fillColor(item.name ===
        this.tabsData[this.currentIndex].name ?
        $r('app.color.primary') :
        $r('app.color.text_secondary'))
      Text(item.title)
        .fontSize(12)
        .fontWeight(400)
        .margin({ top: 5 })
        .fontColor(item.name ===
        this.tabsData[this.currentIndex].name ?
        $r('app.color.primary') :
        $r('app.color.text_secondary'))
    }.alignItems(HorizontalAlign.Center)
  }
  build() {
    Tabs({ barPosition: BarPosition.End,
      index: $$this.currentIndex }){
      ForEach(this.tabsData, (item:
        TabClass) => {
        TabContent(){
          if(item.name === 'task') {
            Text("任务组件")
          }
          else if(item.name === 'message')
          {
            Text("消息组件")
          }
          else {
            Text("我的组件")
          }
        }.tabBar(this.getTabBar(item))
      })
    }
  }
}