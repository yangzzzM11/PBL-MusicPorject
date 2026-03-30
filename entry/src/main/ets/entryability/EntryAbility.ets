import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { SAFE_TOP, SAFE_BOTTOM } from '../constants';
import AVPlayerManager from '../utils/AVPlayerManager';
const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {

    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Start', (err) => {
      const mainWindow = windowStage.getMainWindowSync();
      // 设置沉浸式效果
      mainWindow.setWindowLayoutFullScreen(true);
      // 修改状态栏内容的颜色
      mainWindow.setWindowSystemBarProperties({
        statusBarContentColor: '#ffffff'
      });
      // 获取顶部避让区高度（px单位），
      const avoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      const safeTop = mainWindow.getUIContext().px2vp(avoidArea.topRect.height);
      // 存储顶部避让区高度
      AppStorage.setOrCreate(SAFE_TOP, safeTop);
      // 获取底部避让区高度（px单位）
      const navigationArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      const safeBottom = mainWindow.getUIContext().px2vp(navigationArea.bottomRect.height);
      // 存储底部避让区高度
      AppStorage.setOrCreate(SAFE_BOTTOM, safeBottom);
      // 初始化播放器
      AVPlayerManager.init();//新增


      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}