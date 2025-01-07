import { Ability, AbilityDetail, Pokemon, PokemonDetail, Skill, SkillDetail } from '../common/model';
import { ResUtil } from './ResUtil';
import { HashMap } from '@kit.ArkTS';

export class PokeUtil {
  private static pokemon: Pokemon[]
  private static pokemonMap: HashMap<string, PokemonDetail> = new HashMap()
  private static skills: Skill[]
  private static skillMap: HashMap<string, SkillDetail> = new HashMap()
  private static abilities: Ability[]
  private static abilityMap: HashMap<string, AbilityDetail> = new HashMap()

  public static getPokemonList(): Promise<Pokemon[]> {
    return new Promise(async (resolve, reject) => {
      if (!PokeUtil.pokemon) {
        await ResUtil.getRawfileContentStr('pokemon_full_list.json').then(res => {
          PokeUtil.pokemon = JSON.parse(res)
          resolve(PokeUtil.pokemon)
        }).catch((err: Error) => {
          reject(err)
        })
      }
      resolve(PokeUtil.pokemon)
    })
  }

  public static getPokemonDetail(index: string, name: string): Promise<PokemonDetail> {
    const key = `${index}-${name}`
    return new Promise(async (resolve, reject) => {
      if (PokeUtil.pokemonMap.hasKey(key)) {
        resolve(PokeUtil.pokemonMap.get(key))
      } else {
        await ResUtil.getRawfileContentStr(`pokemon/${key}.json`).then(res => {
          const info: PokemonDetail = JSON.parse(res)
          PokeUtil.pokemonMap.set(key, info)
          resolve(info)
        }).catch((err: Error) => {
          reject(err)
        })
      }
    })
  }

  public static getSkillList(): Promise<Skill[]> {
    return new Promise(async (resolve, reject) => {
      if (!PokeUtil.skills) {
        await ResUtil.getRawfileContentStr('skill_list.json').then(res => {
          PokeUtil.skills = JSON.parse(res)
          resolve(PokeUtil.skills)
        }).catch((err: Error) => {
          reject(err)
        })
      }
      resolve(PokeUtil.skills)
    })
  }

  public static getSkillDetail(index: string, name: string): Promise<SkillDetail> {
    const key = `${index}-${name}`
    return new Promise(async (resolve, reject) => {
      if (PokeUtil.skillMap.hasKey(key)) {
        resolve(PokeUtil.skillMap.get(key))
      } else {
        await ResUtil.getRawfileContentStr(`skill/${key}.json`).then(res => {
          const info: SkillDetail = JSON.parse(res)
          PokeUtil.skillMap.set(key, info)
          resolve(info)
        }).catch((err: Error) => {
          reject(err)
        })
      }
    })
  }

  public static getAbilityList(): Promise<Ability[]> {
    return new Promise(async (resolve, reject) => {
      if (!PokeUtil.abilities) {
        await ResUtil.getRawfileContentStr('ability_list.json').then(res => {
          PokeUtil.abilities = JSON.parse(res)
          resolve(PokeUtil.abilities)
        }).catch((err: Error) => {
          reject(err)
        })
      }
      resolve(PokeUtil.abilities)
    })
  }

  public static getAbilityDetail(index: string, name: string): Promise<AbilityDetail> {
    const key = `${index}-${name}`
    return new Promise(async (resolve, reject) => {
      if (PokeUtil.pokemonMap.hasKey(key)) {
        resolve(PokeUtil.abilityMap.get(key))
      } else {
        await ResUtil.getRawfileContentStr(`ability/${key}.json`).then(res => {
          const info: AbilityDetail = JSON.parse(res)
          PokeUtil.abilityMap.set(key, info)
          resolve(info)
        }).catch((err: Error) => {
          reject(err)
        })
      }
    })
  }
}