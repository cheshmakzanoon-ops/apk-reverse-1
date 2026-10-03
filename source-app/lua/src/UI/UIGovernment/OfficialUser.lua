local OfficialUser = BaseClass("OfficialUser", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_path = "title"
local player_path = "player"
local name_path = "Name"
local icon_path = "icon"
local unset_path = "unset"
local time_path = "time"
local holdTime_path = "holdTime"
local applyArrowImg_path = "applyArrowImg"
local haveApplyImg_path = "haveApplyImg"

function OfficialUser:OnCreate()
  base.OnCreate(self)
  self.cellBtn = self:AddComponent(UIButton, "")
  self.title = self:AddComponent(UIText, title_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.playerName = self:AddComponent(UIText, name_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.unset = self:AddComponent(UIText, unset_path)
  self.time = self:AddComponent(UIText, time_path)
  self.holdTime = self:AddComponent(UIText, holdTime_path)
  self.applyArrowImg = self:AddComponent(UIImage, applyArrowImg_path)
  self.haveApplyImg = self:AddComponent(UIImage, haveApplyImg_path)
  self.cellBtn:SetOnClick(function()
    self:OnItemClick()
  end)
  self.player:SetEnableClickShowInfo(false, false)
end

function OfficialUser:OnDestroy()
  base.OnDestroy(self)
end

function OfficialUser:UpdateData(positionInfo)
  if self.icon == nil or IsNull(self.icon.gameObject) then
    return
  end
  if positionInfo ~= nil and positionInfo.uid ~= nil and positionInfo.uid ~= "" then
    self.time:SetActive(false)
    self.holdTime:SetActive(true)
    self.unset:SetActive(false)
    self.icon:SetActive(false)
    self.player:SetActive(true)
    self.playerName:SetActive(true)
    self.thePositionInfo = positionInfo
    self.playerName:SetText(positionInfo:GetFullName(self.isConqueror, positionInfo.uid))
    self.player:SetHead(positionInfo.uid, positionInfo.pic, positionInfo.picVer, nil, positionInfo:GetHeadBgImg())
  else
    self.time:SetActive(false)
    self.holdTime:SetActive(false)
    self.player:SetActive(false)
    self.unset:SetActive(true)
    self.icon:SetActive(true)
    self.playerName:SetActive(false)
    self.icon:LoadSprite(self.configData.icon)
    self.icon:SetNativeSize()
    self.unset:SetLocalText(457027)
  end
  self.positionInfo = positionInfo
  self:Update1000MS()
  self:RefreshApplyArrow()
end

function OfficialUser:Reset(index, serverId, isConqueror)
  self.index = index
  self.theCD = nil
  self.serverId = serverId
  self.isConqueror = isConqueror
  self.configData = DataCenter.GovernmentTemplateManager:GetTemplateByGroupAndOrder(GovOfficialGroup.Common, index)
  self.governmentId = self.configData.id
  self.title:SetLocalText(self.configData.name)
  self.time:SetActive(false)
  self.holdTime:SetActive(false)
  self.player:SetActive(false)
  self.unset:SetActive(true)
  self.icon:SetActive(true)
  self.playerName:SetActive(false)
  self.icon:LoadSprite(self.configData.icon)
  self.icon:SetNativeSize()
  self.unset:SetLocalText(457027)
end

function OfficialUser:ReInit(index, param, serverData)
  self.index = index
  self.param = param
  self.serverData = serverData
  if serverData ~= nil then
    self.playerData = serverData.playerData
  end
  self.configData = DataCenter.GovernmentTemplateManager:GetTemplateByGroupAndOrder(GovOfficialGroup.Common, index)
  self.governmentId = self.configData.id
  self.title:SetLocalText(self.configData.name)
  local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(self.governmentId)
  self:UpdateData(positionInfo)
end

function OfficialUser:SetPositionsData(positionInfo, serverId)
  self.theCD = nil
  self.serverId = serverId
  self.positionInfo = positionInfo
  if positionInfo then
    self:UpdateData(positionInfo)
  else
    self.time:SetActive(false)
    self.holdTime:SetActive(false)
    self.player:SetActive(false)
    self.unset:SetActive(true)
    self.icon:SetActive(true)
    self.playerName:SetActive(false)
    self.icon:LoadSprite(self.configData.icon)
    self.icon:SetNativeSize()
    self.unset:SetLocalText(457027)
  end
end

function OfficialUser:OnItemClick()
  if self.playerData == nil or self.serverId ~= nil then
    if DataCenter.GovernmentManager:SwitchOpenOrAtHomeNow() then
      if DataCenter.OfficialApplyManager:CheckCanApply(tostring(self.governmentId)) and self:IsOwnServer() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOfficialApply, {anim = true}, self.governmentId)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentPresidentBuff, {anim = true}, self.index, self.serverData, self.serverId, nil, self.positionInfo)
      end
    else
      UIUtil.ShowTipsId(500019)
    end
  else
    DataCenter.GovernmentManager:TryKingdomPositionAppoint(self.governmentId, self.playerData, self.configData, nil)
  end
end

function OfficialUser:Update1000MS()
  if self.thePositionInfo then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local appointDeltaTime = curTime - self.thePositionInfo.appointTime
    self.holdTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(appointDeltaTime))
  end
end

function OfficialUser:OnPositionInfoUpdate()
  if self:IsOwnServer() then
    local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(self.governmentId)
    self:UpdateData(positionInfo)
  end
  self:RefreshOfficialApplyPoint()
end

function OfficialUser:RefreshApplyArrow()
  local ownApplyPositionId = DataCenter.OfficialApplyManager:GetOwnApplyPositionId()
  if self.governmentId ~= nil and ownApplyPositionId == tostring(self.governmentId) and self:IsOwnServer() and DataCenter.GovernmentManager:SwitchOpenOrAtHomeNow() then
    self.applyArrowImg:SetActive(true)
  else
    self.applyArrowImg:SetActive(false)
  end
  self:RefreshOfficialApplyPoint()
end

function OfficialUser:RefreshOfficialApplyPoint()
  if self.playerData == nil or self.serverId ~= nil then
    if self.governmentId ~= nil and self:IsOwnServer() and DataCenter.GovernmentManager:SwitchOpenOrAtHomeNow() then
      self.haveApplyImg:SetActive(DataCenter.OfficialApplyManager:HaveApplyRed(tostring(self.governmentId)))
    else
      self.haveApplyImg:SetActive(false)
    end
  else
    self.haveApplyImg:SetActive(false)
  end
end

function OfficialUser:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomPositionInfoUpdate, self.OnPositionInfoUpdate)
  self:AddUIListener(EventId.OfficialApplyTipRefresh, self.RefreshApplyArrow)
end

function OfficialUser:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomPositionInfoUpdate, self.OnPositionInfoUpdate)
  self:RemoveUIListener(EventId.OfficialApplyTipRefresh, self.RefreshApplyArrow)
  base.OnRemoveListener(self)
end

function OfficialUser:IsOwnServer()
  return self.serverId == nil or self.serverId == LuaEntry.Player:GetSourceServerId()
end

return OfficialUser
