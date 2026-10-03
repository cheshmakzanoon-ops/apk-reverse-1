local base = UIBaseContainer
local UILWTradeRecordItem = BaseClass("UILWTradeRecordItem", base)
local playerHead_path = "headParent/UIPlayerHead"
local name_path = "name"
local time_path = "time"
local content_path = "content"
local taxImg_path = "taxImg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.name = self:AddComponent(UIText, name_path)
  self.time = self:AddComponent(UIText, time_path)
  self.content = self:AddComponent(UIText, content_path)
  self.taxImg = self:AddComponent(UIBaseContainer, taxImg_path)
  self.playerHeadCom = self:AddComponent(UICommonHead, playerHead_path)
end

local function ComponentDestroy(self)
  self.playerHeadCom = nil
  self.playerHead = nil
  self.name = nil
  self.time = nil
  self.content = nil
  self.taxImg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UILWTradeRecordItem:ReInit(index, data, recordType)
  self.content:SetText(data.content)
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.time))
  self.name:SetText(UIUtil.FormatServerAllianceName(data.userInfo.serverId, data.userInfo.abbr, data.userInfo.name))
  self.playerHeadCom:SetEnableClickShowInfo(true)
  self.playerHeadCom:SetActive(recordType == 1)
  if recordType == 1 then
    self.playerHeadCom:ParseHeadInfo(data.userInfo)
    if data.userInfo.allianceId == LuaEntry.Player:GetAllianceUid() then
      self.name:SetColorRGBA255(35, 155, 197, 255)
    else
      self.name:SetColorRGBA255(0, 0, 0, 255)
    end
  end
  self.taxImg:SetActive(recordType == 2)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

UILWTradeRecordItem.OnCreate = OnCreate
UILWTradeRecordItem.OnDestroy = OnDestroy
UILWTradeRecordItem.OnEnable = OnEnable
UILWTradeRecordItem.OnDisable = OnDisable
UILWTradeRecordItem.ComponentDefine = ComponentDefine
UILWTradeRecordItem.ComponentDestroy = ComponentDestroy
UILWTradeRecordItem.DataDefine = DataDefine
UILWTradeRecordItem.DataDestroy = DataDestroy
return UILWTradeRecordItem
