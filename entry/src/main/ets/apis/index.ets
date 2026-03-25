import { http } from '@kit.NetworkKit';
const baseUrl = 'http://192.168.1.1:3000';
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

export const getRecommendList = async () => {
  return await getData('/data/recommendList');
};
export const getSongList = async () => {
  return await getData('/data/songList');
};
export const getMomentList = async () => {
  return await getData('/data/momentList');
};


