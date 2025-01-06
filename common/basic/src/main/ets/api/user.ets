import { Request }from '../utils'
import { LoginFormModel} from '../models'
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