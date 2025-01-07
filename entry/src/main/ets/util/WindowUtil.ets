import { AppStorageV2, display, window } from '@kit.ArkUI'
import { Log } from './Log'
import { BusinessError } from '@kit.BasicServicesKit'

export class WindowUtil {
  static fullScreen(windowStage: window.WindowStage) {
    // 全屏
    windowStage.getMainWindow((err, windowClass) => {
      if (err.code) {
        Log.error('Failed to load the content. Cause: ', JSON.stringify(err))
        return
      }

      //全屏
      windowClass.setWindowLayoutFullScreen(true)
        .then(() => {
          Log.info('Succeeded in setting the window layout to full-screen mode.')
        })
        .catch((err: BusinessError) => {
          Log.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err))
        })
      // 获取导航栏避让遮挡的区域
      let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR //导航栏
      let avoidArea = windowClass.getWindowAvoidArea(type)
      let bottomRectHeight = avoidArea.bottomRect.height
      // AppStorage.setOrCreate('bottomRectHeight', px2vp(bottomRectHeight))

      // 获取状态栏避让遮挡的区域
      type = window.AvoidAreaType.TYPE_SYSTEM // 状态栏
      avoidArea = windowClass.getWindowAvoidArea(type)
      let topRectHeight = avoidArea.topRect.height
      // AppStorage.setOrCreate('topRectHeight', px2vp(topRectHeight))

      // 手机屏幕高度和宽度
      let defaultDisplay = display.getDefaultDisplaySync()
      let windowHeight = defaultDisplay.height
      let windowWidth = defaultDisplay.width
      // AppStorage.setOrCreate('windowHeight', px2vp(windowHeight))
      // AppStorage.setOrCreate('windowWidth', px2vp(windowWidth))

      AppStorageV2.connect(WindowInfo,
        () => new WindowInfo(px2vp(topRectHeight), px2vp(bottomRectHeight), px2vp(windowHeight), px2vp(windowWidth)))
    })
  }
}

@ObservedV2
export class WindowInfo {
  topRectHeight: number
  bottomRectHeight: number
  windowHeight: number
  windowWidth: number

  constructor(topRectHeight: number, bottomRectHeight: number, windowHeight: number, windowWidth: number) {
    this.topRectHeight = topRectHeight
    this.bottomRectHeight = bottomRectHeight
    this.windowHeight = windowHeight
    this.windowWidth = windowWidth
  }
}