import { Categories, CategoryColor, Generations, Types } from '../../common/consts'
import { Log } from '../../util/Log'
import { AppStorageV2, LengthUnit } from '@kit.ArkUI'
import { WindowInfo } from '../../util/WindowUtil'
import TypeTag from './TypeTag'

@ComponentV2
export default struct FilterHead {
  @Require @Param filter: FilterType
  @Require @Param func: (key: string, type: string, category: string, generation: string, sort: string) => void
  @Local windowInfo: WindowInfo = AppStorageV2.connect(WindowInfo, () => new WindowInfo(0, 0, 0, 0))!
  @Local currentType: string = ''
  @Local currentCategory: string = ''
  @Local currentGeneration: string = ''
  @Local sort: 'asc' | 'desc' = 'asc'
  @Local search: string = ''
  @Local showFilter: boolean = false

  @Monitor('currentType','currentCategory','currentGeneration','sort','search')
  filterChange() {
    this.func(this.search, this.currentType, this.currentCategory, this.currentGeneration, this.sort)
  }

  build() {
    Row() {
      Search({ value: this.search, placeholder: '搜索' + this.filter })
        .width('90%')
        .height(40)
        .onChange(value => {
          this.search = value
          Log.info('查询：', value)
        })

      Button() {
        Row() {
          SymbolGlyph($r('sys.symbol.dot_grid_2x2'))
            .fontWeight(FontWeight.Normal)
            .fontSize(35)
        }.reverse(true)
      }
      .buttonStyle(ButtonStyleMode.TEXTUAL)
      .stateEffect(false)
      .onClick(() => {
        this.showFilter = !this.showFilter
      })

      Flex()
        .width(0)
        .height(0)
        .borderRadius({ topRight: 30, bottomRight: 30 })
        .bindSheet(this.showFilter, this.view(), {
          title: {
            title: '筛选',
          },
          height: SheetSize.FIT_CONTENT,
          showClose: true,
          dragBar: false,
          blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
          onDisappear: () => {
            this.showFilter = false
          },
        })
    }
    .width('100%')

  }

  @Builder
  view() {
    Column() {
      if (this.filter !== FilterType.Ability) {
        Flex({
          wrap: FlexWrap.Wrap,
          space: {
            main: { value: 10, unit: LengthUnit.VP },
            cross: { value: 10, unit: LengthUnit.VP }
          }
        }) {
          ForEach(Types, (type: string) => {
            TypeTag({ type: type, selected: this.currentType === type })
              .onClick(() => {
                if (this.currentType === type) {
                  this.currentType = ''
                } else {
                  this.currentType = type
                }
              })
          })
        }
        .width('100%')
        .margin({ top: 10, bottom: 10 })

        Divider().color('#e5e5e8').width('90%')
      }
      if (this.filter === FilterType.Skill) {
        Flex({
          wrap: FlexWrap.Wrap,
          space: {
            main: { value: 10, unit: LengthUnit.VP },
            cross: { value: 10, unit: LengthUnit.VP }
          }
        }) {
          ForEach(Categories, (category: string) => {
            Row() {
              Text(category)
                .textAlign(TextAlign.Center)
                .fontSize(14)
                .fontColor(this.currentCategory === category ? Color.White : Color.Black)
            }
            .height(25)
            .backgroundColor(this.currentCategory === category ? CategoryColor[category] : '#f4f4f5')
            .borderRadius(8)
            .padding({ left: 10, right: 10 })
            .onClick(() => {
              if (this.currentCategory === category) {
                this.currentCategory = ''
              } else {
                this.currentCategory = category
              }
            })
          })
        }
        .width('100%')
        .margin({ top: 10, bottom: 10 })

        Divider().color('#e5e5e8').width('90%')
      }
      Flex({
        wrap: FlexWrap.Wrap,
        space: {
          main: { value: 10, unit: LengthUnit.VP },
          cross: { value: 10, unit: LengthUnit.VP }
        }
      }) {
        ForEach(Generations, (generation: string) => {
          Row() {
            Text(generation)
              .textAlign(TextAlign.Center)
              .fontSize(14)
              .fontColor(this.currentGeneration === generation ? Color.White : Color.Black)
          }
          .height(25)
          .backgroundColor(this.currentGeneration === generation ? Color.Black : '#f4f4f5')
          .borderRadius(8)
          .padding({ left: 10, right: 10 })
          .onClick(() => {
            if (this.currentGeneration === generation) {
              this.currentGeneration = ''
            } else {
              this.currentGeneration = generation
            }
          })
        })
      }
      .width('100%')
      .margin({ top: 10, bottom: 10 })

      Divider().color('#e5e5e8').width('90%')

      Row() {
        Row() {
          Radio({ value: 'asc', group: 'sort' })
            .height(20)
            .width(20)
            .checked(this.sort === 'asc')
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.sort = 'asc'
              }
            })
          Text('顺序排列')
            .fontSize(16)
            .onClick(() => {
              this.sort = 'asc'
            })
        }
        .margin({ right: 20 })

        Row() {
          Radio({ value: 'asc', group: 'sort' })
            .height(20)
            .width(20)
            .checked(this.sort === 'desc')
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.sort = 'desc'
              }
            })
          Text('倒序排列')
            .fontSize(16)
            .onClick(() => {
              this.sort = 'desc'
            })
        }
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .padding({
      left: 20,
      right: 20,
      bottom: this.windowInfo.bottomRectHeight
    })
  }
}

export enum FilterType {
  Pokemon = '宝可梦',
  Skill = '技能',
  Ability = '特性'
}