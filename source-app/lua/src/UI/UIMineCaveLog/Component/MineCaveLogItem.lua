local MineCaveLogItem = BaseClass("MineCaveLogItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local playerHeadBtn_path = "HeadGo/UIPlayerHead"
local playerHead_path = "HeadGo/UIPlayerHead/HeadIcon"
local playerHeadFg_path = "HeadGo/UIPlayerHead/Foreground"
local plunderTime_path = "time"
local plunderInfo_path = "info"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.playerHeadBtnN = self:AddComponent(UIButton, playerHeadBtn_path)
  self.playerHeadBtnN:SetOnClick(function()
    self:OnClickPlayerName()
  end)
  self.playerHeadN = self:AddComponent(UIPlayerHead, playerHead_path)
  self.playerHeadFgN = self:AddComponent(UIImage, playerHeadFg_path)
  self.plunderTimeN = self:AddComponent(UIText, plunderTime_path)
  self.plunderInfoN = self:AddComponent(UIText, plunderInfo_path)
end

local function ComponentDestroy(self)
  self.plunderTimeN = nil
  self.plunderInfoN = nil
end

local function DataDefine(self)
  self.logInfo = nil
end

local function DataDestroy(self)
  self.logInfo = nil
end

local function SetItem(self, logInfo)
  self.logInfo = logInfo
  self.plunderTimeN:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(self.logInfo.time))
  self.playerHeadN:SetData(self.logInfo.playerUid, self.logInfo.playerPic, self.logInfo.playerPicVer)
  if self.logInfo:GetHeadBgImg() then
    self.playerHeadFgN:SetActive(true)
  else
    self.playerHeadFgN:SetActive(false)
  end
  local playerName = self.logInfo.playerName
  if not string.IsNullOrEmpty(self.logInfo.playerAlAbbr) then
    playerName = "[" .. self.logInfo.playerAlAbbr .. "]" .. playerName
  end
  if self.logInfo.plunderType == 2 then
    self.plunderInfoN:SetText(Localization:GetString("302229", playerName))
  else
    local resName = DataCenter.RewardManager:GetNameByType(self.logInfo.rewardType, self.logInfo.itemId)
    self.plunderInfoN:SetText(Localization:GetString("302228", playerName, self.logInfo.rewardNum, resName))
  end
end

local function OnClickPlayerName(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, self.logInfo.playerUid)
end

MineCaveLogItem.OnCreate = OnCreate
MineCaveLogItem.OnDestroy = OnDestroy
MineCaveLogItem.ComponentDefine = ComponentDefine
MineCaveLogItem.ComponentDestroy = ComponentDestroy
MineCaveLogItem.DataDefine = DataDefine
MineCaveLogItem.DataDestroy = DataDestroy
MineCaveLogItem.SetItem = SetItem
MineCaveLogItem.OnClickPlayerName = OnClickPlayerName
return MineCaveLogItem
