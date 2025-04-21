import { Ability, AbilitySimple, EvolutionChain, Pokemon, PokemonDetail, Version } from '../../common/model'
import { PokeUtil } from '../../util/PokeUtil'
import { BackType, TitleBar, TitleType } from '../component/TitleBar'
import { SlidingTabController, SlidingTabsV2 } from '@xqw/sliding-tabs'
import { ResUtil } from '../../util/ResUtil'
import TypeTag from '../component/TypeTag'
import { Log } from '../../util/Log'
import InfoCard from '../component/InfoCard'
import { WindowInfo } from '../../util/WindowUtil'
import { AppStorageV2 } from '@kit.ArkUI'
import LongText from '../component/LongText'
import StatChart from '../component/StatChart'
import { MCollapse, MCollapseType } from 'mooney_ui'
import EvolveChain from '../component/EvolveChain'
import { CategoryColor, TypeColor } from '../../common/consts'
import CommonTable from '../component/CommonTable'

@Builder
export function PokemonDetailsBuilder(_name: string, param: Pokemon) {
  PokemonDetails({ pokemon: param })
}

@ComponentV2
export default struct PokemonDetails {
  @Consumer() pageStack: NavPathStack = new NavPathStack()
  @Local windowInfo: WindowInfo = AppStorageV2.connect(WindowInfo, () => new WindowInfo(0, 0, 0, 0))!
  @Require @Param pokemon: Pokemon
  @Local inLoading: boolean = true
  @Local detail: PokemonDetail = undefined!
  @Local formTab: string[] = []
  @Local currentForm: number = 0
  @Local statTab: string[] = []
  @Local currentStat: number = 0
  @Local abilities: Ability[] = []
  @Local learnedTab: string[] = []
  @Local currentLearned: number = 0
  @Local machineTab: string[] = []
  @Local currentMachine: number = 0
  configArr: Array<MCollapseType.CollapseOptions> = []

  aboutToAppear(): void {
    PokeUtil.getPokemonDetail(this.pokemon.index, this.pokemon.name.split('-')[0]).then(res => {
      this.detail = res
      this.formTab = res.forms.map(f => f.name)
      this.statTab = res.stats.map(s => s.form)
      this.learnedTab = res.moves.learned.map(l => l.form)
      this.machineTab = res.moves.machine.map(l => l.form)
      this.inLoading = false
      res.flavor_texts.forEach((f, i) => {
        this.configArr.push(new MCollapseType.CollapseOptions({
          title: f.name,
          expanded: false,
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
        }))
      })
    })
    PokeUtil.getAbilityList().then(res => {
      this.abilities = res
    })
  }

