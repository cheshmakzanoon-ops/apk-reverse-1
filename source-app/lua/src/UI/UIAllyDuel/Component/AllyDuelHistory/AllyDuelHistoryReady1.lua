local AllyDuelHistoryReady1 = BaseClass("AllyDuelHistoryReady1", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization

function AllyDuelHistoryReady1:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelHistoryReady1:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelHistoryReady1:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgAllyFlag = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textAllyName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textReady1Desc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textReady1Cd = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compClock1 = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
end

function AllyDuelHistoryReady1:ComponentDestroy()
  self.viewSkin = nil
  self.imgAllyFlag = nil
  self.textAllyName = nil
  self.textReady1Desc = nil
  self.textReady1Cd = nil
  self.compClock1 = nil
end

function AllyDuelHistoryReady1:DataDefine()
end

function AllyDuelHistoryReady1:DataDestroy()
end

function AllyDuelHistoryReady1:OnAddListener()
  base.OnAddListener(self)
end

function AllyDuelHistoryReady1:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllyDuelHistoryReady1:UpdateTime(timeStr)
  self.textReady1Cd:SetText(timeStr)
end

function AllyDuelHistoryReady1:UpdateInfo()
  self.actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
end

function AllyDuelHistoryReady1:GetEventInfo()
  return self.actInfo ~= nil and self.actInfo:GetEventInfo() or nil
end

function AllyDuelHistoryReady1:UpdateData()
  self:UpdateInfo()
  local inMatch = DataCenter.LeagueMatchManager:CheckIsMatchOpen() and not DataCenter.LeagueMatchManager:CheckAllianceInMatch()
  self.compClock1:SetActive(not inMatch)
  local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if alData then
    self.imgAllyFlag:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, alData.icon))
    self.textAllyName:SetText("[" .. alData.abbr .. "] " .. alData.allianceName)
  end
end

function AllyDuelHistoryReady1:RefreshReadyState(state)
  if state == AllianceBatState.Start or state == AllianceBatState.StartOut then
    self.textReady1Desc:SetLocalText(361075)
  else
    self.textReady1Desc:SetLocalText(361062)
  end
end

return AllyDuelHistoryReady1
