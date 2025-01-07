export interface BaseInfo {
  index: string // 编号
  name: string // 中文名
  name_en: string // 英文名
  name_jp: string // 日文名
  generation: string // 世代
}

// 宝可梦
export interface Pokemon extends BaseInfo {
  types: string[] // 属性
  meta: Meta // 图片偏移
  first: string // 第一特性
  second: string // 第二特性
  hidden: string // 隐藏特性
}

export interface Meta {
  icon_position: string // 图片偏移
}

export interface PokemonDetail extends Pokemon {
  profile: string // 描述
  forms: Detail[] // 基本信息
  stats: BaseStat[] // 种族值
  flavor_texts: FlavorText[] // 图鉴介绍
  evolution_chains: Array<EvolutionChain[]> // 进化链
  names: Names // 多语言名字
  moves: SkillPool // 技能池
  home_images: HomeImage[] // 图片
}

export interface HomeImage {
  name: string // 名称
  image: string // 普通图片
  shiny: string // 闪光图片
}

export interface SkillPool {
  learned: Learned[] // 升级学习
  machine: Learned[] // 招式机学习
}

export interface Learned {
  form: string
  data: SkillLearned[]
}

export interface SkillLearned extends Skill {
  level_learned_at: string // 学习等级
  machine_used: string // 学习机器
  method: string // 学习方法
  flavor_text: string // 描述
}

export interface Names {
  zh_hans: string // 简体中文
  zh_hant: string // 繁体中文
  en: string // 英语
  fr: string // 法语
  de: string // 德语
  it: string // 意大利语
  es: string // 西班牙语
  ja: string // 日语
  ko: string // 韩语
}

export interface EvolutionChain {
  name: string // 名称
  stage: string // 阶级
  text: string // 进化等级
  image: string // 图片
  back_text: string
  from: string // 进化源
  form_name: null
}

export interface FlavorText {
  name: string // 世代
  versions: Version[]
}

export interface Version {
  name: string // 名称
  group: string // 分组
  text: string //介绍
}

export interface BaseStat {
  form: string // 形态（一般，mega）
  data: Stat // 种族值
}

export interface Stat {
  hp: string // HP
  attack: string // 攻击
  defense: string // 防御
  sp_attack: string // 特攻
  sp_defense: string // 特防
  speed: string // 速度
}

export interface Detail {
  name: string // 中文名
  index: string // 编号
  is_mega: boolean // 是否mega
  is_gmax: boolean // 是否极巨化
  image: string // 图片
  types: string[] // 属性
  genus: string // 本属
  ability: AbilitySimple[] // 特性
  experience: Experience // 100级经验值
  height: string // 高度
  weight: string //重量
  gender_rate: GenderRate // 性别比例
  shape: string // 体型
  color: string // 图鉴颜色
  catch_rate: CatchRate // 捕获率
  egg_groups: string[] // 蛋群
}

export interface Experience {
  number: string // 100级经验值
  speed: string // 速度
}

export interface GenderRate {
  male: string // 雄性
  female: string // 雌性
}

export interface CatchRate {
  number: string
  rate: string
}

// 特性
export interface Ability extends BaseInfo {
  text: string // 描述
  common_count: number
  hidden_count: number
}

export interface AbilitySimple {
  name: string // 名称
  is_hidden: boolean // 是否隐藏特性
}

// 特性详情
export interface AbilityDetail extends Ability {
  effect: string // 效果
  info: string[] // 其他信息
  pokemon: Pokemon[] // 具有该特性的宝可梦
}

// 技能
export interface Skill extends BaseInfo {
  type: string // 属性
  category: string // 类型
  power: string // 威力
  accuracy: string // 命中率
  pp: string // pp值
  text: string // 描述
}

// 技能详情
export interface SkillDetail extends Skill {
  effect: string // 效果
  info: string[] // 其他信息
  range: string // 技能范围
  pokemon: SkillPokemon // 可以学会该招式的宝可梦
}

// 可以学会该招式的宝可梦
export interface SkillPokemon {
  level: Pokemon[] // 升级
  machine: Pokemon[]
  egg: Pokemon[]
  tutor: Pokemon[]
}