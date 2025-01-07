import { resourceManager } from '@kit.LocalizationKit'
import { HashMap, util } from '@kit.ArkTS'
import { Log } from './Log'
import { AppUtil } from './AppUtil'
import { image } from '@kit.ImageKit'

export class ResUtil {
  private static imageSourceMap: HashMap<string, image.ImageSource> = new HashMap()
  private static pixelMap: HashMap<string, PixelMap> = new HashMap()

  static getResourceManager(): resourceManager.ResourceManager {
    return AppUtil.getContext().resourceManager
  }

  static getRawfileImage(path: string): PixelMap {
    const pixelMap = ResUtil.getRawfileImageSourceMap(path).createPixelMapSync()
    return pixelMap
  }

  static getRawfileImageCache(path: string): PixelMap {
    if (ResUtil.pixelMap.hasKey(path)) {
      return ResUtil.pixelMap.get(path)
    } else {
      const pixelMap = ResUtil.getRawfileImageSourceMap(path).createPixelMapSync()
      ResUtil.pixelMap.set(path, pixelMap)
      return pixelMap
    }
  }

  static getRawfileSpriteImageSync(path: string, x: number, y: number, width: number, height: number): PixelMap {
    const key = `${path}${x}${y}${width}${height}`
    if (ResUtil.pixelMap.hasKey(key)) {
      Log.info('read cache SpriteImage: ', key)
      return ResUtil.pixelMap.get(key)
    } else {
      Log.info('save cache SpriteImage: ', key)
      const pixelMap = ResUtil.getRawfileImage(path)
      // 裁剪
      pixelMap.cropSync({
        size: {
          width: width, // 裁剪宽度
          height: height, // 裁剪高度
        },
        x: x, // 裁剪起始x坐标
        y: y, // 裁剪起始y坐标
      })
      ResUtil.pixelMap.set(key, pixelMap)
      return pixelMap
    }
  }

  static getRawfileContentStr(path: string): Promise<string> {
    return new Promise((resolve, reject) => {
      ResUtil.getResourceManager().getRawFileContent(path).then(res => {
        Log.info('读取文件：', path)
        let data = ResUtil.unit8ArrayToStr(res)
        resolve(data)
      }).catch((err: Error) => {
        reject(err)
      })
    })
  }

  static unit8ArrayToStr(byte: Uint8Array): string {
    let textDecoder = new util.TextDecoder()
    let result = textDecoder.decodeToString(byte)
    return result
  }

  static strToUint8Array(src: string): Uint8Array {
    let textEncoder = new util.TextEncoder()
    let result = textEncoder.encodeInto(src)
    return result
  }

  private static getRawfileImageSourceMap(path: string): image.ImageSource {
    Log.info('读取Image：', path)
    if (ResUtil.imageSourceMap.hasKey(path)) {
      return ResUtil.imageSourceMap.get(path)
    } else {
      const bytes = ResUtil.getResourceManager().getRawFileContentSync(path)
      const imageSource = image.createImageSource(bytes.buffer)
      ResUtil.imageSourceMap.set(path, imageSource)
      return imageSource
    }
  }
}