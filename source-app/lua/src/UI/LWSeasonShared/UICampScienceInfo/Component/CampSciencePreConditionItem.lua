local CampSciencePreConditionItem = BaseClass("CampSciencePreConditionItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local scienceIconContainer_path = "science"
local scienceIcon_path = "science/scienceIcon"
local jumpBtn_path = "jumpBtn"
local jumpBtnTxt_path = "jumpBtn/jumpBtnTxt"
local descTxt_path = "NeedText"

function CampSciencePreConditionItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CampSciencePreConditionItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CampSciencePreConditionItem:ComponentDefine()
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

function CampSciencePreConditionItem:ComponentDestroy()
  self.scienceIconContainerN = nil
  self.scienceIconN = nil
  self.jumpBtnN = nil
  self.jumpBtnTxtN = nil
  self.descTxtN = nil
end

function CampSciencePreConditionItem:DataDefine()
  self.param = {}
end

function CampSciencePreConditionItem:DataDestroy()
  self.param = nil
end

function CampSciencePreConditionItem:SetCondition(param)
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

function CampSciencePreConditionItem:OnClickJumpBtn()
  EventManager:GetInstance():Broadcast(EventId.GOTO_SCIENCE, self.param.itemId)
  self.view.ctrl:CloseSelf()
end

return CampSciencePreConditionItem
