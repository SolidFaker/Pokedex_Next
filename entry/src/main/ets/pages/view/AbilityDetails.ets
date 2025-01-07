import { WindowInfo } from '../../util/WindowUtil'
import { AppStorageV2 } from '@kit.ArkUI'
import { Ability, AbilityDetail, Pokemon } from '../../common/model'
import { Log } from '../../util/Log'
import { PokeUtil } from '../../util/PokeUtil'
import { BackType, TitleBar, TitleType } from '../component/TitleBar'
import InfoCard from '../component/InfoCard'
import TypeTag from '../component/TypeTag'

@Builder
export function AbilityDetailsBuilder(_name: string, param: Ability) {
  AbilityDetails({ ability: param })
}

@ComponentV2
export default struct AbilityDetails {
  @Consumer() pageStack: NavPathStack = new NavPathStack()
  @Local windowInfo: WindowInfo = AppStorageV2.connect(WindowInfo, () => new WindowInfo(0, 0, 0, 0))!
  @Require @Param ability: Ability
  @Local inLoading: boolean = true
  @Local detail: AbilityDetail = undefined!

  aboutToAppear(): void {
    Log.info(JSON.stringify(this.ability))
    PokeUtil.getAbilityDetail(this.ability.index, this.ability.name).then(res => {
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
          centerText: this.ability.name,
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
              }
              .width('100%')
              .align(Alignment.Center)

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

                Text('具有该特性的宝可梦')
                  .width('100%')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)

                Column({ space: 5 }) {
                  ForEach(this.detail.pokemon, (p: Pokemon) => {
                    Row() {
                      Column() {
                        Text(p.name.trim())
                          .width('100%')
                          .maxLines(1)
                          .maxFontSize(16)
                          .minFontSize(14)
                          .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })

                        Row({ space: 5 }) {
                          ForEach(p.types, (t: string) => {
                            TypeTag({ type: t, showIcon: true })
                          })
                        }
                        .width('100%')
                        .margin({ top: 5 })
                      }
                      .layoutWeight(1)

                      Row() {
                        Text(p.first === this.detail.name ? '第一特性' :
                          p.second === this.detail.name ? '第二特性' : '隐藏特性')
                          .fontSize(14)
                      }
                      .height('100%')
                      .layoutWeight(1)
                      .reverse(true)
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
              }
              .width('100%')
              .height('auto')
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
}