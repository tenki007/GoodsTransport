export interface LoginForm{
  account:string,
  password:string
}
export class LoginFormModel implements LoginForm{
  account: string = '';
  password: string = '';

  constructor(model: LoginForm) {
  this.account = model.account;
  this.password = model.password;
  }
}

export interface UserInfo {
  //头像
  avatar: string;
  //姓名
  name: string;
  //司机编号
  number: string;
  //手机号
  phone: string;
}
  export class UserInfoModel implements UserInfo {
    avatar: string = ''
    name: string = ''
    number: string = ''
    phone: string = ''
  constructor(model?: UserInfo) {
    if (model) {
      this.avatar = model.avatar
      this.name = model.name
      this.number = model.number
      this.phone = model.phone
    }
  };
    // constructor(model: UserInfo) {
    //     this.avatar = model.avatar
    //     this.name = model.name
    //     this.number = model.number
    //     this.phone = model.phone
    // };
}