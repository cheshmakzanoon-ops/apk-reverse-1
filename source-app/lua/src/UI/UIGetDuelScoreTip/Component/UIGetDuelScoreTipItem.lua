local UIGetDuelScoreTipItem = BaseClass("UIGetDuelScoreTipItem", UIBaseContainer)
local base = UIBaseContainer
local UIGetDuelScoreTipSlider = require("UI.UIGetDuelScoreTip.Component.UIGetDuelScoreTipSlider")
local slider_path = "Slider"
local type_icon_path = "TypeIcon"
local add_score_text_path = "TypeIcon/AddScoreText"
local btn_path = ""
local RemoveTime = 2000

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.slider = self:AddComponent(UIGetDuelScoreTipSlider, slider_path)
  self.typeIcon = self:AddComponent(UIImage, type_icon_path)
  self.addScoreText = self:AddComponent(UIText, add_score_text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(Bind(self, self.OnClickBtn))
end

local function ComponentDestroy(self)
  self.slider = nil
  self.typeIcon = nil
  self.addScoreText = nil
  self.btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.scoreType = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function Refresh(self, scoreType, oldScore, newScore, targetGroups, isDiff)
  self.scoreType = scoreType
  self.removeTime = RemoveTime + UITimeManager:GetInstance():GetServerTime()
  if scoreType == GetDuelScoreType.Person then
    self.typeIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/icon_junbeijiangzhang.png")
    self.typeIcon:SetSizeDeltaXY(123, 123)
  elseif scoreType == GetDuelScoreType.Ally then
    self.typeIcon:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/lrb_lianmengduijue_tubiao.png")
    self.typeIcon:SetSizeDeltaXY(100, 96)
  end
  self.addScoreText:SetText("+" .. math.floor(newScore - oldScore))
  self.slider:Refresh(oldScore, newScore, targetGroups, isDiff, scoreType)
end

local function CheckNeedRemove(self)
  return UITimeManager:GetInstance():GetServerTime() >= self.removeTime
end

local function OnClickBtn(self)
  if self.scoreType then
    self.removeTime = 0
    self.view:RefreshItemComps()
  end
end

UIGetDuelScoreTipItem.OnCreate = OnCreate
UIGetDuelScoreTipItem.OnDestroy = OnDestroy
UIGetDuelScoreTipItem.OnEnable = OnEnable
UIGetDuelScoreTipItem.OnDisable = OnDisable
UIGetDuelScoreTipItem.ComponentDefine = ComponentDefine
UIGetDuelScoreTipItem.ComponentDestroy = ComponentDestroy
UIGetDuelScoreTipItem.DataDefine = DataDefine
UIGetDuelScoreTipItem.DataDestroy = DataDestroy
UIGetDuelScoreTipItem.OnAddListener = OnAddListener
UIGetDuelScoreTipItem.OnRemoveListener = OnRemoveListener
UIGetDuelScoreTipItem.Refresh = Refresh
UIGetDuelScoreTipItem.CheckNeedRemove = CheckNeedRemove
UIGetDuelScoreTipItem.OnClickBtn = OnClickBtn
return UIGetDuelScoreTipItem
