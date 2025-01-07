import { Request }from '../utils'
import { LoginFormModel, UserTaskInfoModel, UserTaskInfoParamsModel} from '../models'
import {  UserInfoModel } from '../models'


/** 获取用户信息 */
export const getUserInfo = () => {
  return Request.get<UserInfoModel>
  ("/driver/users")
}

export const login = (data: LoginFormModel) => {
  return Request.post<string>
  ("/driver/login/account", data)
}

export const getUserTaskInfo= (data:UserTaskInfoParamsModel) =>{
  return Request.get<UserTaskInfoModel>('/driver/users/taskReport',data)
}