import { getTaskList, TaskInfoItem, TaskListParams, TaskListParamsModel, TaskTypeEnum } from "basic"

@Preview
@Component
struct TaskList {
  @State queryParams: TaskListParams = new TaskListParamsModel({
    status: TaskTypeEnum.Waiting,
    page: 1,
    pageSize: 5,
  } as TaskListParams)
  @State taskListData: TaskInfoItem[] = []
  aboutToAppear() {
    // this.getTaskList()
  }
  async getTaskList() {
    const result = await getTaskList(this.queryParams)
    this.taskListData = result.items
  }
  build() {
    if (this.taskListData.length===0){
      Column(){
        Image($r('app.media.ic_not_found')).size({width:140,height:140})
        Text('无待提取货物').fontColor($r('app.color.text_secondary')).fontSize(16)
      }.justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.background_page'))
    }else {
      Column(){

      }
    }
    // Text(JSON.stringify(this.taskListData))


  }

}
export default  TaskList