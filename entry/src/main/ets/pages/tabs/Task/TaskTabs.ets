import { TabClass, TaskListParams, TaskListParamsModel, TaskTypeEnum } from "basic"
import TaskList from "./TaskList"


@Component
struct TaskTabs{
  tabController: TabsController | undefined
  @State tabsdata:TabClass[]=[{title:'待提货',name:'waiting'},
    {title:'在途',name:'line'},
    {title:'已完成',name:'finish'}]
  @State currentIndex: number  = 0
  build() {
    Stack({ alignContent: Alignment.Top }) {
      Tabs({ barPosition: BarPosition.Start, index: $$this.currentIndex, controller: this.tabController }) {
        ForEach(this.tabsdata, (item: TabClass) => {
          TabContent(){
            if(item.name === "waiting") {
              TaskList()
            } else if(item.name === 'line') {
              TaskList({ queryParams: new TaskListParamsModel({
                page: 1,
                pageSize: 5,
                status: TaskTypeEnum.Line
              } as TaskListParams) })
            } else {
              TaskList({ queryParams: new TaskListParamsModel({
                page: 1,
                pageSize: 5,
                status: TaskTypeEnum.Finish
              } as TaskListParams) })
            }
          }.tabBar(item.title)
        })
      }.backgroundColor($r('app.color.background_page')).animationDuration(300)
      //   Row 占满一行, 高度跟Tabs的标题栏高度一致
      Row ({ space: 30 }) {
        ForEach(this.tabsdata, (item: TabClass) => {
          this.getTabBar(item)
        })
      }
      .padding({
        left: 40,
        right: 40
      })
      .width('100%')
      .height(50)
      .backgroundColor($r("app.color.white"))

    }
  }

  @Builder
  getTabBar(item:TabClass){
      Column(){
        Text(item.title)
          .fontSize(16)
          .fontColor(this.tabsdata[this.currentIndex]
            .name === item.name ?
          $r('app.color.text_primary') :
          $r('app.color.text_secondary'))
          .fontWeight(600)
          .animation({ duration: 300 })
          .margin({ bottom: 10 })
          .onClick(() => {
            this.currentIndex=this.tabsdata.findIndex(i => i.name === item.name)
          })
        Divider()
          .strokeWidth(4)
          .color($r('app.color.primary'))
          .lineCap(LineCapStyle.Round)
          .width(this.tabsdata[this.currentIndex].name === item.name ? 23 : 0)
        .animation({ duration: 300 })
      }
  }



}
export default TaskTabs