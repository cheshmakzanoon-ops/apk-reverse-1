local ActMonopolyTopRightBtnsContent = BaseClass("ActMonopolyTopRightBtnsContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_info_path = "ActivityTopGo/BtnInfo"
local btn_info_txt_path = "ActivityTopGo/BtnInfo/BtnInfoTxt"
local btn_info_red_point_path = "ActivityTopGo/BtnInfo/BtnInfoRedPoint"
local btn_exchange_path = "ActivityTopGo/BtnExchange"
local btn_exchange_txt_path = "ActivityTopGo/BtnExchange/BtnExchangeTxt"
local btn_exchange_red_point_path = "ActivityTopGo/BtnExchange/BtnExchangeRedPoint"
local btn_radar_treasure_path = "ActivityTopGo/BtnRadarTreasure"
local btn_radar_treasure_txt_path = "ActivityTopGo/BtnRadarTreasure/BtnRadarTreasureTxt"
local btn_radar_treasure_red_point_path = "ActivityTopGo/BtnRadarTreasure/BtnRadarTreasureRedPoint"
local btn_exchange_icon_path = "ActivityTopGo/BtnExchange/BtnExchangeIcon"

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
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info_txt = self:AddComponent(UIText, btn_info_txt_path)
  self.btn_info_red_point = self:AddComponent(UIImage, btn_info_red_point_path)
  self.btn_exchange = self:AddComponent(UIButton, btn_exchange_path)
  self.btn_exchange_txt = self:AddComponent(UIText, btn_exchange_txt_path)
  self.btn_exchange_red_point = self:AddComponent(UIImage, btn_exchange_red_point_path)
  self.btn_radar_treasure = self:AddComponent(UIButton, btn_radar_treasure_path)
  self.btn_radar_treasure_txt = self:AddComponent(UIText, btn_radar_treasure_txt_path)
  self.btn_radar_treasure_red_point = self:AddComponent(UIImage, btn_radar_treasure_red_point_path)
  self.btn_info:SetOnClick(function()
    self:BtnInfoClick()
  end)
  self.btn_exchange:SetOnClick(function()
    self:BtnExchangeClick()
  end)
  self.btn_radar_treasure:SetOnClick(function()
    self:BtnRadarTreasureClick()
  end)
  self.btn_exchange_icon = self:AddComponent(UIImage, btn_exchange_icon_path)
end

local function ComponentDestroy(self)
  self.btn_exchange_icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, mainView, activityId, activityInfo, activityDetailData, costData, isBoss)
  self.mainView = mainView
  self.activityId = activityId
  self.activityInfo = activityInfo
  self.activityDetailData = activityDetailData
  self.costData = costData
  self.isBoss = isBoss
  self:SetConfigView()
  self:RefreshView()
  SFSNetwork.SendMessage(MsgDefines.ActivityDetectList, self.activityId, 1)
end

local function RefreshView(self)
  local isBtnTreasureOpen = false
  local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(self.activityInfo.richman_para)
  if paraTemp and paraTemp.para9 > 0 then
    isBtnTreasureOpen = true
  end
  self.btn_radar_treasure:SetActive(isBtnTreasureOpen)
  self:RefrshRadarTreasureRed()
  self:RefreshExchangeBtnRed()
end

local function BtnInfoClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActMonopolyRules, {anim = true}, self.activityId)
end

local function BtnExchangeClick(self)
  if self.activityInfo then
    local jumpTo = self.activityInfo:GetFirstActiveJumpTo()
    if 0 < jumpTo then
      GoToUtil.GoActWindow({jumpTo}, false)
    end
  end
end

local function BtnRadarTreasureClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWActDetectTreasureALPanel, {anim = true}, self.activityId)
  DataCenter.ActDetectTreasureDataManager.treasures_num = 0
  self:RefrshRadarTreasureRed()
end

local function RefrshRadarTreasureRed(self)
  local redNum = DataCenter.ActDetectTreasureDataManager.treasures_num
  self.btn_radar_treasure_red_point:SetActive(0 < redNum)
end

local function RefreshExchangeBtnRed(self)
  local jumpTo = self.activityInfo:GetFirstActiveJumpTo()
  local changeNum = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(EnumActivity.CitySkinExchange.Type, jumpTo)
  self.btn_exchange_red_point:SetActive(0 < changeNum)
end

local function SetConfigView(self)
  local showTemp = self.activityInfo:GetShowConfigTemp()
  if showTemp and not string.IsNullOrEmpty(showTemp.pic_spec2) then
    local path = string.format(UIAssets.UIActMonopolySpritePath, showTemp.pic_spec2)
    self.btn_exchange_icon:LoadSprite(path)
  end
end

ActMonopolyTopRightBtnsContent.OnCreate = OnCreate
ActMonopolyTopRightBtnsContent.OnDestroy = OnDestroy
ActMonopolyTopRightBtnsContent.ComponentDefine = ComponentDefine
ActMonopolyTopRightBtnsContent.ComponentDestroy = ComponentDestroy
ActMonopolyTopRightBtnsContent.DataDefine = DataDefine
ActMonopolyTopRightBtnsContent.DataDestroy = DataDestroy
ActMonopolyTopRightBtnsContent.SetData = SetData
ActMonopolyTopRightBtnsContent.RefreshView = RefreshView
ActMonopolyTopRightBtnsContent.RefrshRadarTreasureRed = RefrshRadarTreasureRed
ActMonopolyTopRightBtnsContent.BtnInfoClick = BtnInfoClick
ActMonopolyTopRightBtnsContent.BtnExchangeClick = BtnExchangeClick
ActMonopolyTopRightBtnsContent.BtnRadarTreasureClick = BtnRadarTreasureClick
ActMonopolyTopRightBtnsContent.RefreshExchangeBtnRed = RefreshExchangeBtnRed
ActMonopolyTopRightBtnsContent.SetConfigView = SetConfigView
return ActMonopolyTopRightBtnsContent
