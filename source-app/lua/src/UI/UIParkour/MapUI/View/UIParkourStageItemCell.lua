local UIParkourStageItemCell = BaseClass("UIParkourStageItemCell", UIBaseContainer)
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

local function RefreshData(self, host, stageFeatureMeta)
  self.stagePanel = host
  self.stageFeatureMeta = stageFeatureMeta
  self.nameTxt:SetText(Localization:GetString(stageFeatureMeta.name, stageFeatureMeta.order))
  local curStageGroupId = host.ctrl.GetCurrentStageId()
  local passId = DataCenter.ParkourManager.passStageId
  local alreadyPass = passId >= stageFeatureMeta.id
  local isCurrent = stageFeatureMeta.id == curStageGroupId and not alreadyPass
  local isLock = not alreadyPass and not isCurrent
  self.currentImg:SetActive(isCurrent)
  self.lockImg:SetActive(isLock)
  self.pass:SetActive(alreadyPass)
  self.unlock = true
end

local function OnShowClick(self)
  local param = {}
  param.type = PVEType.Parkour
  param.levelId = self.stageFeatureMeta.id
  DataCenter.LWBattleManager:Enter(param)
end

UIParkourStageItemCell.OnCreate = OnCreate
UIParkourStageItemCell.OnDestroy = OnDestroy
UIParkourStageItemCell.RefreshData = RefreshData
UIParkourStageItemCell.OnShowClick = OnShowClick
return UIParkourStageItemCell
