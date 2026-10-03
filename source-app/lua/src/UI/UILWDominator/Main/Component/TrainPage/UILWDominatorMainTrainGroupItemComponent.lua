local base = UIBaseContainer
local UILWDominatorMainTrainGroupItemComponent = BaseClass("UILWDominatorMainTrainGroupItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorMainTrainGroupItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainTrainGroupItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainTrainGroupItemComponent:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.btnUILWDominatorMainTrainGroupItem = self:AddComponent(UIButton, "")
  self.btnUILWDominatorMainTrainGroupItem:SetOnClick(function()
    self:OnBtnUILWDominatorMainTrainGroupItemClick()
  end)
  self.imgBg = self:AddComponent(UIImage, "Bg")
  self.textLevel = self:AddComponent(UIText, "LevelText")
  self.compRed = self:AddComponent(UIBaseContainer, "Bg/Red")
  self.compHighlight = self:AddComponent(UIBaseContainer, "Bg/Highlight")
end

function UILWDominatorMainTrainGroupItemComponent:ComponentDestroy()
  self.animator = nil
  self.btnUILWDominatorMainTrainGroupItem = nil
  self.imgBg = nil
  self.textLevel = nil
  self.compRed = nil
  self.compHighlight = nil
end

function UILWDominatorMainTrainGroupItemComponent:DataDefine()
  self.root = nil
end

function UILWDominatorMainTrainGroupItemComponent:DataDestroy()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.root = nil
end

function UILWDominatorMainTrainGroupItemComponent:ReInit(groupTemplate, root)
  self.root = root
  self.groupTemplate = groupTemplate
  if self.groupTemplate == nil then
    return
  end
  self.info = DataCenter.DominatorManager:GetTrainInfoByGroupId(self.groupTemplate.id)
  if self.info == nil then
    return
  end
  self.textLevel:SetText("Lv." .. tostring(self.info:GetCurLevel()))
  self.imgBg:LoadSprite(self.groupTemplate:GetIconPath())
  local isCanUpgrade = false
  local curLevelTemplate = self.info:GetCurLevelTemplate()
  if curLevelTemplate and not curLevelTemplate:IsMaxLevel() and curLevelTemplate:IsRequireOK() then
    local isCostItemEnough = true
    local costInfo = curLevelTemplate:GetUpgradeCostInfo()
    for i, v in pairs(costInfo) do
      local haveCount = DataCenter.ItemData:GetItemCount(v.itemId)
      if haveCount < v.count then
        isCostItemEnough = false
        break
      end
    end
    if isCostItemEnough then
      isCanUpgrade = true
    end
  end
  self.compRed:SetActive(isCanUpgrade)
end

function UILWDominatorMainTrainGroupItemComponent:UpdateSelect()
  if self.root and self.groupTemplate then
    local curSelectId = self.root:GetCurSelectTrainGroupId()
    self.compHighlight:SetActive(curSelectId ~= nil and curSelectId == self.groupTemplate.id)
  end
end

function UILWDominatorMainTrainGroupItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorMainTrainGroupItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorMainTrainGroupItemComponent:OnBtnUILWDominatorMainTrainGroupItemClick()
  if self.groupTemplate and self.root then
    self.root:OnSelectTrainGroupDetail(self.groupTemplate.id)
  end
end

function UILWDominatorMainTrainGroupItemComponent:PlayInAnim(delay)
  local function Play()
    self:SetActive(true)
    
    if self.animator then
      self.animator:Play("V_ui_UILWDominatorMainTrainGroupItem_in")
    end
  end
  
  self:SetActive(false)
  if not delay or delay <= 0 then
    Play()
  else
    if self.delayTimer ~= nil then
      self.delayTimer:Stop()
      self.delayTimer = nil
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      Play()
    end, delay)
  end
end

return UILWDominatorMainTrainGroupItemComponent
