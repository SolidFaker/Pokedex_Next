import { TypeColor, TypeOffset } from '../../common/consts'
import { ColorUtil } from '../../util/ColorUtil'
import { ResUtil } from '../../util/ResUtil'

@ComponentV2
export default struct TypeTag {
  @Require @Param type: string
  @Param selected: boolean = true
  @Param showIcon: boolean = true
  @Param tagWidth: number | undefined = undefined
  @Param tagHeight: number = 25
  @Param fontSize: number = 14
  @Param iconWidth: number = 20

  build() {
    Row() {
      if (this.showIcon) {
        Image(ResUtil.getRawfileSpriteImageSync('images/types.webp', 0, TypeOffset[this.type], 50, 50))
          .width(this.iconWidth)
          .height(this.iconWidth)
          .colorFilter(this.selected ? undefined : ColorUtil.hexColorToColorFilter(TypeColor[this.type]))
          .margin({ right: 10 })
      }

      Text(this.type)
        .textAlign(TextAlign.Center)
        .fontSize(this.fontSize)
        .fontColor(this.selected ? Color.White : Color.Black)
    }
    .width(this.tagWidth)
    .height(this.tagHeight)
    .backgroundColor(this.selected ? TypeColor[this.type] : '#f4f4f5')
    .borderRadius(8)
    .padding({ left: 10, right: 10 })
  }
}