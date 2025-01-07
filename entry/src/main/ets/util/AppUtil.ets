import { common } from '@kit.AbilityKit';
import { Log } from './Log';

export class AppUtil {
  private static context: common.UIAbilityContext; //common.UIAbilityContext，上下文

  /**
   * 初始化方法,缓存全局变量，在UIAbility的onCreate方法中初始化该方法。
   * @param windowStage 窗口管理器
   */
  static init(context: common.UIAbilityContext) {
    AppUtil.context = context;
  }

  /**
   * 获取上下文，common.UIAbilityContext
   * @returns
   */
  static getContext(): common.UIAbilityContext {
    if (!AppUtil.context) {
      AppUtil.context = getContext() as common.UIAbilityContext; //兜底
      Log.error("context为空，请在UIAbility的onWindowStageCreate方法中调用AppUtil的init方法初始化！");
    }
    return AppUtil.context;
  }
}