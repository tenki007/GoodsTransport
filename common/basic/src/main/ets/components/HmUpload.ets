import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { fileIo as fs } from '@kit.CoreFileKit';
import { HmPreview } from ".";
import { ImageList } from "../models/common";
import { request } from "@kit.BasicServicesKit";
import { util } from "@kit.ArkTS";
import { uploadImage } from "../api";

export async function UploadFile(imageList:
  ImageList[])/*: Promise<ImageList[]>*/ {
  // 因为上传文件只能从沙箱文件中拷贝所以 我们需要把传过来的所有的图片拷贝到沙箱
  const saveDir = getContext().cacheDir //缓存目录
  // 调用上传API的参数
  const fileList: request.File[] = []
  imageList.forEach(item => {
  // 将文件拷贝到沙箱目录
  const fileName = util.generateRandomUUID()//随机文件名 32位的数字/时间戳
  const targetPath = saveDir + '/' +
    fileName + '.jpg'//文件路径全称
  const file = fs.openSync(item.url) //读取相册的文件
  // const file =fileIo.openSync(item.url,fileIo.OpenMode.READ_ONLY) // 读取相册的文件
  // 2. 拷贝图片到沙箱(临时缓存目录)
  fs.copyFileSync(file.fd, targetPath) //拷贝文件 : 1.原始文件的地址或者id,  2.拷贝到的地址或id
  // 需要生成参数
  fileList.push({
    filename: fileName + '.jpg', // 文件名称
    name: 'file', // 接口的参数名称
    uri: `internal://cache/${fileName}.jpg`, // 应该是文件放到cache目录下 如果是cache协议 它会自动找这个文件
    type: 'jpg' // 文件后缀
  })
  fs.closeSync(file.fd)
})
return await uploadImage(getContext(), fileList)
// return uploadImageAPI(getContext(),fileList)
}


@Preview
@Component
struct HmUpload {
  @Prop canUpload:boolean = true
  onListChange: (list: ImageList[]) => void = () => {}
  maxSelectNumber: number = 3;
  @State title: string = '请上传'
  @Prop imgList: ImageList[] = []
  index = -1
  preview: CustomDialogController = new CustomDialogController({
    builder: HmPreview({
      urls: this.imgList.map(item =>
      item.url),
      selectIndex: this.index
    }),
    customStyle: true, // 自定义样式
  })

  async selectImage() {
    let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    PhotoSelectOptions.maxSelectNumber = this.maxSelectNumber - this.imgList.length;
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    let result= await photoPicker.select(PhotoSelectOptions)
    // AlertDialog.show({
    //   message: JSON.stringify(result.photoUris)
    // })
    if (result.photoUris?.length) {
      this.imgList =
        this.imgList.concat(result.photoUris.map(url => {
        return { url } as ImageList
      }))
    }
    UploadFile(this.imgList)
    this.onListChange(this.imgList)
  }



  build() {
    Column() {
      Text(this.title).fontSize(16)
        .fontColor($r('app.color.text_secondary'))
        .margin({ top: 16, bottom: 16 })
      // Row() {
      //   Image($r('app.media.ic_add_img')).size({ width: 30, height: 30 })
      // }.onClick(()=>{
      //   this.selectImage()
      // })
      // .width(95)
      // .height(95)
      // .backgroundColor("#F2F2F2")
      // .justifyContent(FlexAlign.Center)
      Grid() {
        ForEach(this.imgList, (item: ImageList,index:number) => {
          GridItem() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image(item.url)
                .width(95)
                .height(95)
                .borderRadius(4)
                .onClick(() => {
                  this.index = index
                  this.preview.open()
                })
              Image($r('app.media.ic_btn_delete')).width(
                30).height(30).onClick(() => {
                this.imgList.splice(index, 1) // 移除索引
                this.onListChange(this.imgList) // 通知父组件更新
              })
            }.margin({ right: 15, bottom: 10 })
          }
        })
        //如果图片数量不到最大值，最后面要追家+
        if(this.imgList.length < this.maxSelectNumber)
        {
          GridItem() {
            Row() {
              Image($r("app.media.ic_add_img")).width(30
              ).height(30)
            }
            .width(95)
            .height(95)
            .backgroundColor($r("app.color.upload_panel"))
            .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                this.selectImage()
              })
          }
        }
      }
      .height(Math.ceil(this.maxSelectNumber / 3 ) * 105)
      .columnsTemplate("1fr 1fr 1fr")
      .columnsGap(10)

    }.alignItems(HorizontalAlign.Start).width('100%')
  }
}
export { HmUpload }