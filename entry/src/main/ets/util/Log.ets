import hilog from '@ohos.hilog'
import { BusinessError } from '@kit.BasicServicesKit'

const LOGGER_DOMAIN: number = 0x0000
const LOGGER_TAG: string = 'PokedexLog'

/**
 * TODO 日志工具类
 * author: 桃花镇童长老ᥫ᭡
 * since: 2024/05/01
 * 仓库主页：https://ohpm.openharmony.cn/#/cn/detail/@pura%2Fharmony-utils
 * github: https://github.com/787107497
 * gitee: https://gitee.com/tongyuyan/harmony-utils
 * CSDN: https://blog.csdn.net/qq_32922545
 * QQ交流群: 569512366
 */
export class Log {
  private static domain: number = LOGGER_DOMAIN
  private static tag: string = LOGGER_TAG //日志Tag
  private static format: string = '%{public}s'
  private static showLog: boolean = true //是否显示打印日志


  /**
   * 初始化日志参数（该方法建议在Ability里调用）
   * @param domain
   * @param tag
   * @param showLog
   */
  static init(domain: number = LOGGER_DOMAIN, tag: string = LOGGER_TAG, showLog: boolean = true) {
    Log.domain = domain
    Log.tag = tag
    Log.showLog = showLog
  }

  /**
   * 设置日志对应的领域标识，范围是0x0~0xFFFF。（该方法建议在Ability里调用）
   * @param domain
   */
  static setDomain(domain: number = LOGGER_DOMAIN) {
    Log.domain = domain
  }

  /**
   * 设置日志标识（该方法建议在Ability里调用）
   * @param tag
   */
  static setTag(tag: string = LOGGER_TAG) {
    Log.tag = tag
  }

  /**
   * 是否打印日志（该方法建议在Ability里调用）
   * @param showLog
   */
  static setShowLog(showLog: boolean = true) {
    Log.showLog = showLog
  }

  /**
   * 打印DEBUG级别日志
   * @param args
   */
  static debug(...args: string[]): void {
    if (Log.showLog) {
      hilog.debug(Log.domain, Log.tag, Log.format.repeat(args.length), args)
    }
  }

  /**
   * 打印INFO级别日志
   * @param args
   */
  static info(...args: string[]): void {
    if (Log.showLog) {
      hilog.info(Log.domain, Log.tag, Log.format.repeat(args.length), args)
    }
  }

  /**
   * 打印WARN级别日志
   * @param args
   */
  static warn(...args: string[]): void {
    if (Log.showLog) {
      hilog.warn(Log.domain, Log.tag, Log.format.repeat(args.length), args)
    }
  }

  /**
   * 打印ERROR级别日志
   * @param args
   */
  static error(...args: string[]): void {
    if (Log.showLog) {
      hilog.error(Log.domain, Log.tag, Log.format.repeat(args.length), args)
    }
  }

  /**
   * 打印FATAL级别日志
   * @param args
   */
  static fatal(...args: string[]): void {
    if (Log.showLog) {
      hilog.fatal(Log.domain, Log.tag, Log.format.repeat(args.length), args)
    }
  }


  /**
   * 打印JSON对象和JSON字符串
   * @param obj
   */
  static print(obj: object | string) {
    try {
      if (typeof obj === 'object') {
        let str = JSON.stringify(obj, null, 2)
        let arr: string[] = str.split('\n')
        for (let index = 0; index < arr.length; index++) {
          console.debug(arr[index])
        }
      } else {
        obj = JSON.parse(obj)
        let str = JSON.stringify(obj, null, 2)
        let arr = str.split('\n')
        for (let index = 0; index < arr.length; index++) {
          console.debug(arr[index])
        }
      }
    } catch (err) {
      let error = err as BusinessError; //异常了，说明不是JSON字符串
      Log.error(`Log-print-异常 ~ code: ${error.code} -·- message: ${error.message}`);
    }
  }
}