import { EvolutionChain } from '../../common/model'
import { PokeUtil } from '../../util/PokeUtil'
import { ResUtil } from '../../util/ResUtil'

@ComponentV2
export default struct EvolveChain {
  @Consumer() pageStack: NavPathStack = new NavPathStack()
  @Require @Param chains: EvolutionChain[]

  build() {
    Column({ space: 8 }) {
      ForEach(this.chains, (e: EvolutionChain) => {
        Column({ space: 8 }) {
          if (e.text) {
            Text(e.text)
              .height(24)
              .padding(5)
              .fontSize(14)
              .backgroundColor('#f8e164')
              .borderRadius(8)
          }

          Image(ResUtil.getRawfileImageCache(`images/dream/${e.image}`))
            .width(100)
            .height(100)

          Text(e.name)
            .height(20)

          Text(e.stage)
            .height(24)
            .padding(5)
            .fontSize(14)
            .fontColor('#717179')
            .backgroundColor($r('app.color.custom_gray'))
            .borderRadius(50)
        }
        .onClick(() => {
          PokeUtil.getPokemonList().then(res => {
            this.pageStack.pushPathByName('PokemonDetails', res.filter(p => p.name === e.name)[0])
          })
        })
      })
    }
  }
}