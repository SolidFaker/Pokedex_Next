@ComponentV2
export default struct CommonTable {
  @Require @Param options: TableOption[]
  @Require @Param list: ESObject[]

  build() {
    Scroll() {
      Column() {
        this.Header()
        ForEach(this.list, (l: ESObject) => {
          this.Body(l)
        })
      }
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }

  @Builder
  Header() {
    Row({ space: 5 }) {
      ForEach(this.options, (o: TableOption) => {
        Text(o.title).width(o.width).textAlign(TextAlign.Center)
      })
    }
    .height(40)
  }

  @Builder
  Body(data: ESObject) {
    Row({ space: 5 }) {
      ForEach(this.options, (o: TableOption) => {
        Row() {
          if (o.builder) {
            o.builder.builder(data[o.key])
          } else {
            Text(o.formatter ? o.formatter(data[o.key]) : data[o.key])
              .width(o.width)
              .textAlign(TextAlign.Center)
          }
        }
        .width(o.width)
        .onClick(() => {
          if (o.onClick) {
            o.onClick(data[o.key])
          }
        })
      })
    }
    .height(40)
    .borderWidth({
      bottom: 1
    })
    .borderColor($r('app.color.custom_gray'))
  }
}

export interface TableOption {
  title: string,
  key: string,
  width: number,
  formatter?: (value: string) => string
  builder?: WrappedBuilder<[string]>
  onClick?: (value: string) => void
}