@Component
export default struct Mine {
  build() {
    Column() {
      Text('我的内容')
        .fontColor('#fff')
    }
    .width('100%')
    .height('100%')
  }
}