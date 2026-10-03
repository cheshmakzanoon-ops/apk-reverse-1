local SciencePreConditionItem = BaseClass("SciencePreConditionItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local scienceIconContainer_path = "science"
local scienceIcon_path = "science/scienceIcon"
local buildIconContainer_path = "build"
local buildIcon_path = "build/buildIcon"
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
  self.buildIconContainerN = self:AddComponent(UIBaseContainer, buildIconContainer_path)
  self.buildIconN = self:AddComponent(UIImage, buildIcon_path)
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
  self.buildIconContainerN = nil
  self.buildIconN = nil
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
  if self.param.condType == 1 then
    self.buildIconContainerN:SetActive(true)
    self.scienceIconContainerN:SetActive(false)
    self.buildIconN:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.param.itemId, self.param.level))
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.itemId)
    if template ~= nil then
      self.buildIconN:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.param.itemId, self.param.level))
      self.descTxtN:SetLocalText("science_condition", self.param.level, Localization:GetString(template.name))
    end
  else
    self.buildIconContainerN:SetActive(false)
    self.scienceIconContainerN:SetActive(true)
    local tempTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.param.itemId, self.param.level)
    local icon = string.format(LoadPath.ScienceIcons, tempTemplate.icon)
    self.scienceIconN:LoadSprite(icon)
    if tempTemplate ~= nil then
      local strDesc = Localization:GetString("science_condition", self.param.level, Localization:GetString(tempTemplate.name))
      self.descTxtN:SetText(strDesc)
    end
  end
end

local function OnClickJumpBtn(self)
  if self.param.condType == 1 then
    GoToUtil.GotoCityByBuildId(self.param.itemId, WorldTileBtnType.City_Upgrade)
  else
    EventManager:GetInstance():Broadcast(EventId.GOTO_SCIENCE, self.param.itemId)
    self.view.ctrl:CloseSelf()
  end
end

SciencePreConditionItem.OnCreate = OnCreate
SciencePreConditionItem.OnDestroy = OnDestroy
SciencePreConditionItem.ComponentDefine = ComponentDefine
SciencePreConditionItem.ComponentDestroy = ComponentDestroy
SciencePreConditionItem.DataDefine = DataDefine
SciencePreConditionItem.DataDestroy = DataDestroy
SciencePreConditionItem.SetCondition = SetCondition
SciencePreConditionItem.OnClickJumpBtn = OnClickJumpBtn
return SciencePreConditionItem
