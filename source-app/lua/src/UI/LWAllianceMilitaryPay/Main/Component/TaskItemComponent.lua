local base = UIBaseContainer
local TaskItemComponent = BaseClass("TaskItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function TaskItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TaskItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TaskItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgComplete = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgNotComplete = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgScroe = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.imgOffice = self.viewSkin:AddComponent(self, UIImage, 7)
end

function TaskItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgComplete = nil
  self.imgNotComplete = nil
  self.textDesc = nil
  self.imgScroe = nil
  self.textNum = nil
  self.compLayout = nil
  self.imgOffice = nil
end

function TaskItemComponent:DataDefine()
end

function TaskItemComponent:DataDestroy()
end

function TaskItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function TaskItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TaskItemComponent:ReInit(conditionParam, data)
  local type = conditionParam[1]
  local needNum = conditionParam[2]
  local curNum = 0
  local localizationKey = ""
  if type == AllianceSalaryConditionType.WeeklyAllianceScore then
    curNum = data.weeklyAllianceSalary or 0
    localizationKey = "alliance_pay_conditionName_2"
  elseif type == AllianceSalaryConditionType.WeeklyPersonalScore then
    curNum = data.weeklyUserSalary or 0
    localizationKey = "alliance_pay_conditionName_3"
  elseif type == AllianceSalaryConditionType.R4R5Days then
    curNum = data.dutyDaysPerWeek or 0
    localizationKey = "alliance_pay_conditionName_4"
  end
  self.imgScroe:SetActive(type ~= AllianceSalaryConditionType.R4R5Days)
  self.imgOffice:SetActive(type == AllianceSalaryConditionType.R4R5Days)
  local isComplete = needNum <= curNum
  if isComplete then
    self.imgComplete:SetActive(true)
    self.imgNotComplete:SetActive(false)
    self.textNum:SetText(string.format("<color=#00FF00>%d</color>/%d", curNum, needNum))
  else
    self.imgComplete:SetActive(false)
    self.imgNotComplete:SetActive(true)
    self.textNum:SetText(string.format("<color=#FF0000>%d</color>/%d", curNum, needNum))
  end
  self.textDesc:SetLocalText(localizationKey)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compLayout.transform)
end

return TaskItemComponent
