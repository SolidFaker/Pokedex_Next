import { Pokemon } from '../../common/model'
import { PokeUtil } from '../../util/PokeUtil'
import { ResUtil } from '../../util/ResUtil'
import FilterHead, { FilterType } from '../component/FilterHead'
import TypeTag from '../component/TypeTag'

@ComponentV2
export default struct PokemonList {
  @Consumer() pageStack: NavPathStack = new NavPathStack()
  @Local pokemon: Pokemon[] = []
  scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    this.loadList()
  }

  build() {
    Column() {
      FilterHead({
        filter: FilterType.Pokemon,
        func: (key: string, type: string, _: string, generation: string, sort: string) => {
          this.loadList(key, type, generation, sort)
        }
      })

      Column() {
        List({ space: 10, scroller: this.scroller }) {
          ForEach(this.pokemon, (p: Pokemon) => {
            ListItem() {
              Row() {
                Text()
                  .width(56)
                  .height(56)
                  .backgroundImage(ResUtil.getRawfileImageCache('images/normal.webp'))
                  .backgroundImageSize({
                    width: 4480 / 2,
                    height: 4480 / 2
                  })
                  .backgroundImagePosition({
                    x: p.meta.icon_position.split(',')[0],
                    y: p.meta.icon_position.split(',')[1]
                  })

                Column() {
                  Text(p.name.trim())
                    .width('50%')
                    .maxLines(1)
                    .maxFontSize(16)
                    .minFontSize(14)
                    .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Row() {
                    ForEach(p.types, (type: string) => {
                      TypeTag({ type: type, showIcon: false })
                        .margin({ right: 5 })
                    })
                  }.margin({ top: 5 })
                  .width('50%')
                }.margin({ left: 10 })

                Row() {
                  Text(`#${p.index}`).fontSize(14)
                }
                .height('100%')
                .width('50%')
                .layoutWeight(1)
                .reverse(true)
              }
              .width('100%')
            }
            .width('100%')
            .height(82)
            .borderRadius(10)
            .borderWidth(1)
            .borderColor('#e5e7eb')
            .padding(12)
            .onClick(() => {
              this.pageStack.pushPathByName('PokemonDetails', p)
            })
          })
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Auto)
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }

  loadList(key?: string, type?: string, generation?: string, sort?: string) {
    PokeUtil.getPokemonList().then(res => {
      let list = res
      if (key) {
        list = list.filter(p => p.name.includes(key))
      }
      if (type) {
        list = list.filter(p => p.types.includes(type))
      }
      if (generation) {
        list = list.filter(p => p.generation === generation)
      }
      if (sort) {
        list = list.sort((p1, p2) => {
          if (sort === 'asc') {
            return Number.parseInt(p1.index) - Number.parseInt(p2.index)
          } else {
            return Number.parseInt(p2.index) - Number.parseInt(p1.index)
          }
        })
      }
      this.scroller.scrollToIndex(0, true)
      this.pokemon = list
    })
  }
}