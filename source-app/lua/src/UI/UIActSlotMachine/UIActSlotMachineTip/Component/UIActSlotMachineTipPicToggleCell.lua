local UIActSlotMachineTipPicToggleCell = BaseClass("UIActSlotMachineTipPicToggleCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_path = ""
local beSelect_path = "beSelect"

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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClickFunc()
  end)
  self.beSelect = self:AddComponent(UIBaseContainer, beSelect_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.beSelect = nil
end

local function DataDefine(self)
  self.index = nil
  self.beSelectIndex = nil
  self.callBack = nil
end

local function DataDestroy(self)
  self.index = nil
  self.beSelectIndex = nil
  self.callBack = nil
end

local function SetData(self, index, beSelectIndex, callBack)
  self.index = index
  self.beSelectIndex = beSelectIndex
  self.callBack = callBack
  self:Refresh()
end

local function SetBeSelectData(self, beSelectIndex)
  self.beSelectIndex = beSelectIndex
  self:Refresh()
end

local function Refresh(self)
  self.beSelect:SetActive(self.index == self.beSelectIndex)
end

local function OnBtnClickFunc(self)
  if self.callBack then
    self.callBack(self.index)
  end
end

UIActSlotMachineTipPicToggleCell.OnCreate = OnCreate
UIActSlotMachineTipPicToggleCell.OnDestroy = OnDestroy
UIActSlotMachineTipPicToggleCell.ComponentDefine = ComponentDefine
UIActSlotMachineTipPicToggleCell.ComponentDestroy = ComponentDestroy
UIActSlotMachineTipPicToggleCell.DataDefine = DataDefine
UIActSlotMachineTipPicToggleCell.DataDestroy = DataDestroy
UIActSlotMachineTipPicToggleCell.SetData = SetData
UIActSlotMachineTipPicToggleCell.SetBeSelectData = SetBeSelectData
UIActSlotMachineTipPicToggleCell.Refresh = Refresh
UIActSlotMachineTipPicToggleCell.OnBtnClickFunc = OnBtnClickFunc
return UIActSlotMachineTipPicToggleCell
