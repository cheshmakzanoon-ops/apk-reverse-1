local AlSciencePreConditionItem = BaseClass("AlSciencePreConditionItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local scienceIconContainer_path = "science"
local scienceIcon_path = "science/scienceIcon"
local jumpBtn_path = "jumpBtn"
local jumpBtnTxt_path = "jumpBtn/jumpBtnTxt"
local descTxt_path = "NeedText"

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
  self.scienceIconContainerN = self:AddComponent(UIBaseContainer, scienceIconContainer_path)
  self.scienceIconN = self:AddComponent(UIImage, scienceIcon_path)
  self.jumpBtnN = self:AddComponent(UIButton, jumpBtn_path)
  self.jumpBtnN:SetOnClick(function()
    self:OnClickJumpBtn()
  end)
  self.jumpBtnTxtN = self:AddComponent(UIText, jumpBtnTxt_path)
  self.jumpBtnTxtN:SetLocalText(GameDialogDefine.GOTO)
  self.descTxtN = self:AddComponent(UIText, descTxt_path)
end

local function ComponentDestroy(self)
  self.scienceIconContainerN = nil
  self.scienceIconN = nil
  self.jumpBtnN = nil
  self.jumpBtnTxtN = nil
  self.descTxtN = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function SetCondition(self, param)
  self.param = param
  self.scienceIconContainerN:SetActive(true)
  local tempTemplate = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(self.param.itemId)
  local icon = tempTemplate.icon
  self.scienceIconN:LoadSprite(icon)
  if tempTemplate ~= nil then
    local strDesc = Localization:GetString("science_condition", self.param.level, Localization:GetString(tempTemplate.name))
    self.descTxtN:SetText(strDesc)
  end
end

local function OnClickJumpBtn(self)
  EventManager:GetInstance():Broadcast(EventId.GOTO_SCIENCE, self.param.itemId)
  self.view.ctrl:CloseSelf()
end

AlSciencePreConditionItem.OnCreate = OnCreate
AlSciencePreConditionItem.OnDestroy = OnDestroy
AlSciencePreConditionItem.ComponentDefine = ComponentDefine
AlSciencePreConditionItem.ComponentDestroy = ComponentDestroy
AlSciencePreConditionItem.DataDefine = DataDefine
AlSciencePreConditionItem.DataDestroy = DataDestroy
AlSciencePreConditionItem.SetCondition = SetCondition
AlSciencePreConditionItem.OnClickJumpBtn = OnClickJumpBtn
return AlSciencePreConditionItem
