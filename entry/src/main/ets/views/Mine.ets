import { getSongList } from '../apis';
import { SongItemType, SongItem } from '../models/Index';
@Component
export default struct Mine {
  @State showList: [SongItemType[]] = [[]];
  columnList: number[] = [0, 1, 2, 3];
  async aboutToAppear() {
    const songList: SongItemType[] = await getSongList() as SongItemType[];
    this.columnList.forEach(item => {
      this.showList[item] = songList.map(item => new SongItem(item))
        .sort(() => Math.random() - 0.5);
    });
  }
  build() {
    Column() {
      // 背景
      Column() {
        GridRow({ gutter: 8 }) {
          ForEach(this.columnList, (item: number) => {
            GridCol({ span: 1 }) {
              SongCard({ songs: this.showList[item] })
            }
          })
        }
      }
      .scale({ x: 1.15, y: 1.15, centerX: '50%', centerY: '0' })
      .height('75%')
      .width('100%')
      .backgroundColor('#000')
      // 个人信息
      Column() {
        Column() {
          Image($r('app.media.logo'))
            .width('90%')
        }
        .backgroundColor(Color.Black)
        .width(80)
        .aspectRatio(1)
        .borderRadius(80)
        .offset({ y: -40 })
        Column({ space: 12 }) {
          Row({ space: 8 }) {
            Text('黑马云音乐')
              .fontColor(Color.White)
              .fontSize(20)
            Image($r('app.media.ic_vip'))
              .width(40)
          }
          .offset({ y: -15 })
          Row() {
            Image($r('app.media.ic_boy'))
              .width(14)
              .fillColor('#ff23496b')
              .margin({ right: 4 })
            Text('00后')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
            Text('天秤座')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
            Text('成都')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
            Text('歌龄·5年')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
          }
          Row() {
            Text('1 关注')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
            Text('10万 粉丝')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
            Text('666万 赞')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
          }
        }
      }
      .width('100%')
      .height('25%')
      .backgroundColor('#121215')
    }
    .width('100%')
  }
}

@Component
struct SongCard {
  @Prop songs: SongItemType[] = [];
  build() {

    List({ space: 12 }) {
      ForEach(this.songs, (item: SongItemType) => {
        ListItem() {
          Stack() {
            Image(item.img)
              .width('100%')
          }
          .width('100%')
          .aspectRatio(1)
          .borderRadius(8)
          .clip(true)
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}