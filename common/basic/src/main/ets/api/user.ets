import { Request }from '../utils'
import { LoginFormModel} from '../models'

export const login = (data: LoginFormModel) => {
  return Request.post<string>
  ("/driver/login/account", data)
}