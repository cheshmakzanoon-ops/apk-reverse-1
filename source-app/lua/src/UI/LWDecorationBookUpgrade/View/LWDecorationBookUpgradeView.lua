local UIBuildUpgradeView = require("UI.UIBuildUpgrade.View.UIBuildUpgradeView")
local LWDecorationBookUpgradeView = BaseClass("LWDecorationBookUpgradeView", UIBuildUpgradeView)
local base = UIBuildUpgradeView

function LWDecorationBookUpgradeView:OnCreate()
  base.OnCreate(self)
  self:MyRefreshView()
end

function LWDecorationBookUpgradeView:OnDestroy()
  base.OnDestroy(self)
end

function LWDecorationBookUpgradeView:MyRefreshView()
  base.DataDefine(self)
  local data = self:GetUserData()
  if not data.isShowShortCutKey then
    self.compShortcutKeyRoot:SetActive(false)
    return
  end
  self.baseBuildingIdList = data.baseBuildingIdList or {}
  self.curIndex = data.curIndex or 0
  self:RefreshShortcutKeyState()
  self:RefreshShortcutKeyRedPoint()
end

function LWDecorationBookUpgradeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorationViewLeftAndRightShortcutKey, self.OnShortcutKeyClick)
end

function LWDecorationBookUpgradeView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.DecorationViewLeftAndRightShortcutKey, self.OnShortcutKeyClick)
end

function LWDecorationBookUpgradeView:RefreshContentByShortcutKey()
  local baseBuildingId = self.baseBuildingIdList[self.curIndex]
  local hasBuilding = DataCenter.BuildManager:HasBuilding(baseBuildingId, true)
  local oneData = {}
  if hasBuilding then
    local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, true)
    oneData.buildUuid = buildData.uuid
    oneData.isShowShortCutKey = true
    oneData.hasBuilding = true
    oneData.baseBuildingIdList = self.baseBuildingIdList
    oneData.curIndex = self.curIndex
  else
    oneData.itemId = baseBuildingId
    oneData.level = 1
    oneData.max_level = 5
    oneData.type = Building_Upgrade_Type.DecorationBook
    oneData.isShowShortCutKey = true
    oneData.hasBuilding = false
    oneData.baseBuildingIdList = self.baseBuildingIdList
    oneData.curIndex = self.curIndex
  end
  self:RefreshViewByShortcutKey(oneData)
end

function LWDecorationBookUpgradeView:RefreshShortcutKeyState()
  self.btnLeftShortcutKey:SetActive(self.curIndex ~= 1)
  self.btnRightShortcutKey:SetActive(self.curIndex ~= #self.baseBuildingIdList)
end

function LWDecorationBookUpgradeView:RefreshShortcutKeyRedPoint()
  local leftCurIndex = math.max(self.curIndex - 1, 1)
  local leftBaseBuildingId = self.baseBuildingIdList[leftCurIndex]
  local isShowLeftRedPoint = self:IsShowRedPoint(leftBaseBuildingId)
  self.compLeftShortcutKeyRedPoint:SetActive(isShowLeftRedPoint)
  local rightCurIndex = math.min(self.curIndex + 1, #self.baseBuildingIdList)
  local rightBaseBuildingId = self.baseBuildingIdList[rightCurIndex]
  local isShowRightRedPoint = self:IsShowRedPoint(rightBaseBuildingId)
  self.compRightShortcutKeyRedPoint:SetActive(isShowRightRedPoint)
end

function LWDecorationBookUpgradeView:IsShowRedPoint(baseBuildingId)
  local hasBuilding = DataCenter.BuildManager:HasBuilding(baseBuildingId, true)
  if not hasBuilding then
    return false
  end
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, true)
  local buildDataExist = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, false)
  local isFoldUp = buildData.state == BuildingStateType.FoldUp and (buildDataExist == nil or buildData.level > buildDataExist.level)
  if isFoldUp then
    return true
  end
  local baseBuildData = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(baseBuildingId)
  local lvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  if not (lvTemplate and lvTemplate.decoGroupUpgradeBaseId) or lvTemplate.decoGroupUpgradeBaseId < 0 then
    return
  end
  local groupId = lvTemplate.decoGroupUpgradeBaseId
  local maxProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetMaxProgressInfo(groupId, buildData.level)
  if not maxProgressInfo then
    return
  end
  local curProgress = buildData.prodStatus or 0
  local curProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupId, buildData.level, curProgress)
  if not curProgressInfo then
    return
  end
  local isFoldUp = buildData.state == BuildingStateType.FoldUp
  local upgradeCost = toInt(curProgressInfo.cost_item) or 0
  local hasCount, needCount, needCountWithoutGlue
  hasCount, needCountWithoutGlue = DataCenter.BuildManager:IsCanUpgradeDecoration(buildData.itemId, buildData.level, false)
  if isFoldUp then
    return true
  elseif upgradeCost <= hasCount and buildData.level < baseBuildData.max_level then
    return true
  end
  return false
end

function LWDecorationBookUpgradeView:OnShortcutKeyClick(direction)
  if direction == 1 then
    self:OnBtnLeftShortcutKeyClick()
  elseif direction == 2 then
    self:OnBtnRightShortcutKeyClick()
  end
end

function LWDecorationBookUpgradeView:OnBtnLeftShortcutKeyClick()
  if table.IsNullOrEmpty(self.baseBuildingIdList) then
    return
  end
  self.curIndex = math.max(self.curIndex - 1, 1)
  self:RefreshShortcutKeyState()
  self:RefreshShortcutKeyRedPoint()
  self:RefreshContentByShortcutKey()
end

function LWDecorationBookUpgradeView:OnBtnRightShortcutKeyClick()
  if table.IsNullOrEmpty(self.baseBuildingIdList) then
    return
  end
  self.curIndex = math.min(self.curIndex + 1, #self.baseBuildingIdList)
  self:RefreshShortcutKeyState()
  self:RefreshShortcutKeyRedPoint()
  self:RefreshContentByShortcutKey()
end

return LWDecorationBookUpgradeView
