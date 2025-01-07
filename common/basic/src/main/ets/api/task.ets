import { Request, TaskListDataModel, TaskListParams } from "../../../../Index"

export const getTaskList = (params:TaskListParams) => {
  return Request.get<TaskListDataModel>('/driver/tasks/list',params)
}