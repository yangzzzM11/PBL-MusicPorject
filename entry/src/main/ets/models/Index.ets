
export interface TabType {
  icon: Resource;	// 页签的图标
  text: string;		// 页签的文本
  name: string;		// 页签的标识
}
export interface RecommendListType {
  img: string;		// 封面图
  title: string;	// 标题
  count: string;	// 播放量
}
export interface DailyRecommendType {
  img: string;	  // 封面图
  title: string;	// 标题
  type: string;	  // 类型
  top: string;	  // 类型背景色
  bottom: string;	// 标题背景色
}
export interface SongItemType {
  img: string;		// 封面图
  title: string;	// 歌曲名称
  artist: string;	// 艺术家
  url: string;   	// 歌曲URL
  id: string;     // 唯一标识
}
export interface MomentListType {
  author: string;		  // 作者
  avatar: string;		  // 头像
  content: string;		// 内容
  comment: number;		// 评论数
  like: number;			  // 喜欢数
  song: SongItemType;	// 歌曲
}
export class SongItem implements SongItemType {
  img: string = '';
  title: string = '';
  artist: string = '';
  url: string = '';
  id: string = '';
  constructor(model: SongItemType) {
    this.img = model.img;
    this.title = model.title;
    this.artist = model.artist;
    this.url = model.url;
    this.id = model.id;
  }
}
export class PlayState {
  img: string = '';					// 封面图
  title: string = '';				// 歌曲名称
  artist: string = '';			// 艺术家
  url: string = '';					// 歌曲URL
  playIndex: number = 0;		// 在播放列表中的索引
  time: number = 0; 				// 播放时间
  duration: number = 0; 		// 歌曲时长
  isPlay: boolean = false;	// 是否正在播放
  playMode: 'auto' | 'repeat' | 'random' = 'auto';	// 播放模式
  playList: SongItemType[] = [];	// 播放列表
}
