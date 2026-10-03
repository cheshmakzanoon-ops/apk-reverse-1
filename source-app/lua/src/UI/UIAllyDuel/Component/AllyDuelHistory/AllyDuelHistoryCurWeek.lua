local AllyDuelHistoryCurWeek = BaseClass("AllyDuelHistoryCurWeek", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local AllyDuelScheduleItem = require("UI.UIAllyDuel.Component.AllyDuelHistory.AllyDuelScheduleItem")
local AllyDuelHistoryReward = require("UI.UIAllyDuel.Component.AllyDuelHistory.AllyDuelHistoryReward")

function AllyDuelHistoryCurWeek:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelHistoryCurWeek:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelHistoryCurWeek:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textScore1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textScore3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgFlagRed = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textRedAllianceNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgFlagBlue = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textBlueAllianceNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTimeTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compItemContainer = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.textTipTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compReward2 = self.viewSkin:AddComponent(self, AllyDuelHistoryReward, 10)
  self.compReward1 = self.viewSkin:AddComponent(self, AllyDuelHistoryReward, 11)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
end

function AllyDuelHistoryCurWeek:ComponentDestroy()
  self.viewSkin = nil
  self.textScore1 = nil
  self.textScore3 = nil
  self.imgFlagRed = nil
  self.textRedAllianceNameTxt = nil
  self.imgFlagBlue = nil
  self.textBlueAllianceNameTxt = nil
  self.textTimeTxt = nil
  self.compItemContainer = nil
  self.textTipTxt = nil
  self.compReward2 = nil
  self.compReward1 = nil
  self.compContent = nil
end

function AllyDuelHistoryCurWeek:DataDefine()
end

function AllyDuelHistoryCurWeek:DataDestroy()
  self:CleanItems()
end

function AllyDuelHistoryCurWeek:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceCompeteWeeklySummaryUpdated, self.RefreshUI)
  self:AddUIListener(EventId.RefreshAllianceArmsUI, self.RefreshUI)
  self:AddUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.UpdateReward)
  self:AddUIListener(EventId.AllianceApplySuccess, self.UpdateData)
end

function AllyDuelHistoryCurWeek:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceCompeteWeeklySummaryUpdated, self.RefreshUI)
  self:RemoveUIListener(EventId.RefreshAllianceArmsUI, self.RefreshUI)
  self:RemoveUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.UpdateReward)
  self:RemoveUIListener(EventId.AllianceApplySuccess, self.UpdateData)
  base.OnRemoveListener(self)
end

function AllyDuelHistoryCurWeek:UpdateTime(timeStr)
  self.textTimeTxt:SetText(timeStr)
end

function AllyDuelHistoryCurWeek:UpdateInfo()
  self.actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
end

function AllyDuelHistoryCurWeek:GetEventInfo()
  return self.actInfo ~= nil and self.actInfo:GetEventInfo() or nil
end

function AllyDuelHistoryCurWeek:UpdateData()
  SFSNetwork.SendMessage(MsgDefines.AllianceCompeteWeeklySummary)
end

function AllyDuelHistoryCurWeek:RefreshUI()
  self:UpdateInfo()
  self:RefreshAlliance()
  self:RefreshSchedule()
  self:RefreshReward()
end

function AllyDuelHistoryCurWeek:RefreshAlliance()
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  if not hasAlliance or myAllianceId == nil then
    return
  end
  local eventInfo = self:GetEventInfo()
  local allianceList = eventInfo ~= nil and eventInfo.vsAllianceList or nil
  if allianceList == nil then
    return
  end
  table.walk(allianceList, function(k, v)
    local haveAl = not string.IsNullOrEmpty(v.alName)
    local name = haveAl and string.format([[
#%s [%s]
%s]], v.serverId, v.abbr, v.alName) or Localization:GetString("372814")
    local winTimes = (v.winScore == 0 or v.winScore == nil) and "0" or v.winScore
    if k == myAllianceId then
      self.textRedAllianceNameTxt:SetText(name)
      self.textScore1:SetText(winTimes)
      if self.selfALIcon ~= v.icon then
        self.imgFlagRed:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, v.icon))
        self.selfALIcon = v.icon
      end
    else
      self.textBlueAllianceNameTxt:SetText(name)
      self.textScore3:SetText(winTimes)
      local icon = haveAl and v.icon or 1
      if self.otherALIcon ~= icon then
        self.imgFlagBlue:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, icon))
        self.otherALIcon = icon
      end
    end
  end)
end

function AllyDuelHistoryCurWeek:RefreshSchedule()
  self:CleanItems()
  local list = DataCenter.AllianceCompeteDataManager:GetWeeklySummaryList()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local startT = DataCenter.AllianceCompeteDataManager:GetWeeklySummaryStartTime() or 0
  local day = math.ceil((curTime - startT) / (OneDayTime * 1000))
  if table.IsNullOrEmpty(list) then
    return
  end
  local eventList = self.actInfo ~= nil and self.actInfo.eventList or nil
  local vsAllianceInfo = eventList ~= nil and eventList[1] ~= nil and eventList[1].vsAllianceInfo or nil
  local maxCnt = table.length(list)
  for i = 1, maxCnt do
    self.itemCount = self.itemCount + 1
    self.itemModel[self.itemCount] = self:GameObjectInstantiateAsync(UIAssets.AllyDuelScheduleItemNew, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.compItemContainer.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.compItemContainer:AddComponent(AllyDuelScheduleItem, nameStr)
      cell:RefreshData(list[i], day, vsAllianceInfo or {})
    end)
  end
end

function AllyDuelHistoryCurWeek:CleanItems()
  self.compItemContainer:RemoveComponents(AllyDuelScheduleItem)
  if self.itemModel ~= nil then
    for _, v in pairs(self.itemModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.itemModel = {}
  self.itemCount = 0
end

function AllyDuelHistoryCurWeek:RefreshReward()
  self.curSegment = DataCenter.LeagueMatchManager:GetSegment()
  self:UpdateReward()
end

function AllyDuelHistoryCurWeek:UpdateReward()
  local segment = DataCenter.LeagueMatchManager:CheckIsOpenForReward() and self.curSegment or 0
  local rewardInfo = DataCenter.LeagueMatchManager:GetRewardInfo(2, segment)
  if not rewardInfo then
    self.compReward1:SetActive(false)
    self.compReward2:SetActive(false)
    return
  end
  local point = rewardInfo ~= nil and rewardInfo.requireWeekPoint or 0
  local info = rewardInfo ~= nil and rewardInfo.weekWinReward or nil
  self.compReward1:SetActive(info ~= nil)
  if info ~= nil then
    self.compReward1:SetData(info, point, segment, true)
  end
  info = rewardInfo ~= nil and rewardInfo.weekFailReward or nil
  self.compReward2:SetActive(info ~= nil)
  if info ~= nil then
    self.compReward2:SetData(info, point, segment, false)
  end
end

return AllyDuelHistoryCurWeek
