import { WindowInfo } from '../util/WindowUtil'
import { AppStorageV2 } from '@kit.ArkUI'
import { SlidingTabController, SlidingTabsV2 } from '@xqw/sliding-tabs'
import PokemonList from './view/PokemonList'
import SkillList from './view/SkillList'
import AbilityList from './view/AbilityList'
import DefenseCalc from './view/DefenseCalc'

@Entry
@ComponentV2
struct Index {
  @Provider() pageStack: NavPathStack = new NavPathStack()
  @Local windowInfo: WindowInfo = AppStorageV2.connect(WindowInfo, () => new WindowInfo(0, 0, 0, 0))!
  @Local tabs: string[] = ["图鉴", "技能", "特性", "克制"]
  tabController: SlidingTabController = new SlidingTabController()

  build() {
    Navigation(this.pageStack) {
      Column() {
        Swiper(this.tabController.swiperController) {
          PokemonList().width('100%').height('100%')
          SkillList().width('100%').height('100%')
          AbilityList().width('100%').height('100%')
          DefenseCalc().width('100%').height('100%')
        }
        .indicator(false)
        .loop(false)
        .layoutWeight(1)
        .padding({
          left: 10,
          right: 10
        })
        .onGestureSwipe((index, extraInfo) => {
          this.tabController.swiperOnGestureSwipe(index, extraInfo)
        })
        .onAreaChange((oldValue, newValue) => {
          this.tabController.swiperOnAreaChange(oldValue, newValue)
        })
        .onAnimationStart((index, targetIndex, extraInfo) => {
          this.tabController.swiperOnAnimationStart(index, targetIndex, extraInfo)
        })

        Divider().height(2)

        SlidingTabsV2({
          tabs: this.tabs,
          barMode: "fixed",
          tabController: this.tabController,
          showIndicator: false,
          tabStyle: {
            fontColorSelect: Color.Red,
            fontSizeSelect: 20,
            fontWeightSelect: FontWeight.Medium,
          },
          indicatorStyle: {
            color: Color.Red,
            width: 50
          }
        })
      }
      .width('100%')
      .height('100%')
      .padding({
        top: this.windowInfo.topRectHeight,
        bottom: this.windowInfo.bottomRectHeight,
      })
    }
    .hideToolBar(true)
    .hideTitleBar(true)
  }
}