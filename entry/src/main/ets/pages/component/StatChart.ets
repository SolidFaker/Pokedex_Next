import { McHorBarChart, Options } from '@mcui/mccharts'
import { Stat } from '../../common/model'
import { Log } from '../../util/Log'
import { JSON } from '@kit.ArkTS'

@ComponentV2
export default struct StatChart {
  @Require @Param stat: Stat
  @Local defOption: Options | undefined = undefined

  aboutToAppear(): void {
    this.updateStat()
  }

  @Monitor("stat")
  onStrChange(_monitor: IMonitor) {
    this.updateStat()
  }

  sum() {
    return Number.parseInt(this.stat.hp) +
    Number.parseInt(this.stat.attack) +
    Number.parseInt(this.stat.defense) +
    Number.parseInt(this.stat.sp_attack) +
    Number.parseInt(this.stat.sp_defense) +
    Number.parseInt(this.stat.speed)
  }

  updateStat() {
    Log.info('stat change: ', JSON.stringify(this.stat))
    this.defOption = new Options({
      title: {
        show: true,
        text: `种族值: ${this.sum()}`,
        right: 20,
        top: 30
      },
      xAxis: {
        data: ['速度', '特防', '特攻', '防御', '攻击', 'HP'],
        axisLabel: {
          color: Color.Black,
          fontSize: 40,
        }
      },
      yAxis: {
        max: 255,
        axisTick: {
          show: false
        },
        axisLabel: {
          color: Color.Black,
          fontSize: 0,
        }
      },
      series: [
        {
          data: [
            this.stat.speed,
            this.stat.sp_defense,
            this.stat.sp_attack,
            this.stat.defense,
            this.stat.attack,
            this.stat.hp,
          ],
          color: '#d87558',
          barStyle: {
            borderRadius: [0, 8, 8, 0]
          },
          label: {
            color: Color.Black,
            fontSize: 40,
          }
        }
      ],
      tooltip: {
        show: false
      }
    })
  }

  build() {
    Column() {
      McHorBarChart({
        options: this.defOption
      })
    }.height(330)
  }
}