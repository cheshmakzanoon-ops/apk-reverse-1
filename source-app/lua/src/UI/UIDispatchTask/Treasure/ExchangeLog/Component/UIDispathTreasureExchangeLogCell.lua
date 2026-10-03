local UIDispathTreasureExchangeLogCell = BaseClass("UIDispathTreasureExchangeLogCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIDispathTreasureExchangeLogCellItem = require("UI.UIDispatchTask.Treasure.ExchangeLog.Component.UIDispathTreasureExchangeLogCellItem")

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
  self.compLeftItem = self:AddComponent(UIDispathTreasureExchangeLogCellItem, "LeftItem")
  self.compRightItem = self:AddComponent(UIDispathTreasureExchangeLogCellItem, "RightItem")
  self.textTime = self:AddComponent(UIText, "Bg/TimeText")
end

local function ComponentDestroy(self)
  self.compLeftItem = nil
  self.compRightItem = nil
  self.textTime = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data, logType)
  if logType == SplinterExchangeLogType.Own then
    local leftInfo = {}
    leftInfo.uid = LuaEntry.Player:GetUid()
    leftInfo.pic = LuaEntry.Player:GetPic()
    leftInfo.picVer = LuaEntry.Player.picVer
    leftInfo.frameBg = LuaEntry.Player:GetHeadBgImg()
    leftInfo.name = LuaEntry.Player:GetName()
    data.leftInfo = leftInfo
  end
  self.compLeftItem:SetData(data, true)
  self.compRightItem:SetData(data, false)
  self.textTime:SetText(UITimeManager:GetInstance():TimeStampToMDHSForLocalMinute(data.time))
end

UIDispathTreasureExchangeLogCell.OnCreate = OnCreate
UIDispathTreasureExchangeLogCell.OnDestroy = OnDestroy
UIDispathTreasureExchangeLogCell.OnEnable = OnEnable
UIDispathTreasureExchangeLogCell.OnDisable = OnDisable
UIDispathTreasureExchangeLogCell.ComponentDefine = ComponentDefine
UIDispathTreasureExchangeLogCell.ComponentDestroy = ComponentDestroy
UIDispathTreasureExchangeLogCell.DataDefine = DataDefine
UIDispathTreasureExchangeLogCell.DataDestroy = DataDestroy
UIDispathTreasureExchangeLogCell.OnAddListener = OnAddListener
UIDispathTreasureExchangeLogCell.OnRemoveListener = OnRemoveListener
UIDispathTreasureExchangeLogCell.SetData = SetData
return UIDispathTreasureExchangeLogCell
