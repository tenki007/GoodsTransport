import { HmNavBar, HmCard, HmCardItem } from 'basic'
import { MapComponent } from '@hms.core.map.MapComponent'
import geoLocationManager from '@ohos.geoLocationManager';
import { router } from '@kit.ArkUI';
import { map, mapCommon, site } from '@kit.MapKit';

class SiteClass {
  name: string = ""
  distance: number = 0
}

@Entry
@Component
struct SelectLocation {
  mapController: map.MapComponentController = new map.MapComponentController()
  @State list: SiteClass[] = []

  aboutToAppear() {

    // this.getLocation()
  }
  async getLocation() {
    try {
      const rightResult = await geoLocationManager.getCurrentLocation()
      // let wgs84Position: mapCommon.LatLng = {
      //   latitude: result.latitude,
      //   longitude: result.longitude
      // };
      // let rightResult: mapCommon.LatLng = await map.convertCoordinate(mapCommon.CoordinateType.WGS84,
      //   mapCommon.CoordinateType.GCJ02, wgs84Position);
      // 设置绿都广场坐标
      rightResult.latitude = 34.74855;
      rightResult.longitude = 113.703383;
      this.mapController.moveCamera(map.newCameraPosition({
        target: {
          longitude: rightResult.longitude,
          latitude: rightResult.latitude
        },
        zoom: 16 // 缩放级别
      }))
      this.mapController.addPointAnnotation({
        position: {
          longitude: rightResult.longitude,
          latitude: rightResult.latitude
        },
        titles: [{
          content: '您当前的位置'
        }],
      })
      const res = await site.nearbySearch({
        location: {
          longitude: rightResult.longitude,
          latitude: rightResult.latitude
        },
        pageSize: 4,
        pageIndex: 1,
        radius: 50
      })
      this.list = res.sites?.slice(0,4) as SiteClass[] // 只拿4条数据
    } catch (error) {
      AlertDialog.show({
        message: error.message
      })
    }

  }

  build() {
    Column() {
      HmNavBar({ title: '当前位置' })
      Stack({ alignContent: Alignment.Bottom }) {
        //  地图区域
        MapComponent({
          mapOptions: {
            position: {
              target: {
                latitude: 34.74855,
                longitude: 113.703383
              },
              zoom: 10
            }
          },
          mapCallback: (err, controller) => {
            if(!err) {
              this.mapController = controller
              this.getLocation()
            }
          }
        })
        Column() {
          HmCard() {
            ForEach(this.list, (item: SiteClass) => {
              HmCardItem({ leftTitle: item.name, rightText: `${item.distance}m` ,onRightClick:() => {
                router.back({
                  url: "pages/tabs/Task/ExceptionReport/ExceptionReport",
                  params: {
                    location: item.name
                  }
                })
              }})

            })
          }
        }
        .padding({
          bottom: 60
        })
      }
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}