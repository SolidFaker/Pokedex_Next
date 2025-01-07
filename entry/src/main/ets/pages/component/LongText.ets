import measure from '@ohos.measure';
import { curves, display } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { Log } from '../../util/Log';

@ComponentV2
export default struct LongText {
  @Require @Param text: string = ''
  @Local lines: number = 4; // 长文本状态（展开 or 收起）
  @Local isExpanded: boolean = false // 测量文本宽度（单位px）
  @Local textWidth: number = measure.measureText({ textContent: this.text, fontSize: 15 }) // 获取当前所有的display对象
  @Local button: string = '展开'
  promise: Promise<Array<display.Display>> = display.getAllDisplays()
  screenWidth: number = 0;

  aboutToAppear() {
    Log.info(`文本宽度为：${this.textWidth}`)
    this.promise.then((data: Array<display.Display>) => {
      Log.info(`所有的屏幕信息：${JSON.stringify(data)}`) //单位为像素
      this.screenWidth = data[0]["width"] // 屏幕宽度 * 最大行数 * 组件宽度比例 和 文字测量宽度
      this.isExpanded = this.screenWidth * this.lines * 0.8 <= this.textWidth
    }).catch((err: BusinessError) => {
      Log.error(`Failed to obtain all the display objects. Code: ${JSON.stringify(err)}`)
    })
  }

  build() {
    Row() {
      Column() {
        if (this.isExpanded) {
          Column() {
            Stack({ alignContent: Alignment.TopStart }) {
              Text(this.text.replaceAll('\n', '\n        '))
                .fontColor(Color.Black)
                .maxLines(this.lines)
                .width('100%')
                .textIndent(33)
            }

            Row() {
              Text(this.button).fontSize(15).fontColor(Color.Blue)
            }
            .width('100%')
            .justifyContent(FlexAlign.End)
            .onClick(() => {
              if (this.button == '展开') {
                this.button = '收起'; // 展开动画
                animateTo({ duration: 150, curve: curves.springMotion(0.5, 0.8), }, () => {
                  this.lines = -1; // 使得设置的最大行属性无效
                })
              } else {
                this.button = '展开'; // 收起动画
                animateTo({ duration: 100, curve: Curve.Friction, }, () => {
                  this.lines = 3; // 只显示3行
                })
              }
            })
          }
        } else {
          Text(this.text)
            .fontSize(15)
            .fontColor(Color.Black)
        }
      }.width('100%')
    }
  }
}