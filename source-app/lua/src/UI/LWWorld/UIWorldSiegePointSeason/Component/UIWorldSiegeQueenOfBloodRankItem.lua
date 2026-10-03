local UIWorldSiegeQueenOfBloodRankItem = BaseClass("UIWorldSiegeQueenOfBloodRankItem", UIBaseContainer)
local base = UIBaseContainer

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
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.head = self:AddComponent(UICommonHead, "PlayerHead")
  self.textName = self:AddComponent(UIText, "NameText")
  self.textScore = self:AddComponent(UIText, "ScoreText")
  self.slider = self:AddComponent(UISlider, "Slider")
  self.head:SetEnableClickShowInfo(true)
end

local function DataDestroy(self)
  self.head = nil
  self.textName = nil
  self.textScore = nil
  self.slider = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function SetData(self, data, fullScore)
  self.head:ParseHeadInfo(data.roleInfo)
  self.textName:SetText(data.roleInfo.name)
  self.slider:SetValue(data.score / fullScore)
  self.textScore:SetText(string.GetFormattedStr(data.score))
end

UIWorldSiegeQueenOfBloodRankItem.OnCreate = OnCreate
UIWorldSiegeQueenOfBloodRankItem.OnDestroy = OnDestroy
UIWorldSiegeQueenOfBloodRankItem.OnEnable = OnEnable
UIWorldSiegeQueenOfBloodRankItem.OnDisable = OnDisable
UIWorldSiegeQueenOfBloodRankItem.ComponentDefine = ComponentDefine
UIWorldSiegeQueenOfBloodRankItem.ComponentDestroy = ComponentDestroy
UIWorldSiegeQueenOfBloodRankItem.DataDefine = DataDefine
UIWorldSiegeQueenOfBloodRankItem.DataDestroy = DataDestroy
UIWorldSiegeQueenOfBloodRankItem.OnAddListener = OnAddListener
UIWorldSiegeQueenOfBloodRankItem.OnRemoveListener = OnRemoveListener
UIWorldSiegeQueenOfBloodRankItem.SetData = SetData
return UIWorldSiegeQueenOfBloodRankItem
