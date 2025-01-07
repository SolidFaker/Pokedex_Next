import { CategoryColor, TypeOffset } from '../../common/consts'
import { ColorUtil } from '../../util/ColorUtil'
import { ResUtil } from '../../util/ResUtil'

@ComponentV2
export default struct CategoryTag {
  @Require @Param category: string
  @Param selected: boolean = true
  @Param showIcon: boolean = true

  build() {
    Row() {
      if (this.showIcon && !this.category.includes('极巨')) {
        Image(ResUtil.getRawfileSpriteImageSync('images/types.webp', 0, TypeOffset[this.category], 50, 50))
          .width(20)
          .height(20)
          .colorFilter(this.selected ? undefined : ColorUtil.hexColorToColorFilter(CategoryColor[this.category]))
          .margin({ right: 10 })
      }

      Text(this.category)
        .textAlign(TextAlign.Center)
        .fontSize(14)
        .fontColor(this.selected ? Color.White : Color.Black)
    }
    .height(25)
    .backgroundColor(this.selected ? CategoryColor[this.category] : '#f4f4f5')
    .borderRadius(8)
    .padding({ left: 10, right: 10 })
  }
}