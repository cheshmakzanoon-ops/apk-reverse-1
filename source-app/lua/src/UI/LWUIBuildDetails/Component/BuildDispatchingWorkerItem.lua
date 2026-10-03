local BuildDispatchingWorkerItem = BaseClass("BuildDispatchingWorkerItem", UIBaseContainer)
local base = UIBaseContainer
local UIWorkerShowCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerShowCell")
local testLockText = "Level %s unLocking"
local effectShowNum = 3

function BuildDispatchingWorkerItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function BuildDispatchingWorkerItem:DataDefine()
  self.param = nil
end

function BuildDispatchingWorkerItem:ComponentDefine()
  self.workerInfo = self:AddComponent(UIBaseContainer, "panel/workerInfo")
  self.workerName = self:AddComponent(UIText, "panel/workerInfo/text_name")
  self.uiWorkerShowCell = self:AddComponent(UIWorkerShowCell, "panel/workerInfo/UIWorkerShowCell")
  self.NoWorker = self:AddComponent(UIBaseContainer, "panel/NoWorker")
  self.noWrkerText = self:AddComponent(UIText, "panel/NoWorker/noWrkerText")
  self.lockIcon = self:AddComponent(UIImage, "panel/NoWorker/lockIcon")
  self.redDotIcon = self:AddComponent(UIImage, "panel/redDot")
  self.addIcon = self:AddComponent(UIImage, "panel/NoWorker/addIcon")
  self.bgBtn = self:AddComponent(UIButton, "panel/btn_BG")
  self.effectItems = {}
  for i = 1, effectShowNum do
    local itemRoot = self:AddComponent(UIBaseContainer, "panel/workerInfo/EffectContent/effect" .. i)
    self.effectItems[i] = {
      root = itemRoot,
      effectText = itemRoot:AddComponent(UIText, "effectText"),
      effectValueText = itemRoot:AddComponent(UIText, "effectValueText")
    }
  end
end

function BuildDispatchingWorkerItem:ReInit(param)
  self.param = param
  self.workerInfo:SetActive(param.type == BuildDisPatchingHeroTrenchState.HERO)
  self.NoWorker:SetActive(param.type ~= BuildDisPatchingHeroTrenchState.HERO)
  self.lockIcon:SetActive(param.type == BuildDisPatchingHeroTrenchState.LOCK)
  self.addIcon:SetActive(param.type == BuildDisPatchingHeroTrenchState.ADD)
  if param.type == BuildDisPatchingHeroTrenchState.HERO then
    self:ShowHeroInfo()
  elseif param.type == BuildDisPatchingHeroTrenchState.ADD then
    self.bgBtn:SetOnClick(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildHeroList, self.param.curBuildIndex, self.param.index - 1)
    end)
    self.noWrkerText:SetText("")
  elseif param.type == BuildDisPatchingHeroTrenchState.LOCK then
    self.bgBtn:SetOnClick(function()
    end)
    self.noWrkerText:SetActive(true)
    self.noWrkerText:SetLocalText(135203, self.param.lockLevel)
  end
  self:BuildRefreshRedDot()
end

function BuildDispatchingWorkerItem:BuildRefreshRedDot()
  local workerDataList = DataCenter.WorkerDataManager:GetAvailableWorkersByBuildItemId(self.param.curBuildData.itemId)
  local isOn = false
  if self.param.curBuildData:GetIsVacancyWorker() and 0 < #workerDataList and self.param.type == BuildDisPatchingHeroTrenchState.ADD then
    isOn = true
  end
  if self.param.type == BuildDisPatchingHeroTrenchState.HERO and not self.param.curBuildData:GetIsVacancyWorker() then
    local isHighQuality = false
    for i = 1, #workerDataList do
      if workerDataList[i].quality > self.param.workerData.quality then
        isHighQuality = true
        break
      end
    end
    isOn = isHighQuality
  end
  self.redDotIcon:SetActive(isOn)
end

function BuildDispatchingWorkerItem:ShowHeroInfo()
  self.workerName:SetText(self.param.workerData:GetName())
  self.bgBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildHeroList, self.param.curBuildIndex, self.param.index - 1)
  end)
  self.uiWorkerShowCell:SetData(self.param.workerData.cfgId, self.param.workerData.rank)
  for i = 1, effectShowNum do
    local effectItem = self.effectItems[i]
    effectItem.root:SetActive(false)
  end
  local effectItemIndex = 1
  for effectId, effectValue in pairs(self.param.workerData.effectDict) do
    if 0 < effectValue then
      local describe, text = WorkerUtil.GetEffectText(effectId, effectValue, true)
      if effectItemIndex <= effectShowNum then
        local effectItem = self.effectItems[effectItemIndex]
        effectItem.root:SetActive(true)
        effectItem.effectValueText:SetText(text)
        effectItem.effectText:SetText(describe)
        effectItemIndex = effectItemIndex + 1
      end
    end
  end
end

function BuildDispatchingWorkerItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BuildDispatchingWorkerItem:DataDestroy()
  self.param = nil
end

function BuildDispatchingWorkerItem:ComponentDestroy()
  self.workerInfo = nil
  self.workerName = nil
  self.uiWorkerShowCell = nil
  self.NoWorker = nil
  self.noWrkerText = nil
  self.lockIcon = nil
  self.addIcon = nil
  self.bgBtn = nil
  self.effectItems = nil
end

return BuildDispatchingWorkerItem
