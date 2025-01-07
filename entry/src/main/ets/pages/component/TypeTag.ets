import { TypeColor, TypeOffset } from '../../common/consts'
import { ColorUtil } from '../../util/ColorUtil'
import { ResUtil } from '../../util/ResUtil'

@ComponentV2
export default struct TypeTag {
  @Require @Param type: string
  @Param selected: boolean = true
  @Param showIcon: boolean = true

  build() {
    Row() {
      if (this.showIcon) {
        Image(ResUtil.getRawfileSpriteImageSync('images/types.webp', 0, TypeOffset[this.type], 50, 50))
          .width(20)
          .height(20)
          .colorFilter(this.selected ? undefined : ColorUtil.hexColorToColorFilter(TypeColor[this.type]))
          .margin({ right: 10 })
      }

      Text(this.type)
        .textAlign(TextAlign.Center)
        .fontSize(14)
        .fontColor(this.selected ? Color.White : Color.Black)
    }
    .height(25)
    .backgroundColor(this.selected ? TypeColor[this.type] : '#f4f4f5')
    .borderRadius(8)
    .padding({ left: 10, right: 10 })
  }
}