  build() {
    NavDestination() {
      Column() {
        TitleBar({
          titleBarColor: Color.White,
          statusBarColor: Color.White,
          centerType: TitleType.TEXT,
          centerText: this.pokemon.name.split('-')[0],
          leftBackType: BackType.NONE,
          leftOnClick: () => {
            this.pageStack.pop()
          }
        })

        if (!this.inLoading) {
          Scroll(new Scroller()) {
            Column() {
              if (this.formTab.length > 1) {
                SlidingTabsV2({
                  tabs: this.formTab,
                  barMode: "scroll",
                  tabController: new SlidingTabController(),
                  tabStyle: {
                    fontColor: '#717179',
                    fontColorSelect: Color.Black,
                    fontWeightSelect: FontWeight.Bold,
                    padding: {
                      left: 12,
                      right: 12,
                      top: 6,
                      bottom: 6
                    }
                  },
                  indicatorStyle: {
                    wrapTab: true,
                    padding: 10
                  },
                  onTabIndicatorBuilder: () => {
                    this.TabIndicator()
                  },
                  onChange: (index) => {
                    Log.info('change: ', index.toString())
                    Log.info(this.detail?.forms[index].height)
                    this.currentForm = index
                  }
                })
                  .backgroundColor($r('app.color.custom_gray'))
              }

              Column() {
                Column({ space: 10 }) {
                  Image(ResUtil.getRawfileImageCache(`images/official/${this.detail?.forms[this.currentForm].index}-${this.detail?.forms[this.currentForm].name}.png`))
                    .width(180)
                    .height(180)

                  Row({ space: 10 }) {
                    ForEach(this.detail?.forms[this.currentForm].types, (type: string) => {
                      TypeTag({ type: type, showIcon: true, selected: true })
                    })
                  }

                  Text(this.detail?.forms[this.currentForm].genus)
                    .backgroundColor($r('app.color.custom_gray'))
                    .padding({
                      left: 12,
                      right: 12,
                      top: 4,
                      bottom: 4
                    })
                    .borderRadius(50)

                  Row({ space: 20 }) {
                    InfoCard({ title: '英文名', name: this.detail?.name_en })
                    InfoCard({ title: '日文名', name: this.detail?.name_jp })
                  }

                  Row({ space: 20 }) {
                    InfoCard({ title: '高度', name: this.detail?.forms[this.currentForm].height })
                    InfoCard({ title: '重量', name: this.detail?.forms[this.currentForm].weight })
                  }

                  Row({ space: 20 }) {
                    InfoCard({ title: '体型', name: this.detail?.forms[this.currentForm].shape })
                    InfoCard({
                      title: '100级经验值',
                      name: `${this.detail?.forms[this.currentForm].experience.number}(${this.detail?.forms[this.currentForm].experience.speed})`
                    })
                  }

                  Row({ space: 20 }) {
                    InfoCard({ title: '蛋群', name: this.detail?.forms[this.currentForm].egg_groups.join(',') })
                    InfoCard({ title: '图鉴颜色', name: this.detail?.forms[this.currentForm].color })
                  }

                  Row({ space: 20 }) {
                    InfoCard({
                      title: '捕获率',
                      name: `${this.detail?.forms[this.currentForm].catch_rate.number}(${this.detail?.forms[this.currentForm].catch_rate.rate})`
                    })
                    InfoCard({
                      title: '性别比例',
                      name: this.detail?.forms[this.currentForm].gender_rate ?
                        `♂${this.detail?.forms[this.currentForm].gender_rate.male} ♀${this.detail?.forms[this.currentForm].gender_rate.female}` :
                        '无性别'
                    })
                  }
                }
                .width('100%')
                .align(Alignment.Center)
                .margin({ top: 10 })

                Column({ space: 10 }) {
                  Blank().height(30)

                  Text('特性')
                    .width('100%')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)

                  ForEach(this.detail.forms[this.currentForm].ability, (ability: AbilitySimple) => {
                    InfoCard({
                      title: `${ability.name}${ability.is_hidden ? '(隐藏)' : ''}`,
                      name: this.abilities.filter(a => a.name === ability.name)[0].text,
                      cardWidth: '100%',
                      cardHeight: 'auto'
                    }).onClick(() => {
                      PokeUtil.getAbilityList().then(res => {
                        this.pageStack.pushPathByName('AbilityDetails', res.filter(s => s.name === ability.name)[0])
                      })
                    })
                  })
                }
                .width('100%')
                .align(Alignment.Center)

                Column() {
                  Blank().height(30)

                  Text('简介')
                    .width('100%')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .margin({ bottom: 10 })

                  LongText({ text: this.detail.profile })
                }

                Column({ space: 10 }) {
                  Blank().height(30)

                  Text('种族值')
                    .width('100%')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)

                  if (this.statTab.length > 1) {
                    SlidingTabsV2({
                      tabs: this.statTab,
                      barMode: "fixed",
                      tabController: new SlidingTabController(),
                      tabStyle: {
                        fontColor: '#717179',
                        fontColorSelect: Color.Black,
                        fontWeightSelect: FontWeight.Bold,
                        padding: {
                          left: 12,
                          right: 12,
                          top: 6,
                          bottom: 6
                        }
                      },
                      indicatorStyle: {
                        wrapTab: true,
                        padding: 10
                      },
                      onTabIndicatorBuilder: () => {
                        this.TabIndicator()
                      },
                      onChange: (index) => {
                        Log.info('change: ', index.toString())
                        this.currentStat = index
                      }
                    })
                      .backgroundColor($r('app.color.custom_gray'))
                      .borderRadius(10)
                  }

                  StatChart({ stat: this.detail.stats[this.currentStat].data })
                }

                Column({ space: 10 }) {
                  Text('进化')
                    .width('100%')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)

                  ForEach(this.detail.evolution_chains, (c: EvolutionChain[], i) => {
                    if (i !== 0) {
                      Divider()
                        .width(180)
                        .margin({
                          top: 24,
                          bottom: 16
                        })
                    }
                    EvolveChain({ chains: c })
                  })
                }

                Column({ space: 10 }) {
                  Blank().height(30)

                  Text('图鉴介绍')
                    .width('100%')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)

                  MCollapse({
                    controller: new MCollapseType.CollapseController(),
                    list: this.configArr,
                    builder: (i) => {
                      this.Flavor(i)
                    }
                  })
                }

                Column({ space: 10 }) {
                  Blank().height(30)

                  Text('招式列表（通过提升等级）')
                    .width('100%')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)

                  if (this.learnedTab.length > 1) {
                    SlidingTabsV2({
                      tabs: this.learnedTab,
                      barMode: "fixed",
                      tabController: new SlidingTabController(),
                      tabStyle: {
                        fontColor: '#717179',
                        fontColorSelect: Color.Black,
                        fontWeightSelect: FontWeight.Bold,
                        padding: {
                          left: 12,
                          right: 12,
                          top: 6,
                          bottom: 6
                        }
                      },
                      indicatorStyle: {
                        wrapTab: true,
                        padding: 10
                      },
                      onTabIndicatorBuilder: () => {
                        this.TabIndicator()
                      },
                      onChange: (index) => {
                        Log.info('change: ', index.toString())
                        this.currentLearned = index
                      }
                    })
                      .backgroundColor($r('app.color.custom_gray'))
                      .borderRadius(10)
                  }

                  CommonTable({
                    options: [
                      {
                        title: '等级',
                        key: 'level_learned_at',
                        width: 80
                      },
                      {
                        title: '招式',
                        key: 'name',
                        width: 150,
                        onClick: (name: string) => {
                          PokeUtil.getSkillList().then(res => {
                            this.pageStack.pushPathByName('SkillDetails', res.filter(s => s.name === name)[0])
                          })
                        }
                      },
                      {
                        title: '属性',
                        key: 'type',
                        width: 80,
                        builder: wrapBuilder(TableType)
                      },
                      {
                        title: '分类',
                        key: 'category',
                        width: 80,
                        builder: wrapBuilder(TableCategory)
                      },
                      {
                        title: '威力',
                        key: 'power',
                        width: 80
                      },
                      {
                        title: '命中',
                        key: 'accuracy',
                        width: 80
                      },
                      {
                        title: 'PP',
                        key: 'pp',
                        width: 80
                      },
                    ],
                    list: this.detail.moves.learned[this.currentLearned].data
                  })
                }

                Column({ space: 10 }) {
                  Blank().height(30)

                  Text('招式列表（通过招式学习器）')
                    .width('100%')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)

                  if (this.machineTab.length > 1) {
                    SlidingTabsV2({
                      tabs: this.machineTab,
                      barMode: "fixed",
                      tabController: new SlidingTabController(),
                      tabStyle: {
                        fontColor: '#717179',
                        fontColorSelect: Color.Black,
                        fontWeightSelect: FontWeight.Bold,
                        padding: {
                          left: 12,
                          right: 12,
                          top: 6,
                          bottom: 6
                        }
                      },
                      indicatorStyle: {
                        wrapTab: true,
                        padding: 10
                      },
                      onTabIndicatorBuilder: () => {
                        this.TabIndicator()
                      },
                      onChange: (index) => {
                        Log.info('change: ', index.toString())
                        this.currentMachine = index
                      }
                    })
                      .backgroundColor($r('app.color.custom_gray'))
                      .borderRadius(10)
                  }

                  CommonTable({
                    options: [
                      {
                        title: '招式学习器',
                        key: 'machine_used',
                        width: 80,
                        formatter: (v) => {
                          return v.replaceAll('招式学习器', '')
                        }
                      },
                      {
                        title: '招式',
                        key: 'name',
                        width: 150,
                        onClick: (name: string) => {
                          PokeUtil.getSkillList().then(res => {
                            this.pageStack.pushPathByName('SkillDetails', res.filter(s => s.name === name)[0])
                          })
                        }
                      },
                      {
                        title: '属性',
                        key: 'type',
                        width: 80,
                        builder: wrapBuilder(TableType)
                      },
                      {
                        title: '分类',
                        key: 'category',
                        width: 80,
                        builder: wrapBuilder(TableCategory)
                      },
                      {
                        title: '威力',
                        key: 'power',
                        width: 80
                      },
                      {
                        title: '命中',
                        key: 'accuracy',
                        width: 80
                      },
                      {
                        title: 'PP',
                        key: 'pp',
                        width: 80
                      },
                    ],
                    list: this.detail.moves.machine[this.currentLearned].data
                  })
                }
              }
              .width('100%')
              .padding({ left: 15, right: 15 })
            }
            .width('100%')
            .padding({ bottom: this.windowInfo.bottomRectHeight })
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
  TabIndicator() {
    Stack().width('100%').height('100%')
      .backgroundColor(Color.White).borderRadius(8)
  }

  @Builder
  Flavor(index: number) {
    Column() {
      ForEach(this.detail.flavor_texts[index].versions, (v: Version) => {
        Row() {
          Row() {
            Text(v.name)
              .textAlign(TextAlign.Center)
              .constraintSize({
                minWidth: 72,
                maxWidth: 124
              })
              .padding({
                left: 12,
                right: 12,
                top: 4,
                bottom: 4
              })
              .fontSize(14)
              .fontColor('#394150')
              .backgroundColor('#e5e7eb')
              .borderRadius(50)
          }
          .width(124)

          Text(v.text)
            .layoutWeight(1)
        }
        .constraintSize({
          minHeight: 24
        })
        .margin({ bottom: 8 })
      })
    }
  }
}

@Builder
function TableType(value: string) {
  Text(value)
    .height(25)
    .width('100%')
    .textAlign(TextAlign.Center)
    .fontSize(14)
    .fontColor(Color.White)
    .backgroundColor(TypeColor[value])
    .borderRadius(8)
    .padding({ left: 10, right: 10 })
    .margin({ right: 10 })
}

@Builder
function TableCategory(value: string) {
  Text(value)
    .height(25)
    .width('100%')
    .textAlign(TextAlign.Center)
    .fontSize(14)
    .fontColor(Color.White)
    .backgroundColor(CategoryColor[value])
    .borderRadius(8)
    .padding({ left: 10, right: 10 })
    .margin({ right: 10 })
}