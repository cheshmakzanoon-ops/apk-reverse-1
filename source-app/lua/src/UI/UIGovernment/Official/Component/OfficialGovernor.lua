local base = UIAsyncContainer
local OfficialGovernor = BaseClass("OfficialGovernor", base)
local title_path = "title"
local player_path = "player"
local name_path = "Name"
local icon_path = "icon"
local unset_path = "unset"
local time_path = "time"
local holdTime_path = "holdTime"
local applyArrowImg_path = "applyArrowImg"
local haveApplyImg_path = "haveApplyImg"

function OfficialGovernor:OnCreate()
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

function OfficialGovernor:OnDestroy()
  self.configData = nil
  self.positionInfo = nil
  self.icon = nil
  base.OnDestroy(self)
end

function OfficialGovernor:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomPositionInfoUpdate, self.OnPositionInfoUpdate)
  self:AddUIListener(EventId.OfficialApplyTipRefresh, self.RefreshApplyArrow)
end

function OfficialGovernor:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomPositionInfoUpdate, self.OnPositionInfoUpdate)
  self:RemoveUIListener(EventId.OfficialApplyTipRefresh, self.RefreshApplyArrow)
  base.OnRemoveListener(self)
end

function OfficialGovernor:SetData(governmentId, serverId, isConqueror, positionInfo)
  self.governmentId = governmentId
  self.serverId = serverId
  self.isConqueror = isConqueror
  self.positionInfo = positionInfo
  self.configData = DataCenter.GovernmentTemplateManager:GetTemplate(governmentId)
  self:RefreshView()
end

function OfficialGovernor:UpdateData()
  if self.configData == nil then
    return
  end
  self.title:SetLocalText(self.configData.name)
  self:RefreshData(self.positionInfo)
end

function OfficialGovernor:Reset()
  self.time:SetActive(false)
  self.holdTime:SetActive(false)
  self.player:SetActive(false)
  self.unset:SetActive(true)
  self.icon:SetActive(true)
  self.playerName:SetActive(false)
  self.icon:LoadSpriteAsyncWithCallback(self.configData.icon, function()
    if self.icon then
      self.icon:SetNativeSize()
    end
  end)
  self.unset:SetLocalText(457027)
end

function OfficialGovernor:RefreshData(positionInfo)
  if self.configData == nil then
    return
  end
  if positionInfo ~= nil and positionInfo.uid ~= nil and positionInfo.uid ~= "" then
    self.time:SetActive(false)
    self.holdTime:SetActive(true)
    self.player:SetActive(true)
    self.unset:SetActive(false)
    self.icon:SetActive(false)
    self.playerName:SetActive(true)
    self.playerName:SetText(positionInfo:GetFullName(self.isConqueror, positionInfo.uid))
    self.player:SetHead(positionInfo.uid, positionInfo.pic, positionInfo.picVer, nil, positionInfo:GetHeadBgImg())
  else
    self:Reset()
  end
  self.positionInfo = positionInfo
  self:Update1000MS()
  self:RefreshApplyArrow()
end

function OfficialGovernor:OnItemClick()
  if self.playerData == nil or self.serverId ~= nil then
    if DataCenter.GovernmentManager:SwitchOpenOrAtHomeNow() then
      if DataCenter.OfficialApplyManager:CheckCanApply(tostring(self.governmentId)) and self:IsOwnServer() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOfficialApply, {anim = true}, self.governmentId)
      else
        local index = self.configData ~= nil and self.configData.order or nil
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentPresidentBuff, {anim = true}, index, self.serverData, self.serverId, nil, self.positionInfo)
      end
    else
      UIUtil.ShowTipsId(500019)
    end
  else
    DataCenter.GovernmentManager:TryKingdomPositionAppoint(self.governmentId, self.playerData, self.configData, nil)
  end
end

function OfficialGovernor:Update1000MS()
  if self.positionInfo then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local appointDeltaTime = curTime - self.positionInfo.appointTime
    self.holdTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(appointDeltaTime))
  end
end

function OfficialGovernor:OnPositionInfoUpdate()
  if self:IsOwnServer() then
    local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(self.governmentId)
    self:RefreshData(positionInfo)
  end
  self:RefreshOfficialApplyPoint()
end

function OfficialGovernor:RefreshApplyArrow()
  local ownApplyPositionId = DataCenter.OfficialApplyManager:GetOwnApplyPositionId()
  if self.governmentId ~= nil and ownApplyPositionId == tostring(self.governmentId) and self:IsOwnServer() and DataCenter.GovernmentManager:SwitchOpenOrAtHomeNow() then
    self.applyArrowImg:SetActive(true)
  else
    self.applyArrowImg:SetActive(false)
  end
  self:RefreshOfficialApplyPoint()
end

function OfficialGovernor:RefreshOfficialApplyPoint()
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

function OfficialGovernor:IsOwnServer()
  return self.serverId == nil or self.serverId == LuaEntry.Player:GetSourceServerId()
end

function OfficialGovernor:SetBg(isFront)
  local name = isFront and "lrb_zhanqvguanzhi_qizi00" or "zyf_renmingguanzhi_qizi"
  self.cellBtn:LoadSpriteAuto(string.format(LoadPath.UIGovernment, name))
end

return OfficialGovernor
