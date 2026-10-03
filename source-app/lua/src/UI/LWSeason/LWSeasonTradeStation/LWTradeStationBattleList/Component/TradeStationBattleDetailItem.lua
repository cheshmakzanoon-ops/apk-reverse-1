local base = UIBaseContainer
local TradeStationBattleDetailItem = BaseClass("TradeStationBattleDetailItem", base)
local TradeStataionPointData = require("DataCenter.AllianceCityTip.Season.TradeStation.TradeStataionPointData")
local bg_path = "bg"
local firstImg_path = "firstImg"
local secondImg_path = "secondImg"
local thirdImg_path = "thirdImg"
local rank_path = "numTxt"
local name_path = "nameTxt"
local slider_path = "Slider"
local playerHead_path = "headParent/UIPlayerHead"
local sliderDes_path = "Slider/powerTxt"
local frontground_path = "Slider/FillArea/Fill"

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
  self.bg = self:AddComponent(UIImage, bg_path)
  self.firstImg = self:AddComponent(UIBaseContainer, firstImg_path)
  self.secondImg = self:AddComponent(UIBaseContainer, secondImg_path)
  self.thirdImg = self:AddComponent(UIBaseContainer, thirdImg_path)
  self.rank = self:AddComponent(UIText, rank_path)
  self.name = self:AddComponent(UIText, name_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.sliderDes = self:AddComponent(UIText, sliderDes_path)
  self.frontground = self:AddComponent(UIImage, frontground_path)
  self.playerHeadCom = self:AddComponent(UICommonHead, playerHead_path)
  self.playerHeadCom:SetEnableClickShowInfo(true, true)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.firstImg = nil
  self.secondImg = nil
  self.thirdImg = nil
  self.rank = nil
  self.name = nil
  self.slider = nil
  self.playerHead = nil
  self.sliderDes = nil
  self.frontground = nil
  self.playerHeadCom = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TradeStationBattleDetailItem:ReInit(index, data, maxPoint)
  self.firstImg:SetActive(index == 1)
  self.secondImg:SetActive(index == 2)
  self.thirdImg:SetActive(index == 3)
  local buildPointInfo = data.buildPointInfo
  self.rank:SetText(index)
  self.name:SetText(UIUtil.FormatServerAllianceName(buildPointInfo.serverId, buildPointInfo.alAbbr, buildPointInfo.uidName))
  self.playerHeadCom:ParseHeadInfo(buildPointInfo)
  local curScore = TradeStataionPointData.CalcPoint(buildPointInfo, maxPoint)
  local rate = curScore / maxPoint * 100
  self.slider:SetValue(rate)
  self.sliderDes:SetText(string.percentage(curScore, maxPoint, 2))
  self.name:SetColorRGBA255(42, 40, 57, 255)
  if buildPointInfo.uid == LuaEntry.Player.uid then
    self.frontground:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_lv.png")
    self.name:SetColorRGBA255(64, 127, 34, 255)
  elseif not string.IsNullOrEmpty(LuaEntry.Player:GetAllianceUid()) and LuaEntry.Player:GetAllianceUid() == buildPointInfo.allianceId then
    self.frontground:LoadSprite(string.format(LoadPath.LWCommonPath, "lrb_dongjifengbao_jindutiao03"))
  else
    self.frontground:LoadSprite(string.format(LoadPath.LWCommonPath, "lrb_dongjifengbao_jindutiao02"))
  end
end

TradeStationBattleDetailItem.OnCreate = OnCreate
TradeStationBattleDetailItem.OnDestroy = OnDestroy
TradeStationBattleDetailItem.OnEnable = OnEnable
TradeStationBattleDetailItem.OnDisable = OnDisable
TradeStationBattleDetailItem.ComponentDefine = ComponentDefine
TradeStationBattleDetailItem.ComponentDestroy = ComponentDestroy
TradeStationBattleDetailItem.DataDefine = DataDefine
TradeStationBattleDetailItem.DataDestroy = DataDestroy
return TradeStationBattleDetailItem
