local base = UIBaseContainer
local UILWDominatorCockatriceUnlockItemComponent = BaseClass("UILWDominatorCockatriceUnlockItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorCockatriceUnlockItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorCockatriceUnlockItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorCockatriceUnlockItemComponent:ComponentDefine()
  self.btnFragment01 = self:AddComponent(UIButton, "")
  self.btnFragment01:SetOnClick(function()
    self:OnBtnFragment01Click()
  end)
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.compSelect = self:AddComponent(UIBaseContainer, "Select")
  self.compRedDotWithoutNum = self:AddComponent(UIBaseContainer, "RedDotWithoutNum")
  self.animatorFragment01 = self:AddComponent(UIAnimator, "")
end

function UILWDominatorCockatriceUnlockItemComponent:ComponentDestroy()
  self.btnFragment01 = nil
  self.imgIcon = nil
  self.compSelect = nil
  self.compRedDotWithoutNum = nil
  self.animatorFragment01 = nil
end

function UILWDominatorCockatriceUnlockItemComponent:DataDefine()
end

function UILWDominatorCockatriceUnlockItemComponent:DataDestroy()
end

function UILWDominatorCockatriceUnlockItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorCockatriceUnlockItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorCockatriceUnlockItemComponent:ReInit(questId, index)
  self.index = index
  self.questId = questId
  local taskData = DataCenter.TaskManager:FindTaskInfo(self.questId)
  local isClaimed = taskData == nil or taskData.state == TaskState.Received
  local isShow = not isClaimed
  self:SetActive(isShow)
  if not isShow then
    return
  end
  local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.questId)
  if questTemplate and not string.IsNullOrEmpty(questTemplate.icon) then
    self.imgIcon:LoadSprite(questTemplate.icon)
  end
  self.compRedDotWithoutNum:SetActive(taskData ~= nil and taskData.state == TaskState.CanReceive)
end

function UILWDominatorCockatriceUnlockItemComponent:UpdateSelection(value)
  self.compSelect:SetActive(value == true)
end

function UILWDominatorCockatriceUnlockItemComponent:OnBtnFragment01Click()
  if self.questId then
    local taskData = DataCenter.TaskManager:FindTaskInfo(self.questId)
    if taskData and taskData.state ~= TaskState.Received and self.view then
      self.view:SetSelectIndex(self.index)
    end
  end
end

function UILWDominatorCockatriceUnlockItemComponent:PlayUnlockAnim()
  self.animatorFragment01:Play("V_ui_UILWDominatorCockatriceUnlock_broke")
end

return UILWDominatorCockatriceUnlockItemComponent
