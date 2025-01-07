import { Ability } from '../../common/model'
import { PokeUtil } from '../../util/PokeUtil'
import FilterHead, { FilterType } from '../component/FilterHead'

@ComponentV2
export default struct AbilityList {
  @Consumer() pageStack: NavPathStack = new NavPathStack()
  @Local abilities: Ability[] = []
  scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    this.loadList()
  }

  build() {
    Column() {
      FilterHead({
        filter: FilterType.Ability,
        func: (key: string, _type: string, _category: string, generation: string, sort: string) => {
          this.loadList(key, generation, sort)
        }
      })
      Column() {
        List({ space: 10, scroller: this.scroller }) {
          ForEach(this.abilities, (a: Ability) => {
            ListItem() {
              Row() {
                Column() {
                  Text(a.name.trim())
                    .width('100%')
                    .maxLines(1)
                    .maxFontSize(16)
                    .minFontSize(14)
                    .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }.width('90%')

                Row() {
                  Text(`#${a.index}`).fontSize(14)
                }
                .height('100%')
                .width('20%')
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
              this.pageStack.pushPathByName('AbilityDetails', a)
            })
          })
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }

  loadList(key?: string, generation?: string, sort?: string) {
    PokeUtil.getAbilityList().then(res => {
      let list = res
      if (key) {
        list = list.filter(a => a.name.includes(key))
      }
      if (generation) {
        list = list.filter(a => a.generation === generation)
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
      this.abilities = list
    })
  }
}