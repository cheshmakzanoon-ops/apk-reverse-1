local ActSevenDayDoomVanguarListDayItem = BaseClass("ActSevenDayDoomVanguarListDayItem", UIBaseContainer)
local base = UIBaseContainer
local Toggle_path = ""
local TypeText1_path = "Background/TypeText1"
local TypeText2_path = "Background/TypeText2"
local Red_path = "CommonRedPoint"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.Toggle = self:AddComponent(UIToggle, Toggle_path)
  self.TypeText1 = self:AddComponent(UITextMeshProUGUIEx, TypeText1_path)
  self.TypeText2 = self:AddComponent(UITextMeshProUGUIEx, TypeText2_path)
  self.RedPoint = self:AddComponent(UICommonRedPoint, Red_path)
  self.RedPoint:SetType(CommonRedPointPriority.Level1)
  self.Toggle:SetOnValueChanged(function(tf)
    if tf then
      if not self.Toggle.selecting then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
      end
      self.toggleCallback()
    end
    self.Toggle.selecting = false
  end)
end

local function DataDefine(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDestroy(self)
  self.Toggle = nil
  self.TypeText1 = nil
  self.TypeText2 = nil
  self.RedPoint = nil
end

local function DataDestroy(self)
  self.index = nil
  self.toggleCallback = nil
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function SetData(self, index, toggleCallback)
  self.index = index
  self.toggleCallback = toggleCallback
end

local function ReInit(self, strId)
  self.TypeText1:SetLocalText(strId)
  self.TypeText2:SetLocalText(strId)
end

local function OnSelect(self, isSelect)
  self.Toggle:SetIsOn(isSelect)
  self.TypeText1:SetActive(not isSelect)
  self.TypeText2:SetActive(isSelect)
end

local function ShowRed(self, isShow)
  if isShow then
    self.RedPoint:SetNum(1)
  else
    self.RedPoint:SetActive(false)
  end
end

ActSevenDayDoomVanguarListDayItem.OnCreate = OnCreate
ActSevenDayDoomVanguarListDayItem.OnEnable = OnEnable
ActSevenDayDoomVanguarListDayItem.OnAddListener = OnAddListener
ActSevenDayDoomVanguarListDayItem.OnRemoveListener = OnRemoveListener
ActSevenDayDoomVanguarListDayItem.OnDisable = OnDisable
ActSevenDayDoomVanguarListDayItem.ComponentDefine = ComponentDefine
ActSevenDayDoomVanguarListDayItem.ComponentDestroy = ComponentDestroy
ActSevenDayDoomVanguarListDayItem.ComponentDestroy = ComponentDestroy
ActSevenDayDoomVanguarListDayItem.DataDefine = DataDefine
ActSevenDayDoomVanguarListDayItem.DataDestroy = DataDestroy
ActSevenDayDoomVanguarListDayItem.OnDestroy = OnDestroy
ActSevenDayDoomVanguarListDayItem.SetData = SetData
ActSevenDayDoomVanguarListDayItem.ReInit = ReInit
ActSevenDayDoomVanguarListDayItem.OnSelect = OnSelect
ActSevenDayDoomVanguarListDayItem.ShowRed = ShowRed
return ActSevenDayDoomVanguarListDayItem
