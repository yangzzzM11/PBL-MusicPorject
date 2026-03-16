import { http } from '@kit.NetworkKit';
const baseUrl = 'http://192.168.3.52:3000';
export const getData = async (path: string) => {
  const req = http.createHttp();
  try {
    const res = await req.request(baseUrl + path, {
      expectDataType: http.HttpDataType.OBJECT
    });
    req.destroy()
    return res.result;
  } catch(error) {
    req.destroy()
    AlertDialog.show({ message: '无法请求网络数据'});
    throw new Error(`无法请求网络数据：${error.code} ${error.message}`);
  }
}
export const getSwiper = async () => {
  return await getData('/data/swiper');
}
export const getDailyRecommend = async () => {
  return await getData('/data/dailyRecommend');
};
export interface DailyRecommendType {
  img: string;	  // 封面图
  title: string;	// 标题
  type: string;	  // 类型
  top: string;	  // 类型背景色
  bottom: string;	// 标题背景色
}
export const getRecommendList = async () => {
  return await getData('/data/recommendList');
};
export interface RecommendListType {
  img: string;		// 封面图
  title: string;	// 标题
  count: string;	// 播放量
}

