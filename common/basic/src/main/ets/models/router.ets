import { ExceptionParamsType } from "."

export class CommonRouterParams{
  id?:string = ''
  oldTime?: string = ''
  location?: string = ''
  addExcept?: boolean = false
  formData?: ExceptionParamsType = {} as ExceptionParamsType
}