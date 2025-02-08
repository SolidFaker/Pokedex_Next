export const Types: string[] = [
  '一般',
  '火',
  '水',
  '电',
  '草',
  '冰',
  '格斗',
  '毒',
  '地面',
  '飞行',
  '超能力',
  '虫',
  '岩石',
  '幽灵',
  '龙',
  '恶',
  '钢',
  '妖精'
]

export const TypeColor: Record<string, string> = {
  '一般': '#9fa19f',
  '火': '#d33d35',
  '水': '#437ee7',
  '电': '#f1c242',
  '草': '#5b9f3d',
  '冰': '#70d5fb',
  '格斗': '#ef8733',
  '毒': '#8746c4',
  '地面': '#88542b',
  '飞行': '#8db7ea',
  '超能力': '#dc5078',
  '虫': '#94a038',
  '岩石': '#aea985',
  '幽灵': '#6a436d',
  '龙': '#5360d9',
  '恶': '#4e423f',
  '钢': '#6f9fb5',
  '妖精': '#df77e9',
}

export const TypeOffset: Record<string, number> = {
  '一般': 0,
  '火': 450,
  '水': 500,
  '电': 600,
  '草': 550,
  '冰': 700,
  '格斗': 50,
  '毒': 150,
  '地面': 200,
  '飞行': 100,
  '超能力': 650,
  '虫': 300,
  '岩石': 250,
  '幽灵': 350,
  '龙': 750,
  '恶': 800,
  '钢': 400,
  '妖精': 850,
  '物理': 900,
  '特殊': 950,
  '变化': 1000,
}

export const Generations: string[] =
  ['第一世代', '第二世代', '第三世代', '第四世代', '第五世代', '第六世代', '第七世代', '第八世代', '第九世代']

export const Categories: string[] = ['物理', '特殊', '变化', '极巨', '超极巨']

export const CategoryColor: Record<string, string> = {
  '物理': '#eb5428',
  '特殊': '#3665c5',
  '变化': '#999999',
  '极巨': '#9f409a',
  '超极巨': '#9f409a',
}

const Z = 0
const O = 1
const H = 0.5
const D = 2

export const TypesTable: number[][] = [
  [O, O, O, O, O, O, O, O, O, O, O, O, H, Z, O, O, H, O],
  [O, H, H, O, D, D, O, O, O, O, O, D, H, O, H, O, D, O],
  [O, D, H, O, H, O, O, O, D, O, O, O, D, O, H, O, O, O],
  [O, O, D, H, H, O, O, O, Z, D, O, O, O, O, H, O, O, O],
  [O, H, D, O, H, O, O, H, D, H, O, H, D, O, H, O, H, O],
  [O, H, H, O, D, H, O, O, D, D, O, O, O, O, D, O, H, O],
  [D, O, O, O, O, D, O, H, O, H, H, H, D, Z, O, D, D, H],
  [O, O, O, O, D, O, O, H, H, O, O, O, H, H, O, O, Z, D],
  [O, D, O, D, H, O, O, D, O, Z, O, H, D, O, O, O, D, O],
  [O, O, O, H, D, O, D, O, O, O, O, D, H, O, O, O, H, O],
  [O, O, O, O, O, O, D, D, O, O, H, O, O, O, O, Z, H, O],
  [O, H, O, O, D, O, H, H, O, H, D, O, O, H, O, D, H, H],
  [O, D, O, O, O, D, H, O, H, D, O, D, O, O, O, O, H, O],
  [Z, O, O, O, O, O, O, O, O, O, D, O, O, D, O, H, O, O],
  [O, O, O, O, O, O, O, O, O, O, O, O, O, O, D, O, H, Z],
  [O, O, O, O, O, O, H, O, O, O, D, O, O, D, O, H, O, H],
  [O, H, H, H, O, D, O, O, O, O, O, O, D, O, O, O, H, D],
  [O, H, O, O, O, O, D, H, O, O, O, O, O, O, D, D, H, O]
]