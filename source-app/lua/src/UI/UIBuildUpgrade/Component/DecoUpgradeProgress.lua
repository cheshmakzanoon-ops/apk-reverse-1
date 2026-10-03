local DecoUpgradeProgress = BaseClass("DecoUpgradeProgress", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local StarItem = require("UI.UIBuildUpgrade.Component.DecoUpgradeStar")
local STAR_PREFAB_PATH = "Assets/Main/Prefabs/UI/UIBuildUpgrade/StarInfoItem.prefab"
local start_root_path = "StartRoot"
local exp_progress_slider_path = "ExpProgressSlider"
local progress_text_path = "progressText"
local eff_ui_dominator_saoguang_path = "Eff_ui_Dominator_saoguang"
local max_img_path = "MaxImg"
local exp_progress_preview_slider_path = "ExpProgressSlider/ExpProgressPreviewSlider"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.levelUpgradeEffObj then
    self.levelUpgradeEffObj:SetActive(false)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.starRoot = self:AddComponent(UIBaseContainer, start_root_path)
  self.progressSlider = self:AddComponent(UISlider, exp_progress_slider_path)
  self.progressText = self:AddComponent(UIText, progress_text_path)
  self.progressTotalWidth = self.starRoot:GetSizeDelta().x
  self.levelUpgradeEffObj = self:AddComponent(UIBaseContainer, eff_ui_dominator_saoguang_path)
  self.maxImgObj = self:AddComponent(UIBaseContainer, max_img_path)
  self.progressPreviewSlider = self:AddComponent(UISlider, exp_progress_preview_slider_path)
end

local function ComponentDestroy(self)
  self:ClearAllStar()
end

local function DataDefine(self)
  self.starCellList = {}
  self.hideLvUpEffTimer = nil
  if self.hideLvUpEffTimer then
    self.hideLvUpEffTimer:Stop()
    self.hideLvUpEffTimer = nil
  end
end

local function DataDestroy(self)
  self.starCellList = nil
  self.hideLvUpEffTimer = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function DecoUpgradeProgress:SetData(param)
  local buildingLv = param.buildingLv
  local groupId = param.groupId
  local curProgress = param.curProgress
  local stageMaxProgress = param.stageMaxProgress
  local previewProgress = param.previewProgress
  local showUnlockStarTipFun = param.showUnlockStarTipFun
  local isMaxLv = param.isMaxLv
  local refreshFromUpgrade = param.refreshFromUpgrade
  self.curProgress = curProgress
  self.stageMaxProgress = stageMaxProgress
  self.previewProgress = previewProgress
  self.progressInfoList = DataCenter.DecorationUpgradeTemplateManager:GetLvInfo(groupId, buildingLv)
  self.maxProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetMaxProgressInfo(groupId, buildingLv)
  self.showUnlockStarTipFun = showUnlockStarTipFun
  self.maxProgress = 1
  if self.maxProgressInfo then
    self.maxProgress = self.maxProgressInfo.stage_need
  end
  self.maxImgObj:SetActive(isMaxLv)
  self.progressText:SetActive(not isMaxLv)
  self:RefreshBaseView()
  self:GenStar(refreshFromUpgrade)
end

function DecoUpgradeProgress:RefreshBaseView()
  if not CommonUtil.IsArabicAutoMirrorOpen() then
    self.progressText:SetText(string.format("%s/%s", self.curProgress, self.maxProgress))
  else
    self.progressText:SetText(string.format("%s/%s", self.maxProgress, self.curProgress))
  end
  self.progressSlider.unity_uislider.maxValue = self.maxProgress
  self.progressPreviewSlider.unity_uislider.maxValue = self.maxProgress
  self.progressSlider:SetValue(self.curProgress)
  if self.previewProgress <= self.curProgress then
    self.progressPreviewSlider.gameObject:SetActive(false)
  else
    self.progressPreviewSlider.gameObject:SetActive(true)
    self.progressPreviewSlider:SetValue(self.previewProgress)
  end
end

function DecoUpgradeProgress:GenStar(refreshFromUpgrade)
  for i, v in ipairs(self.progressInfoList) do
    local progressData = v
    local star = self.starCellList[i]
    if star and star.model then
      star.model:SetData(progressData, self.maxProgressInfo, self.curProgress, self.progressTotalWidth, self.showUnlockStarTipFun, refreshFromUpgrade)
    else
      do
        local starCell = {}
        starCell.inst = self:GameObjectInstantiateAsync(STAR_PREFAB_PATH, function(req)
          if req.isError then
            return
          end
          local obj = req.gameObject
          obj.transform:SetParent(self.starRoot.transform)
          obj.transform:Set_localScale(1, 1, 1)
          local nameStr = tostring(NameCount)
          NameCount = NameCount + 1
          obj.name = nameStr
          star = self.starRoot:AddComponent(StarItem, nameStr)
          star:SetData(progressData, self.maxProgressInfo, self.curProgress, self.progressTotalWidth, self.showUnlockStarTipFun, refreshFromUpgrade)
          starCell.model = star
        end)
        table.insert(self.starCellList, starCell)
      end
    end
  end
end

function DecoUpgradeProgress:ClearAllStar()
  if self.starCellList and #self.starCellList > 0 then
    for _, v in ipairs(self.starCellList) do
      if v.inst then
        v.inst:Destroy()
      end
    end
    self.starCellList = {}
    self.starRoot:RemoveAllComponentes(StarItem)
  end
end

function DecoUpgradeProgress:ShowUpgradeEff()
  if self.hideLvUpEffTimer ~= nil then
    return
  end
  Logger.LogInfo("[deco]start show eff")
  self.levelUpgradeEffObj:SetActive(false)
  self.levelUpgradeEffObj:SetActive(true)
  self.hideLvUpEffTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.levelUpgradeEffObj:SetActive(false)
    self.hideLvUpEffTimer = nil
  end, 1)
end

DecoUpgradeProgress.OnCreate = OnCreate
DecoUpgradeProgress.OnDestroy = OnDestroy
DecoUpgradeProgress.OnEnable = OnEnable
DecoUpgradeProgress.OnDisable = OnDisable
DecoUpgradeProgress.ComponentDefine = ComponentDefine
DecoUpgradeProgress.ComponentDestroy = ComponentDestroy
DecoUpgradeProgress.DataDefine = DataDefine
DecoUpgradeProgress.DataDestroy = DataDestroy
DecoUpgradeProgress.OnAddListener = OnAddListener
DecoUpgradeProgress.OnRemoveListener = OnRemoveListener
return DecoUpgradeProgress
