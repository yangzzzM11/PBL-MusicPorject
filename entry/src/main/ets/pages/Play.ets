import { SongItem, PlayState } from '../models/Index';
@Entry
@Component
struct Play {
  @State panelHeight: string = '0%';
  playState: PlayState = new PlayState();

  @State rotateAngle: number = 0;
  animatorResult = this.getUIContext().createAnimator({
    duration: 1000 * 15,
    easing: 'linear',
    delay: 0,
    fill: 'none',
    direction: 'normal',
    iterations: -1,
    begin: 0,
    end: 360
  })
  aboutToAppear() {
    this.animatorResult.onFrame = val => {
      this.rotateAngle = val;
    };
  }
  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      // 播放区域
      Stack() {
        // 背景图区域
        Image(this.playState.img)
          .width('100%')
          .height('100%')
          .blur(1000)
        // 内容区域
        Column() {
          Column() {
            // 封面图区域
            Stack({ alignContent: Alignment.Top }) {
              Row() {
                Row() {
                  // 唱片
                  Image(this.playState.img)
                    .width('70%')
                    .borderRadius(400)
                }
                .backgroundImage($r('app.media.ic_cd'))
                .backgroundImageSize(ImageSize.Cover)
                .justifyContent(FlexAlign.Center)
                .width('100%')
                .borderRadius(400)
                .clip(true)
                .aspectRatio(1)
                .rotate({ angle: this.rotateAngle })
              }
              .margin({ top: 50 })
              .width('90%')
              .aspectRatio(1)
              .justifyContent(FlexAlign.Center)
              .padding(24)
              // 唱针
              Image($r('app.media.ic_stylus'))
                .width(200)
                .aspectRatio(1)
                .rotate({
                  angle: this.playState.isPlay ? -45 : -55,
                  centerX: 100,
                  centerY: 30
                })
                .animation({ duration: 500 })
            }
            // 歌曲信息区域
            Stack() {
              Column({ space: 8 }) {
                Text(this.playState.title)
                  .fontSize(28)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                Text(this.playState.artist)
                  .fontSize(18)
                  .fontColor(Color.White)
              }
              .layoutWeight(1)
              .justifyContent(FlexAlign.Center)
            }
            .layoutWeight(1)
            Row() {
              Badge({ value: '99+', style: { badgeSize: 12, badgeColor: '#45CCCCCC', borderWidth: 0 } }) {
                Image($r('app.media.ic_like'))
                  .fillColor(Color.White)
                  .width(24)
                  .margin({ right: 2 })
              }
              Badge({ value: '10W', style: { badgeSize: 12, badgeColor: '#45cccccc', borderWidth: 0 } }) {
                Image($r('app.media.ic_comment_o'))
                  .fillColor(Color.White)
                  .width(18)
                  .margin({ right: 4 })
              }
              Badge({ value: 'hot', style: { badgeSize: 12, badgeColor: '#a8ff3131', borderWidth: 0 } }) {
                Image($r('app.media.ic_bells_o'))
                  .fillColor(Color.White)
                  .width(24)
              }
              Badge({ value: 'vip', style: { badgeSize: 12, badgeColor: '#b7efd371', borderWidth: 0 } }) {
                Image($r('app.media.ic_download_o'))
                  .fillColor(Color.White)
                  .width(24)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)
            // 播放控制区域
            Column() {
              // 播放位置区域
              Row({ space: 4 }) {
                // 播放时间
                Text('00:00')
                  .fontSize(12)
                  .fontColor(Color.White)
                // 进度条
                Slider({ value: this.playState.time, min: 0, max: this.playState.duration })
                  .layoutWeight(1)
                  .blockColor(Color.White)
                  .selectedColor(Color.White)
                  .trackColor('#ccc5c5c5')
                  .trackThickness(2)
                // 歌曲时长
                Text('00:00')
                  .fontSize(12)
                  .fontColor(Color.White)
              }
              .width('100%')
              .padding(24)
              // 播放控制按钮区域
              Row() {
                // “播放模式”按钮
                if (this.playState.playMode == 'auto') {
                  // 顺序播放
                  Image($r('app.media.ic_auto'))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      this.playState.playMode = 'repeat';
                    })
                } else if (this.playState.playMode == 'repeat') {
                  // 单曲循环
                  Image($r('app.media.ic_repeat'))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      this.playState.playMode = 'random';
                    })
                } else if (this.playState.playMode == 'random') {
                  // 随机播放
                  Image($r('app.media.ic_random'))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      this.playState.playMode = 'auto';
                    })
                }
                // “上一首”按钮
                Image($r('app.media.ic_prev'))
                  .fillColor(Color.White)
                  .width(30)
                // “播放/暂停”按钮
                Image(this.playState.isPlay ? $r('app.media.ic_paused') : $r('app.media.ic_play'))
                  .fillColor(Color.White)
                  .width(50)
                // “下一首”按钮
                Image($r('app.media.ic_next'))
                  .fillColor(Color.White)
                  .width(30)
                // “播放列表”按钮
                Image($r('app.media.ic_song_list'))
                  .fillColor(Color.White)
                  .width(30)
                  .onClick(() => {
                    this.panelHeight = '100%';
                  })
              }
              .width('100%')
              .padding({ bottom: 24 })
              .justifyContent(FlexAlign.SpaceAround)
            }
            .width('100%')
          }
          .layoutWeight(1)
          .width('100%')
        }
        .padding({ bottom: 20 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Transparent)
      Column() {
        Column()
          .width('100%')
          .layoutWeight(1)
          .onClick(() => {
            this.panelHeight = '0%';
          })
        // 播放列表区域
        Column() {
          // 播放列表-标题区域
          Row() {
            Row() {
              Image($r('app.media.ic_play'))
                .width(20)
                .fillColor('#ff5186')
            }
            .width(50)
            .aspectRatio(1)
            .justifyContent(FlexAlign.Center)
            Row({ space: 8 }) {
              Text(`播放列表 (${this.playState.playList.length})`)
                .fontColor(Color.White)
                .fontSize(14)
            }
            .layoutWeight(1)
            Image($r('app.media.ic_close'))
              .fillColor('#ffa49a9a')
              .width(24)
              .height(24)
              .margin({ right: 16 })
              .onClick(() => {
                this.panelHeight = '0%';
              })
          }
          .width('100%')
          .backgroundColor('#ff353333')
          .padding(8)
          .border({ width: { bottom: 1 }, color: '#12ec5c87' })
          .borderRadius({ topLeft: 4, topRight: 4 })
          // 播放列表-内容区域
          List() {
            ForEach(this.playState.playList, (item: SongItem, index: number) => {
              ListItem() {
                Row() {
                  Row() {
                    Text((index + 1).toString())
                      .fontColor('#ffa49a9a')
                  }
                  .width(50)
                  .aspectRatio(1)
                  .justifyContent(FlexAlign.Center)
                  // 播放列表中的歌曲
                  Row({ space: 10 }) {
                    Column() {
                      Text(item.title)
                        .fontSize(14)
                        .fontColor(this.playState.playIndex == index ? '#f04c7e' : '#ffa49a9a')
                      Text(item.artist)
                        .fontSize(12)
                        .fontColor(this.playState.playIndex == index ? '#f04c7e' : Color.Gray)
                    }
                    .layoutWeight(1)
                    .alignItems(HorizontalAlign.Start)
                    .justifyContent(FlexAlign.Center)
                  }
                  .layoutWeight(1)
                  Image($r('app.media.ic_more'))
                    .width(24)
                    .height(24)
                    .margin({ right: 16 })
                    .fillColor(Color.Gray)
                }
                .alignItems(VerticalAlign.Center)
              }
              .border({ width: { bottom: 1 }, color: '#12ec5c87' })
            })
          }
          .layoutWeight(1)
          .width('100%')
          .height('100%')
          .backgroundColor('#ff353333')
        }
        .height(400)
      }
      .height(this.panelHeight)
      .animation({ duration: 300 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#333')
  }
}
