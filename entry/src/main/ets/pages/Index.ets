import Recommend from '../views/Recommend';
import Find from '../views/Find';
import Moment from '../views/Moment';
import Mine from '../views/Mine';
import { TabType } from '../models/Index';
import { SAFE_TOP, SAFE_BOTTOM } from '../constants';
@Entry
@Component
struct Index {
  tabData: TabType[] = [
    { icon: $r('app.media.ic_recommend'), text: '推荐', name: 'recommend' },
    { icon: $r('app.media.ic_find'), text: '发现', name: 'find' },
    { icon: $r('app.media.ic_moment'), text: '动态', name: 'moment' },
    { icon: $r('app.media.ic_mine'), text: '我的', name: 'mine' }
  ];
  @State isActive: string = 'recommend';
  @StorageProp(SAFE_TOP) safeTop: number = 0;
  @StorageProp(SAFE_BOTTOM) safeBottom: number = 0;
  @Builder
  tabBarBuilder(item: TabType) {
    Column({ space: 5 }) {
      Image(item.icon)
        .height(24)
        .fillColor(this.isActive == item.name ? '#e4608b' : '#6da8a5') // 图标高亮
      Text(item.text)
        .fontSize(14)
        .fontColor(this.isActive == item.name ? '#e4608b' : '#6da8a5') // 文字高亮
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      ForEach(this.tabData, (item: TabType) => {
        TabContent() {
          if (item.name == 'recommend') {
            Recommend()
          } else if (item.name == 'find') {
            Find()
          } else if (item.name == 'moment') {
            Moment()
          } else if (item.name == 'mine') {
            Mine()
          }

        }
        .backgroundColor('#131215')
        .tabBar(this.tabBarBuilder(item))
        .padding({ top: this.safeTop }) // 替换为自定义构建函数
      })
    }
    .backgroundColor('#3b3f42')
    .onChange((index: number) => {
      this.isActive = this.tabData[index].name;
    })
    .padding({ bottom: this.safeBottom })
  }
}
