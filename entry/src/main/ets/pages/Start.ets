@Entry
@Component
struct Start {
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
        .margin(10)
        .backgroundColor('#4d000000')
        .onClick(() => {
          this.router.replaceUrl({ url: 'pages/Index' });
        })
    }
  }
}