export interface LoginForm{
  username:string,
  password:string
}
export class LoginFormModel implements LoginForm{
  username: string = '';
  password: string = '';

  constructor(model: LoginForm) {
  this.username = model.username;
  this.password = model.password;
  }
}