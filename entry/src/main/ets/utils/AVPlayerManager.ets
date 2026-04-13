import { media } from '@kit.MediaKit';
import { SONG_KEY } from '../constants';
import { PlayState, SongItemType } from '../models/Index';
export default class AVPlayerManager {
  static player: media.AVPlayer;//静态属性
  static currentSong: PlayState = new PlayState();
  // 上一首
  static prevPlay() {
    // 判断播放模式是否为随机播放
    if (AVPlayerManager.currentSong.playMode == 'random') {
      AVPlayerManager.currentSong.playIndex = AVPlayerManager.getRandomIndex();
    } else {
      AVPlayerManager.currentSong.playIndex--;
      // 如果当前是播放列表中的第一首歌曲，则切换到最后一首歌曲
      if (AVPlayerManager.currentSong.playIndex < 0) {
        AVPlayerManager.currentSong.playIndex = AVPlayerManager.currentSong.playList.length - 1;
      }
    }
    AVPlayerManager.singPlay(AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex]);
  }
  // 下一首
  static nextPlay(isRepeat?: boolean) { //isRepeat参数表述是否重复播放，“？”表述参数是可选参数。
    if (!isRepeat) {
      if (AVPlayerManager.currentSong.playMode == 'random') {
        AVPlayerManager.currentSong.playIndex = AVPlayerManager.getRandomIndex();
      } else {
        AVPlayerManager.currentSong.playIndex++;
        // 如果当前是播放列表中的最后一首歌曲，则切换到第一首歌曲
        if (AVPlayerManager.currentSong.playIndex > AVPlayerManager.currentSong.playList.length - 1) {
          AVPlayerManager.currentSong.playIndex = 0;
        }
      }
    }
    AVPlayerManager.singPlay(AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex]);
  }
  // 获取随机播放的索引
  static getRandomIndex() {
    let randomIndex = 0;
    if (AVPlayerManager.currentSong.playList.length > 1) {
      do {
        randomIndex = Math.floor(Math.random() * AVPlayerManager.currentSong.playList.length);
      } while(AVPlayerManager.currentSong.playIndex == randomIndex)
    }
    return randomIndex;
  }

  // 播放指定歌曲并将该歌曲添加到播放列表
  static singPlay(song: SongItemType) {
    // 检查播放列表中是否已经有指定歌曲
    const isInPlayList = AVPlayerManager.currentSong.playList.some(item => item.id == song.id);
    if (isInPlayList) {
      // 判断指定歌曲是否为当前正在播放的歌曲
      if (song.url == AVPlayerManager.currentSong.url) {
        // 继续播放指定歌曲
        AVPlayerManager.player.play();
        AVPlayerManager.currentSong.isPlay = true;
      } else {
        // 将当前播放的歌曲切换为指定歌曲
        AVPlayerManager.currentSong.playIndex = AVPlayerManager.currentSong.playList.findIndex(item => item.id == song.id);
        AVPlayerManager.changePlay();
      }
    } else {
      // 将指定歌曲放在播放列表的开头，并将当前播放的歌曲切换为该歌曲
      AVPlayerManager.currentSong.playList.unshift(song);
      AVPlayerManager.currentSong.playIndex = 0;
      AVPlayerManager.changePlay();
    }
    // 更新AppStorage中的SONG_KEY数据
    AppStorage.setOrCreate(SONG_KEY, AVPlayerManager.currentSong);

  }
  // 切换当前播放的歌曲
  static async changePlay() {
    await AVPlayerManager.player.reset();
    const currentSong = AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex];
    AVPlayerManager.currentSong.duration = 0;
    AVPlayerManager.currentSong.time = 0;
    AVPlayerManager.currentSong.img = currentSong.img;
    AVPlayerManager.currentSong.title = currentSong.title;
    AVPlayerManager.currentSong.url = currentSong.url;
    AVPlayerManager.currentSong.artist = currentSong.artist;
    AVPlayerManager.player.url = AVPlayerManager.currentSong.url;
  }
  // 暂停
  static async pause() {
    AVPlayerManager.player.pause();
    AVPlayerManager.currentSong.isPlay =  false;
    AppStorage.setOrCreate(SONG_KEY, AVPlayerManager.currentSong);

  }

  static async init() {//静态方法
    if (!AVPlayerManager.player) {
      // 创建AVPlayer实例
      AVPlayerManager.player = await media.createAVPlayer();
    }
    // 监听stateChange事件，使AVPlayer实例进入播放状态
    AVPlayerManager.player.on('stateChange', state => {
      if (state == 'initialized') {
        AVPlayerManager.player.prepare();
      } else if (state == 'prepared') {
        AVPlayerManager.player.play();
        AVPlayerManager.currentSong.isPlay = true;
      }else if (state == 'completed') {
        // 歌曲播放结束，切换下一首歌曲
        AVPlayerManager.nextPlay(AVPlayerManager.currentSong.playMode == 'repeat');
      }
    });
    // 监听durationUpdate事件，获取歌曲时长
    AVPlayerManager.player.on('durationUpdate', (duration: number) => {
      AVPlayerManager.currentSong.duration = duration;

    });
    // 监听timeUpdate事件，获取播放时间，并更新AppStorage中的SONG_KEY数据
    AVPlayerManager.player.on('timeUpdate', (time: number) => {
      AVPlayerManager.currentSong.time = time;
      AppStorage.setOrCreate(SONG_KEY, AVPlayerManager.currentSong); //

    });

  }
}
