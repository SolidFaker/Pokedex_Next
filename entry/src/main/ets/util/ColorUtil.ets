export class ColorUtil {
  static hexColorToColorFilter(hexColor: string): ColorFilter {
    let r = 0
    let g = 0
    let b = 0
    let a = 1
    let hexArr: number[] = []
    let length = hexColor.length;
    if (length % 2 === 1) {
      hexColor = hexColor.slice(1)
    }
    for (let i = 0; i < hexColor.length / 2; i++) {
      let charCode1 = Number.parseInt(hexColor[i*2], 16);
      let charCode2 = Number.parseInt(hexColor[i * 2+1], 16);
      let hexNumber = charCode1 * 16 + charCode2
      hexArr.push((hexNumber / 255.0))
      console.debug(hexNumber.toString(16))
    }
    //大于3表示有透明度
    if (hexArr.length > 3) {
      a = hexArr[0]
      r = hexArr[1]
      g = hexArr[2]
      b = hexArr[3]
    } else {
      r = hexArr[0]
      g = hexArr[1]
      b = hexArr[2]
    }
    let colorFilter: ColorFilter = [r, 0, 0, 0, 0,
      0, g, 0, 0, 0,
      0, 0, b, 0, 0,
      0, 0, 0, a, 0,];
    return colorFilter;
  }
}