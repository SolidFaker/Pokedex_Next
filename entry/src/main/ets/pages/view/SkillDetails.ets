import { WindowInfo } from '../../util/WindowUtil'
import { AppStorageV2 } from '@kit.ArkUI'
import { Pokemon, Skill, SkillDetail } from '../../common/model'
import { Log } from '../../util/Log'
import { PokeUtil } from '../../util/PokeUtil'
import { BackType, TitleBar, TitleType } from '../component/TitleBar'
import TypeTag from '../component/TypeTag'
import CategoryTag from '../component/CategoryTag'
import InfoCard from '../component/InfoCard'
import { MCollapse, MCollapseType } from 'mooney_ui'

@Builder
export function SkillDetailsBuilder(_name: string, param: Skill) {
  SkillDetails({ skill: param })
}

@ComponentV2
export default struct SkillDetails {
  @Consumer() pageStack: NavPathStack = new NavPathStack()
  @Local windowInfo: WindowInfo = AppStorageV2.connect(WindowInfo, () => new WindowInfo(0, 0, 0, 0))!
  @Require @Param skill: Skill
  @Local inLoading: boolean = true
  @Local detail: SkillDetail = undefined!

  aboutToAppear(): void {
    Log.info(JSON.stringify(this.skill))
    PokeUtil.getSkillDetail(this.skill.index, this.skill.name).then(res => {
      this.detail = res
      this.inLoading = false
    })
  }

  build() {
    NavDestination() {
      Column() {
        TitleBar({
          titleBarColor: Color.White,
          statusBarColor: Color.White,
          centerType: TitleType.TEXT,
          centerText: this.skill.name,
          leftBackType: BackType.NONE,
          leftOnClick: () => {
            this.pageStack.pop()
          }
        })

        if (!this.inLoading) {
          Scroll(new Scroller()) {
            Column() {
              Column({ space: 10 }) {
                Blank().height(5)

                Column({ space: 10 }) {
                  Text(this.detail.text)

                  Row({ space: 10 }) {
                    TypeTag({ type: this.detail.type })
                    CategoryTag({ category: this.detail.category })
                  }

                  Row({ space: 10 }) {
                    this.SimpleCard('威力', this.detail.power)
                    this.SimpleCard('命中', this.detail.accuracy)
                    this.SimpleCard('PP', this.detail.pp)
                  }

                  Row({ space: 20 }) {
                    InfoCard({ title: '编号', name: this.detail.index })
                    InfoCard({ title: '引入世代', name: this.detail.generation })
                  }

                  Row({ space: 20 }) {
                    InfoCard({ title: '日文名', name: this.detail.name_jp })
                    InfoCard({ title: '英文名', name: this.detail.name_en })
                  }
                }
                .width('100%')

                Column({ space: 8 }) {
                  Blank().height(30)

                  Text('效果')
                    .width('100%')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)

                  ForEach(this.detail.effect.split('\n'), (e: string) => {
                    Text(e).width('100%')
                  })
                }
                .width('100%')
                .align(Alignment.Center)

                Column({ space: 8 }) {
                  Blank().height(30)

                  Text('范围')
                    .width('100%')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)

                  Text(this.detail.range).width('100%')
                }
                .width('100%')
                .align(Alignment.Center)

                Column({ space: 10 }) {
                  Blank().height(30)

                  Text('基本信息')
                    .width('100%')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)

                  ForEach(this.detail.info, (i: string) => {
                    Text('● ' + i).width('100%')
                  })
                }
                .width('100%')
                .align(Alignment.Center)

                Column({ space: 10 }) {
                  Blank().height(30)

                  Text('可以学会该招式的宝可梦')
                    .width('100%')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                  if (this.detail.pokemon.level.length !== 0) {
                    this.Collapse(this.generateCollapseOptions('通过升级方式', true), this.detail.pokemon.level)
                  }
                  if (this.detail.pokemon.machine.length !== 0) {
                    this.Collapse(this.generateCollapseOptions('通过招式学习器'), this.detail.pokemon.machine)
                  }
                  if (this.detail.pokemon.egg.length !== 0) {
                    this.Collapse(this.generateCollapseOptions('通过遗传'), this.detail.pokemon.egg)
                  }
                  if (this.detail.pokemon.tutor.length !== 0) {
                    this.Collapse(this.generateCollapseOptions('通过招式教学'), this.detail.pokemon.tutor)
                  }
                }
                .width('100%')
                .align(Alignment.Center)
              }
              .width('100%')
              .align(Alignment.Center)
            }
            .width('100%')
            .padding({
              left: 15,
              right: 15,
              bottom: this.windowInfo.bottomRectHeight
            })
          }
          .scrollBar(BarState.Off)
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
    }
    .mode(NavDestinationMode.STANDARD)
    .hideTitleBar(true)
  }

  @Builder
  SimpleCard(title: string, data: string) {
    Row({ space: 5 }) {
      Text(title)
        .width('50%')
        .textAlign(TextAlign.Center)
        .fontSize(16)
        .fontColor(Color.Gray)

      Text(data)
        .width('50%')
        .textAlign(TextAlign.Center)
        .fontSize(16)
    }
    .width(100)
    .height(36)
    .backgroundColor($r('app.color.custom_gray'))
    .borderRadius(10)
    .padding({
      top: 8,
      bottom: 8,
      left: 16,
      right: 16
    })
  }

  generateCollapseOptions(name: string, expanded: boolean = false) {
    return [
      new MCollapseType.CollapseOptions({
        title: name,
        expanded: expanded,
        destroy: true,
        headProps: {
          bgColor: Color.White,
        },
        props: {
          border: {
            width: {
              top: 0,
              left: 0,
              right: 0,
              bottom: 1
            },
            color: '#eee'
          }
        }
      })
    ]
  }

  @Builder
  Collapse(list: MCollapseType.CollapseOptions[], data: Pokemon[]) {
    MCollapse({
      controller: new MCollapseType.CollapseController(),
      list: list,
      builder: () => {
        this.CollapseBuilder(data)
      }
    })
  }

  @Builder
  CollapseBuilder(data: Pokemon[]) {
    Column({ space: 5 }) {
      ForEach(data, (p: Pokemon) => {
        Row() {
          Column() {
            Text(p.name.trim())
              .width('100%')
              .maxLines(1)
              .maxFontSize(16)
              .minFontSize(14)
              .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .layoutWeight(1)

          Row() {
            Text('#' + p.index)
              .fontSize(14)
          }
          .height('100%')
          .layoutWeight(1)
          .reverse(true)
        }
        .width('100%')
        .height(41)
        .borderRadius(10)
        .borderWidth(1)
        .borderColor('#e5e7eb')
        .padding(12)
        .onClick(() => {
          this.pageStack.pushPathByName('PokemonDetails', p)
        })
      })
    }
  }
}