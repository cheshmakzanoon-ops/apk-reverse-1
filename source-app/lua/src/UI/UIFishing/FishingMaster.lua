local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local FishingMaster = BaseClass("FishingMaster", base)
local Localization = CS.GameEntry.Localization
local UICommonRankItem = require("UI.UICommonRank.UICommonRankItem")
local level_path = "Bottom/head/level"

function FishingMaster:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FishingMaster:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FishingMaster:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnIntro = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnIntro:SetOnClick(function()
    self:OnBtnIntroClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnBook = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnBook:SetOnClick(function()
    self:OnBtnBookClick()
  end)
  self.btnBag = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnBag:SetOnClick(function()
    self:OnBtnBagClick()
  end)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textRankTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textDay = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textHour = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textMin = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textSec = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.btnPond = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnPond:SetOnClick(function()
    self:OnBtnPondClick()
  end)
  self.textEmptyTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.level = self:AddComponent(UITextMeshProUGUIEx, level_path)
  self.level:SetLocalText("s6_fish_week_rank_title")
  self.textRankTime:SetLocalText("s6_fish_limit_8")
end

function FishingMaster:ComponentDestroy()
  self.viewSkin = nil
  self.btnIntro = nil
  self.textTitle = nil
  self.textDesc = nil
  self.textTime = nil
  self.btnBook = nil
  self.btnBag = nil
  self.btnRank = nil
  self.textRankTime = nil
  self.textDay = nil
  self.textHour = nil
  self.textMin = nil
  self.textSec = nil
  self.compContent = nil
  self.btnPond = nil
  self.textEmptyTip = nil
end

function FishingMaster:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.SeasonFishGetFishingMasterRank)
end

function FishingMaster:DataDestroy()
end

function FishingMaster:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FishingMasterRankRefresh, self.RefreshCurList)
end

function FishingMaster:OnRemoveListener()
  self:RemoveUIListener(EventId.FishingMasterRankRefresh, self.RefreshCurList)
  base.OnRemoveListener(self)
end

function FishingMaster:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self:RefreshTop()
  if not LuaEntry.Player:IsInAlliance() then
    self.textEmptyTip:SetActive(true)
    self.textEmptyTip:SetLocalText("300707")
  else
    self.textEmptyTip:SetLocalText("371004")
    self:RefreshCurList()
  end
end

function FishingMaster:RefreshTop()
  self.textTitle:SetLocalText(self.data.activityName)
  self.textDesc:SetLocalText(self.data.bannerTittle)
  self:Update1000MS()
end

function FishingMaster:RemoveList()
  self.compContent:RemoveComponents(UICommonRankItem)
  if self.reqs then
    for _, v in pairs(self.reqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.reqs = {}
end

function FishingMaster:RefreshCurList()
  self:RemoveList()
  local rawList = DataCenter.FishingDataManager:GetFishingMasterRankList()
  rawList = rawList.rankList or {}
  if #rawList == 0 then
    self.textEmptyTip:SetActive(true)
    return
  end
  local list = {}
  local count = math.min(#rawList, 3)
  for i = 1, count do
    table.insert(list, rawList[i])
  end
  self.textEmptyTip:SetActive(false)
  for i = 1, #list do
    self.reqs[i] = self:GameObjectInstantiateAsync(UIAssets.CommonRankItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "FishingMasterRankItem" .. i
      item.transform:SetParent(self.compContent.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.compContent:AddComponent(UICommonRankItem, item.name)
      obj:SetItemShow(list[i], nil, CommonRankType.PERSONAL)
    end)
  end
end

function FishingMaster:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  local countdown = UITimeManager:GetInstance():MilliSecondToFmtString(self.data.endTime - now)
  self.textTime:SetText(countdown)
  local resetTime
  if self.data.para == "1" then
    local today = UITimeManager:GetInstance():GetNowWeekdayIndex()
    if today == 7 then
      resetTime = UITimeManager:GetInstance():GetNextWeekDay(7)
    else
      resetTime = UITimeManager:GetInstance():GetNextWeekDay(7) - 7 * OneDayTime * 1000
    end
  else
    resetTime = UITimeManager:GetInstance():GetNextWeekDay(1)
  end
  local day, hour, min, sec = UITimeManager:GetInstance():MilliSecondToFmtFormat(resetTime - now)
  self.textDay:SetText(string.format("%sD", day))
  self.textHour:SetText(string.format("%02d", hour))
  self.textMin:SetText(string.format("%02d", min))
  self.textSec:SetText(string.format("%02d", sec))
end

function FishingMaster:OnBtnIntroClick()
  DataCenter.LWSoundManager:PlaySound(6100024, false)
  if self.data then
    local param = {}
    param.howToPlayList = self.data.howtoplay
    param.story = self.data.story
    param.defaultTitle = self.data.name
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
  end
end

function FishingMaster:OnBtnBookClick()
  DataCenter.LWSoundManager:PlaySound(6100020, false)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishBook, {anim = true}, DataCenter.SeasonFactionWarDataManager.myCampId)
end

function FishingMaster:OnBtnBagClick()
  DataCenter.LWSoundManager:PlaySound(6100020, false)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishBag, {anim = true})
end

function FishingMaster:OnBtnRankClick()
  DataCenter.LWSoundManager:PlaySound(6100020, false)
  local param = {
    titleText = "s6_fish_activity_title_7",
    rankTitleList = {
      {
        "100184",
        "s6_fish_week_rank_title"
      }
    },
    getRankDataFunc = function()
      return DataCenter.FishingDataManager:GetFishingMasterRankList()
    end,
    refreshEventId = EventId.FishingMasterRankRefresh,
    refreshRewardEventId = EventId.OnGetFishingMasterRankReward,
    pullRewardDataFunc = function()
      SFSNetwork.SendMessage(MsgDefines.GetSeasonRankRewardInfo, 488)
    end,
    openRewardWindowFunc = function()
      local reward = DataCenter.FishingDataManager:GetFishingMasterRewardList()
      if reward and 0 < #reward then
        DataCenter.LWSoundManager:PlaySound(6100024, false)
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, reward)
        return true
      end
      return false
    end
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonRank, {anim = true}, param)
end

function FishingMaster:OnBtnPondClick()
  DataCenter.LWSoundManager:PlaySound(6100020, false)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPond, {anim = true})
end

return FishingMaster
