local UILWNewsCenterCtrl = BaseClass("UILWNewsCenterCtrl", UIBaseCtrl)
local parentClickPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/NewCenter/zxl_xinwen_yeqian_xuanzhong.png"
local parentBgPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/NewCenter/zxl_xinwen_yeqian_weixuanzhong.png"
local parentColor = Color.New(0.8, 0.7843137254901961, 0.7764705882352941, 0.6)
local childClickBgPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/NewCenter/zxl_xinwen_yeqian2_xuanzhong.png"
local childBgPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/NewCenter/zxl_xinwen_yeqian2_xuanzhong_di.png"
local Wold = {
  tabType = ChatNewsCenterTabType.World,
  textKey = "100171",
  clickBgPath = parentClickPath,
  bgPath = parentBgPath,
  clickColor = Color.white,
  color = parentColor
}
local Alliance = {
  tabType = ChatNewsCenterTabType.Alliance,
  textKey = "393081",
  clickBgPath = parentClickPath,
  bgPath = parentBgPath,
  clickColor = Color.white,
  color = parentColor
}
local StrategyGuide = {
  tabType = ChatNewsCenterTabType.StrategyGuide,
  textKey = "newscenter_3",
  clickBgPath = childClickBgPath,
  bgPath = childBgPath,
  clickColor = Color.black,
  color = parentColor,
  parent = ChatNewsCenterTabType.News
}
local Announcement = {
  tabType = ChatNewsCenterTabType.Announcement,
  textKey = "newscenter_2",
  clickBgPath = childClickBgPath,
  bgPath = childBgPath,
  clickColor = Color.black,
  color = parentColor,
  parent = ChatNewsCenterTabType.News
}
local News = {
  tabType = ChatNewsCenterTabType.News,
  textKey = "newscenter_1",
  clickBgPath = parentClickPath,
  bgPath = parentBgPath,
  clickColor = Color.white,
  color = parentColor
}
local ConfigDic = {
  [ChatNewsCenterTabType.World] = Wold,
  [ChatNewsCenterTabType.Alliance] = Alliance,
  [ChatNewsCenterTabType.StrategyGuide] = StrategyGuide,
  [ChatNewsCenterTabType.Announcement] = Announcement,
  [ChatNewsCenterTabType.News] = News
}

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWNewsCenter)
  EventManager:GetInstance():Broadcast(EventId.OnNewsReadStateChanged)
end

local function GetTabConfig()
  local tempConfig = {Wold, Alliance}
  local announcement = DataCenter.LWNewsCenterManager:GetNewsCenterInfoListByType(ChatNewsCenterTabType.Announcement)
  local strategyGuide = DataCenter.LWNewsCenterManager:GetNewsCenterInfoListByType(ChatNewsCenterTabType.StrategyGuide)
  local news = DeepCopy(News)
  if announcement and 0 < #announcement then
    if not news.childTab then
      news.childTab = {}
    end
    table.insert(news.childTab, Announcement)
  end
  if strategyGuide and 0 < #strategyGuide then
    if not news.childTab then
      news.childTab = {}
    end
    table.insert(news.childTab, StrategyGuide)
  end
  if news.childTab then
    table.insert(tempConfig, 1, news)
  end
  return tempConfig
end

function UILWNewsCenterCtrl:GetConfigByType(newsType)
  return ConfigDic[newsType]
end

function UILWNewsCenterCtrl:OnCustomKeyCodeEscape()
  if self.view then
    self.view:OnBackBtnClick()
  else
    self:CloseSelf()
  end
end

UILWNewsCenterCtrl.CloseSelf = CloseSelf
UILWNewsCenterCtrl.GetTabConfig = GetTabConfig
return UILWNewsCenterCtrl
