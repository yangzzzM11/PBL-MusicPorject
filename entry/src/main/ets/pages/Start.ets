import { SAFE_TOP, SAFE_BOTTOM } from '../constants';
@Entry
@Component
struct Start {
  @StorageProp(SAFE_TOP) safeTop: number = 0;
  router = this.getUIContext().getRouter();
  // 定时器 id
  timerId: number = 0;
  aboutToAppear(): void {
    // 5秒后自动跳转到首页
    this.timerId = setTimeout(() => {
      this.router.replaceUrl({ url: 'pages/Index' });
    }, 5000);
  }
  aboutToDisappear() {
    // 清除定时器
    clearTimeout(this.timerId);
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image($r('app.media.ad'))
      Button('跳过')
        .margin({ top: this.safeTop + 10, right: 10 })
        .backgroundColor('#4d000000')
        .onClick(() => {
          this.router.replaceUrl({ url: 'pages/Index' });
        })
    }
  }
}