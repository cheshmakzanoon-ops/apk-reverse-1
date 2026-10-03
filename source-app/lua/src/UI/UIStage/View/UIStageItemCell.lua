local UIStageItemCell = BaseClass("UIStageItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.lockImg = self:AddComponent(UIBaseContainer, "Img/Lock")
  self.currentImg = self:AddComponent(UIBaseContainer, "Img/Current")
  self.pass = self:AddComponent(UIBaseContainer, "Img/Pass")
  self.nameTxt = self:AddComponent(UIText, "Name/NameText")
  self.show_btn = self:AddComponent(UIButton, "")
  self.show_btn:SetOnClick(function()
    self:OnShowClick()
  end)
end

local function OnDestroy(self)
  self.lockImg = nil
  self.currentImg = nil
  self.pass = nil
  self.nameTxt = nil
  base.OnDestroy(self)
end

local function RefreshData(self, host, stageGroupMeta)
  self.stagePanel = host
  self.stageGroupMeta = stageGroupMeta
  self.nameTxt:SetText(Localization:GetString(stageGroupMeta.name))
  local curChapterId = host.ctrl.GetCurrentChapterId()
  if curChapterId == stageGroupMeta.chapter_group then
    local curStageGroupId = host.ctrl.GetCurrentStageGroupId()
    self.currentImg:SetActive(curStageGroupId == stageGroupMeta.id)
    self.lockImg:SetActive(curStageGroupId < stageGroupMeta.id)
    self.pass:SetActive(curStageGroupId > stageGroupMeta.id)
    self.unlock = curStageGroupId >= stageGroupMeta.id
  else
    self.currentImg:SetActive(false)
    self.lockImg:SetActive(curChapterId < stageGroupMeta.chapter_group)
    self.pass:SetActive(curChapterId > stageGroupMeta.chapter_group)
    self.unlock = curChapterId > stageGroupMeta.chapter_group
  end
end

local function OnShowClick(self)
  if self.unlock then
    self.stagePanel:ShowStageDetail(self)
  end
end

UIStageItemCell.OnCreate = OnCreate
UIStageItemCell.OnDestroy = OnDestroy
UIStageItemCell.RefreshData = RefreshData
UIStageItemCell.OnShowClick = OnShowClick
return UIStageItemCell
