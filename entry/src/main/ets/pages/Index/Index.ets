import { TabClass } from 'basic';
import Mine from '../tabs/Mine/Mine';
import TaskTabs from '../tabs/Task/TaskTabs';

@Entry
@Component
struct Index {

  @State @Watch("updateName") currentIndex: number = 0 // 当前激活项
  @Provide currentName: string = ""
  updateName () {
    this.currentName =
      this.tabsData[this.currentIndex].name
  }
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
            TaskTabs()
          }
          else if(item.name === 'message')
          {
            Text("消息组件")
          }
          else {
            Mine()
          }
        }.tabBar(this.getTabBar(item))
      })
    }
  }
}