import {
  CarRecordType,
  DelayParamsTypeModel,
  DeliverParamsTypeModel,
  ExceptionParamsTypeModel,
  PickUpParamsModel, Request, TaskListDataModel, TaskListParams } from "../../../../Index"
import { TaskDetailInfoModel } from "../models/task_detail"

export const getTaskList = (params:TaskListParams) => {
  return Request.get<TaskListDataModel>('/driver/tasks/list',params)
}
export const getTaskDetail = (id:string)=>{
  return Request.get<TaskDetailInfoModel>(`/driver/tasks/details/${id}`)
}
// 提货
export const pickUp = (data: PickUpParamsModel) => {
  return Request.post<null>("/driver/tasks/takeDelivery", data)
}
export const deliver = (data: DeliverParamsTypeModel) => {
  return Request.post<null>("/driver/tasks/deliver", data)
}
export const carRecord = (data: CarRecordType) => {
  return Request.post<null>("/driver/tasks/truckRegistration", data)
}
export const delay = (data: DelayParamsTypeModel) => {
  return Request.put<null>('/driver/tasks/delay', data)
}
// 上报异常
export const exceptionReport = (data: ExceptionParamsTypeModel) => {
  return Request.post<null>("/driver/tasks/reportException", data)
}