import { Types, TypesTable } from '../../common/consts'
import HashMap from '@ohos.util.HashMap'
import { Log } from '../../util/Log'
import TypeTag from '../component/TypeTag'
import { LengthUnit } from '@kit.ArkUI'

@ComponentV2
export default struct DefenseCalc {
  @Local firstTypeIndex: number = 0
  @Local firstTypeName: string = '一般'
  @Local secondTypeIndex: number = Types.length
  @Local secondTypeName: string = '无'
  @Local effectMap: HashMap<number, string[]> = new HashMap()
  @Local effectKeys: number[] = []

  aboutToAppear(): void {
    this.doCalculate()
  }

  build() {
    Column() {
      Column({ space: 10 }) {
        Row() {
          Text('第一属性：')
          Select(this.buildSelectOptions())
            .selected(this.firstTypeIndex)
            .value(this.firstTypeName)
            .optionWidth(100)
            .width(100)
            .onSelect((i, v) => {
              this.firstTypeIndex = i
              this.firstTypeName = v
              if (this.firstTypeIndex === this.secondTypeIndex) {
                this.secondTypeIndex = Types.length
                this.secondTypeName = '无'
              }
              this.doCalculate()
            })
        }
        .width('50%')

        Row() {
          Text('第二属性：')
          Select(this.buildSelectOptions(true))
            .selected(this.secondTypeIndex)
            .value(this.secondTypeName)
            .optionWidth(100)
            .width(100)
            .onSelect((i, v) => {
              this.secondTypeIndex = i
              this.secondTypeName = v
              if (this.firstTypeIndex === this.secondTypeIndex) {
                this.secondTypeIndex = Types.length
                this.secondTypeName = '无'
              }
              this.doCalculate()
            })
        }
        .width('50%')
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')

      ForEach(this.effectKeys, (k: number) => {
        Column() {
          Text(`受到 ${k}× 伤害`)
            .width('100%')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)

          Flex({
            wrap: FlexWrap.Wrap,
            space: {
              main: { value: 10, unit: LengthUnit.VP },
              cross: { value: 10, unit: LengthUnit.VP }
            }
          }) {
            ForEach(this.effectMap.get(k), (type: string) => {
              TypeTag({
                type: type,
                fontSize: 16,
                tagWidth: 100,
                tagHeight: 30
              })
            })
          }
          .width('100%')
          .margin({ top: 10, bottom: 10 })
        }
        .width('100%')
        .margin({ top: 20 })
      })
    }
    .height('100%')
    .width('100%')
  }

  doCalculate() {
    this.effectMap = new HashMap()
    Log.info('开始计算倍率')
    Types.forEach((v, i) => {
      let defTypes = [this.firstTypeIndex]
      if (this.secondTypeIndex < Types.length) {
        defTypes.push(this.secondTypeIndex)
      }
      const effect = this.calculateEffectiveness(i, defTypes)
      this.addMap(effect, v)
    })
    this.effectKeys = Array.from(this.effectMap.keys()).sort((k1, k2) => k2 - k1)
  }

  calculateEffectiveness(atkType: number, defTypes: number[]): number {
    const defense = Array.isArray(defTypes) ? defTypes : [defTypes];

    return defense.reduce((total, defTypes) => {
      // 默认1倍伤害（当未定义克制关系时）
      const multiplier = TypesTable[atkType][defTypes];
      return total * multiplier;
    }, 1);
  }

  addMap(effect: number, type: string) {
    let arr: string[] = []
    if (this.effectMap.hasKey(effect)) {
      arr = this.effectMap.get(effect)
    }
    arr.push(type)
    this.effectMap.set(effect, arr)
  }

  buildSelectOptions(withEmpty?: boolean): SelectOption[] {
    let options: SelectOption[] = Types.map(v => ({ value: v } as SelectOption))
    if (withEmpty) {
      options.push({ value: '无' })
    }
    return options
  }
}