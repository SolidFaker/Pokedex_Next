import { CategoryColor } from '../../common/consts'
import { Skill } from '../../common/model'
import { PokeUtil } from '../../util/PokeUtil'
import FilterHead, { FilterType } from '../component/FilterHead'
import TypeTag from '../component/TypeTag'

@ComponentV2
export default struct SkillList {
  @Consumer() pageStack: NavPathStack = new NavPathStack()
  @Local skills: Skill[] = []
  scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    this.loadList()
  }

  build() {
    Column() {
      FilterHead({
        filter: FilterType.Skill,
        func: (key: string, type: string, category: string, generation: string, sort: string) => {
          this.loadList(key, type, category, generation, sort)
        }
      })
      Column() {
        List({ space: 10, scroller: this.scroller }) {
          ForEach(this.skills, (s: Skill) => {
            ListItem() {
              Row() {
                Column() {
                  Text(s.name.trim())
                    .width('100%')
                    .maxLines(1)
                    .maxFontSize(16)
                    .minFontSize(14)
                    .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Row() {
                    Text(s.category)
                      .height(25)
                      .textAlign(TextAlign.Center)
                      .fontSize(14)
                      .fontColor(Color.White)
                      .backgroundColor(CategoryColor[s.category])
                      .borderRadius(8)
                      .padding({ left: 10, right: 10 })
                      .margin({ right: 10 })

                    TypeTag({ type: s.type, showIcon: false })
                  }
                  .width('100%')
                  .margin({ top: 5 })
                }.width('90%')

                Row() {
                  Text(`#${s.index}`).fontSize(14)
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
              this.pageStack.pushPathByName('SkillDetails', s)
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

  loadList(key?: string, type?: string, category?: string, generation?: string, sort?: string) {
    PokeUtil.getSkillList().then(res => {
      let list = res
      if (key) {
        list = list.filter(s => s.name.includes(key))
      }
      if (type) {
        list = list.filter(s => s.type === type)
      }
      if (category) {
        list = list.filter(s => s.category === category)
      }
      if (generation) {
        list = list.filter(s => s.generation === generation)
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
      this.skills = list
    })
  }
}