local UISpecialCampBar = BaseClass("UISpecialCampBar", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MaxCampCount = 4
local UISpecialCampCell = require("UI.UIHero2.UIHeroRecruit.Component.UISpecialCampCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "TextTitle")
  self.textTitleTime = self:AddComponent(UIText, "TextTitleTime")
  self.objCamps = {}
  for k = 0, MaxCampCount - 1 do
    local cell = self:AddComponent(UISpecialCampCell, "ImgCamp" .. k)
    self.objCamps[k] = cell
  end
  self.textTitle:SetLocalText(110128)
  self.textTitleTime:SetLocalText(110129, "")
end

local function ComponentDestroy(self)
  self.objCamps = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, lotteryId)
  local displayConfig = DataCenter.LotteryDataManager:GetDisplayConfig()
  local curCampId = displayConfig:GetCampId(lotteryId)
  local nextCampId = displayConfig:GetCampId(DataCenter.LotteryDataManager.nextCampLotteryId)
  local campIdList = displayConfig:GetCampIdList()
  for campId, nodeCamp in pairs(self.objCamps) do
    local isCurCamp = campId == curCampId
    local isNextCamp = campId == nextCampId
    nodeCamp:SetData(campId, isCurCamp and lotteryId or nil, isNextCamp)
    nodeCamp:SetActive(campId ~= 0)
  end
end

UISpecialCampBar.OnCreate = OnCreate
UISpecialCampBar.OnDestroy = OnDestroy
UISpecialCampBar.ComponentDefine = ComponentDefine
UISpecialCampBar.ComponentDestroy = ComponentDestroy
UISpecialCampBar.DataDefine = DataDefine
UISpecialCampBar.DataDestroy = DataDestroy
UISpecialCampBar.SetData = SetData
return UISpecialCampBar
