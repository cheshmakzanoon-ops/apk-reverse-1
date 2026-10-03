local UILWDominatorTrainPreviewView = BaseClass("UILWDominatorTrainPreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWDominatorTrainPreviewCellBigComponent = require("UI/UILWDominator/Train/TrainPreview/Component/UILWDominatorTrainPreviewCellBigComponent")
local UILWDominatorTrainPreviewCellSmallComponent = require("UI/UILWDominator/Train/TrainPreview/Component/UILWDominatorTrainPreviewCellSmallComponent")
local UILWDominatorTrainPreviewCellSmallLockedComponent = require("UI/UILWDominator/Train/TrainPreview/Component/UILWDominatorTrainPreviewCellSmallLockedComponent")

function UILWDominatorTrainPreviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWDominatorTrainPreviewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorTrainPreviewView:OnOpen()
  self:ClearCells()
  self.info = DataCenter.DominatorManager:GetMainTrainGroupInfo()
  self.curLevelTemplate = nil
  if self.info then
    self.curLevelTemplate = self.info:GetCurLevelTemplate()
  end
  self.showTemplates = self.ctrl:GetShowDataList()
  self.showCount = #self.showTemplates
  if self.curLevelTemplate == nil then
    return
  end
  for i, v in ipairs(self.showTemplates) do
    if v:GetBigLevel() < self.curLevelTemplate:GetBigLevel() or self.curLevelTemplate:IsMaxLevel() then
      local item = self.objSmallCell.gameObject:GameObjectSpawn(self.compContent.transform)
      item.name = tostring(v.id)
      local obj = self.compContent:AddComponent(UILWDominatorTrainPreviewCellSmallComponent, item.name)
      obj:SetActive(true)
      obj:ReInit(v, v:IsFinalBigLevel(), i == 1)
    elseif v:GetBigLevel() == self.curLevelTemplate:GetBigLevel() then
      local item = self.objBigCell.gameObject:GameObjectSpawn(self.compContent.transform)
      item.name = tostring(v.id)
      local obj = self.compContent:AddComponent(UILWDominatorTrainPreviewCellBigComponent, item.name)
      obj:SetActive(true)
      obj:ReInit(v, v:IsFinalBigLevel(), i == 1)
    else
      local item = self.objSmallLockedCell.gameObject:GameObjectSpawn(self.compContent.transform)
      item.name = tostring(v.id)
      local obj = self.compContent:AddComponent(UILWDominatorTrainPreviewCellSmallLockedComponent, item.name)
      obj:SetActive(true)
      obj:ReInit(v, v:IsFinalBigLevel(), i == 1)
    end
  end
  local posY = 0
  local curBigLevel = self.curLevelTemplate:GetBigLevel()
  if 3 <= curBigLevel then
    posY = (curBigLevel - 3) * 200
    local viewHeight = self.scrollView.rectTransform.rect.height
    local contentHeight = self.compContent.rectTransform.rect.height
    if viewHeight < contentHeight then
      posY = math.min(posY, contentHeight - viewHeight)
    end
  end
  self.compContent.transform:Set_anchoredPosition(0, posY, 0)
end

function UILWDominatorTrainPreviewView:ClearCells()
  self.compContent:RemoveComponents(UILWDominatorTrainPreviewCellBigComponent)
  self.compContent:RemoveComponents(UILWDominatorTrainPreviewCellSmallComponent)
  self.compContent:RemoveComponents(UILWDominatorTrainPreviewCellSmallLockedComponent)
  self.objSmallCell.gameObject:GameObjectRecycleAll()
  self.objSmallLockedCell.gameObject:GameObjectRecycleAll()
  self.objBigCell.gameObject:GameObjectRecycleAll()
end

function UILWDominatorTrainPreviewView:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "panel/safeArea/TopBar/TextTitle")
  self.textTitle:SetText(Localization:GetString("dominator_train_grade_view_1"))
  self.scrollView = self:AddComponent(UIBaseContainer, "panel/safeArea/ScrollView")
  self.compContent = self:AddComponent(UIBaseContainer, "panel/safeArea/ScrollView/Viewport/Content")
  self.objSmallCell = self:AddComponent(UIBaseContainer, "panel/safeArea/UILWDominatorTrainPreviewCellSmall")
  self.objSmallCell.gameObject:GameObjectCreatePool()
  self.objSmallLockedCell = self:AddComponent(UIBaseContainer, "panel/safeArea/UILWDominatorTrainPreviewCellSmallLocked")
  self.objSmallLockedCell.gameObject:GameObjectCreatePool()
  self.objBigCell = self:AddComponent(UIBaseContainer, "panel/safeArea/UILWDominatorTrainPreviewCellBig")
  self.objBigCell.gameObject:GameObjectCreatePool()
  self.btnBackWhite = self:AddComponent(UIButton, "panel/BottomBg/BtnBackWhite")
  self.btnBackWhite:SetOnClick(function()
    self:OnBtnBackWhiteClick()
  end)
end

function UILWDominatorTrainPreviewView:ComponentDestroy()
  self:ClearCells()
  self.textTitle = nil
  self.btnBackWhite = nil
  self.compContent = nil
  self.objSmallCell = nil
  self.objBigCell = nil
  self.objSmallLockedCell = nil
  self.scrollView = nil
end

function UILWDominatorTrainPreviewView:DataDefine()
  self.itemCount = 0
end

function UILWDominatorTrainPreviewView:DataDestroy()
  self.itemCount = nil
end

function UILWDominatorTrainPreviewView:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorTrainPreviewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorTrainPreviewView:OnBtnBackWhiteClick()
  self.ctrl:CloseSelf()
end

return UILWDominatorTrainPreviewView
