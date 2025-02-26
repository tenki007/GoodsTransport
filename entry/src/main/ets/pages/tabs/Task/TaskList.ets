import { getTaskList,
  HmList,
  TaskInfoItem, TaskInfoItemModel, TaskListParams, TaskListParamsModel, TaskTypeEnum } from "basic"
import TaskItemCard from "./components/TaskItemCard"

@Preview
@Component
struct TaskList {
  @State queryParams: TaskListParams = new TaskListParamsModel({
    status: TaskTypeEnum.Waiting,
    page: 1,
    pageSize: 5,
  } as TaskListParams)
  @State taskListData: TaskInfoItem[] = []
  @State allPage:number = 1
  aboutToAppear() {
    this.getTaskList(true)
  }
  async getTaskList(isRefresh:boolean) {
    const result = await getTaskList(this.queryParams)
    if (isRefresh) {
      console.log("init")
      this.taskListData=result.items
    } else {
      console.log("ref")
      this.taskListData.push(...result.items)
    }

    this.allPage=result.pages
    this.queryParams.page++
  }

  @Builder renderItem (item: object) {
    TaskItemCard({ TaskData: item as TaskInfoItemModel })
  }
  async onRefresh(){
    this.queryParams.page=1;
    await this.getTaskList(true)
  }

  build() {
    if (this.taskListData?.length===0){
      Column(){
        Image($r('app.media.ic_not_found')).size({width:140,height:140})
        Text('无待提取货物').fontColor($r('app.color.text_secondary')).fontSize(16)
      }.justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.background_page'))
    }else {
      // List () {
      //   ForEach(this.taskListData, (item: TaskInfoItemModel) => {
      //     ListItem(){
      //       TaskItemCard({ TaskData: item })
      //     }
      //   })
      // }
      HmList({
        onLoad: async () => {
          await this.getTaskList(false)
        },
        onRefresh: async () => {
          await this.onRefresh()
        },
        dataSource: this.taskListData,
        renderItem: this.renderItem,
        finished: this.allPage < this.queryParams.page,
        finishText: '没啦没啦',
        loadingText: '拼命加载中'
      }).height('100%')

      // HmList({
      //   dataSource: this.taskListData, // 数据源
      //   finished: this.allPage <
      //   this.queryParams.page  ,// 是否还有下一页
      //   // 上拉加载的函数
      //   onLoad: async () => {
      //     // 上拉加载
      //     await this.getTaskList(false)
      //   },
      //   renderItem: (item: object) => {
      //     // 如果需要的是builderParams的参数 可以用普通函数包裹一个Builder的函数
      //     this.renderItem(item)
      //   },
      //   loadingText: '拼命加载中',
      //   finishText: '已经到底啦',
      //   onRefresh:async ()=>{
      //     this.onRefresh()
      //   }
      // })
    }
    }

    // Text(JSON.stringify(this.taskListData))
  }
export default  TaskList