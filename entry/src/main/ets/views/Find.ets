import { getSongList } from '../apis';
import { SongItemType } from '../models/Index';

@Component
export default struct Find {
  @State songs: SongItemType[] = [];
  router = this.getUIContext().getRouter();
  async aboutToAppear() {
    this.songs = await getSongList() as SongItemType[];

  }
  build() {
    Column() {
      Text('猜你喜欢')
        .fontColor('#fff')
        .width('100%')
        .margin({ top: 10, bottom: 10 })
      List() {
        ForEach(this.songs, (item: SongItemType) => {
          ListItem() {
            Row({ space: 10 }) {
              // 封面图
              Image(item.img)
                .width(80)
                .aspectRatio(1)
                .borderRadius(8)
              Column({ space: 15 }) {
                // 歌曲名称
                Text(item.title)
                  .fontColor('#fff')
                  .fontWeight(700)
                  .width('100%')
                Row({ space: 8 }) {
                  Text('VIP')
                    .fontSize(14)
                    .fontColor('#bab128')
                    .border({ width: 1, color: '#bab128', radius: 12 })
                    .padding({ left: 5, right: 5, top: 3, bottom: 3 })
                  // 艺术家
                  Text(item.artist)
                    .fontColor('#808082')
                }
                .width('100%')

              }
              .layoutWeight(1)
              Image($r('app.media.ic_more'))
                .width(24)
                .fillColor('#fff')
            }
            .width('100%')
            .margin({ bottom: 10 })
            .onClick(() => { //新增
              this.router.pushUrl({ url: 'pages/Play' }); //这里用的pushUrl
            })

          }
        })
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding(8)
  }

}