@ComponentV2
export default struct InfoCard {
  @Require @Param title: string
  @Require @Param name: string
  @Param cardWidth: Length = 150
  @Param cardHeight: Length = 56

  build() {
    Column({ space: 5 }) {
      Text(this.title)
        .fontSize(14)
        .fontColor(Color.Gray)

      Text(this.name)
        .fontSize(16)
        .textOverflow({ overflow: TextOverflow.MARQUEE })
    }
    .width(this.cardWidth)
    .height(this.cardHeight)
    .backgroundColor($r('app.color.custom_gray'))
    .borderRadius(10)
    .padding({
      top: 8,
      bottom: 8,
      left: 12,
      right: 12
    })
  }
}