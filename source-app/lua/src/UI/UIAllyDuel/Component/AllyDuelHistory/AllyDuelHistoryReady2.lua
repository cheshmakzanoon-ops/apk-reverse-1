local AllyDuelHistoryReady2 = BaseClass("AllyDuelHistoryReady2", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization

function AllyDuelHistoryReady2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelHistoryReady2:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelHistoryReady2:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compClock2 = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.textReady2Cd = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textReady2Desc2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnJoin = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnJoin:SetOnClick(function()
    self:OnBtnJoinClick()
  end)
end

function AllyDuelHistoryReady2:ComponentDestroy()
  self.viewSkin = nil
  self.compClock2 = nil
  self.textReady2Cd = nil
  self.textReady2Desc2 = nil
  self.btnJoin = nil
end

function AllyDuelHistoryReady2:DataDefine()
end

function AllyDuelHistoryReady2:DataDestroy()
end

function AllyDuelHistoryReady2:OnAddListener()
  base.OnAddListener(self)
end

function AllyDuelHistoryReady2:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllyDuelHistoryReady2:OnBtnJoinClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if LuaEntry.Player:IsFirstJoinAlliance() == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
  end
end

function AllyDuelHistoryReady2:UpdateTime(timeStr)
  self.textReady2Cd:SetText(timeStr)
end

function AllyDuelHistoryReady2:UpdateInfo()
  self.actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
end

function AllyDuelHistoryReady2:GetEventInfo()
  return self.actInfo ~= nil and self.actInfo:GetEventInfo() or nil
end

function AllyDuelHistoryReady2:UpdateData()
  self:UpdateInfo()
  local inMatch = DataCenter.LeagueMatchManager:CheckIsMatchOpen() and not DataCenter.LeagueMatchManager:CheckAllianceInMatch()
  self.compClock2:SetActive(not inMatch)
  self.textReady2Cd:SetActive(not inMatch)
end

return AllyDuelHistoryReady2
