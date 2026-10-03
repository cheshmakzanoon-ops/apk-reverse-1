local LWUIMasteryMain = BaseClass("LWUIMasteryMain", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWUIMasteryChooseComp = require("UI.LWUIMastery.Component.LWUIMasteryChooseComp")
local LWUIMasteryHaveChoosedComp = require("UI.LWUIMastery.Component.LWUIMasteryHaveChoosedComp")
local info_btn_path = "InfoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.chooseMastery = self:AddComponent(LWUIMasteryChooseComp, "ChooseMastery")
  self.masteryChoosed = self:AddComponent(LWUIMasteryHaveChoosedComp, "MasteryChoosed")
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(BindCallback(self, self.OnInfoClick))
end

local function ComponentDestroy(self)
  self.chooseMastery = nil
  self.masteryChoosed = nil
  self.info_btn = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWMasteryInfoMsgGet, self.Refresh)
  self:AddUIListener(EventId.LWMasteryChangeMsgGet, self.Refresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWMasteryInfoMsgGet, self.Refresh)
  self:RemoveUIListener(EventId.LWMasteryChangeMsgGet, self.Refresh)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self:Refresh()
end

local function Refresh(self)
  local data = DataCenter.MasteryManager:GetData()
  if data == nil then
    return
  end
  local homeId = data.home_id
  if homeId == 0 then
    self.chooseMastery:SetActive(true)
    self.masteryChoosed:SetActive(false)
    self.chooseMastery:ReInit()
  else
    self.chooseMastery:SetActive(false)
    self.masteryChoosed:SetActive(true)
    self.masteryChoosed:ReInit()
  end
end

local function OnInfoClick(self)
  local param = {}
  param.title = "170001"
  param.activityRulesStr = Localization:GetString("season_mastery_tips_7")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

LWUIMasteryMain.OnCreate = OnCreate
LWUIMasteryMain.OnDestroy = OnDestroy
LWUIMasteryMain.ComponentDefine = ComponentDefine
LWUIMasteryMain.ComponentDestroy = ComponentDestroy
LWUIMasteryMain.OnAddListener = OnAddListener
LWUIMasteryMain.OnRemoveListener = OnRemoveListener
LWUIMasteryMain.ReInit = ReInit
LWUIMasteryMain.Refresh = Refresh
LWUIMasteryMain.OnInfoClick = OnInfoClick
return LWUIMasteryMain
