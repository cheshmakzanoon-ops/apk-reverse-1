local RecommendBuildCellComponent = BaseClass("RecommendBuildCellComponent", UIBaseContainer)
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local State = {
  Normal = 1,
  Upgrading = 2,
  Finish = 3,
  CanUpgrate = 4
}

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
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnBuildBg = self:AddComponent(UIButton, "buildBg")
  self.btnBuildBg:SetOnClick(function()
    self:OnClickBuild()
  end)
  self.imgBuildIcon = self:AddComponent(UIImage, "buildBg/buildIcon")
  self.textBuildName = self:AddComponent(UICommonHorseLampTMP, "buildBg/buildName")
  self.textLv = self:AddComponent(UITextMeshProUGUIEx, "buildBg/textLv")
  self.imgRecommand = self:AddComponent(UIImage, "buildBg/imgRecommand")
  self.imgUp = self:AddComponent(UIImage, "buildBg/imgUp")
  self.imgCover = self:AddComponent(UIImage, "buildBg/cover")
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "buildBg/time/textTime")
  self.compTime = self:AddComponent(UIBaseContainer, "buildBg/time")
  self.anim = self:AddComponent(UIAnimator, "")
  if self.anim then
    self.anim:Enable(false)
  end
end

function RecommendBuildCellComponent:OnClickBuild()
  if self.imgRecommand.gameObject.activeSelf then
    PostEventLog.Track(PostEventLog.Defines.RecommendClickZan)
  end
  if self.state == State.CanUpgrate then
    PostEventLog.Track(PostEventLog.Defines.RecommendClickLevelUp)
    GoToUtil.GotoCityByBuildUuid(self.buildData.uuid, WorldTileBtnType.City_Upgrade, true)
  elseif self.state == State.Upgrading then
    PostEventLog.Track(PostEventLog.Defines.RecommendClickUpgrade)
    GoToUtil.GotoCityByBuildUuid(self.buildData.uuid, WorldTileBtnType.City_SpeedUp, true)
  else
    if self.state == State.Finish then
      PostEventLog.Track(PostEventLog.Defines.RecommendClickGift)
    elseif self.state == State.Normal then
      PostEventLog.Track(PostEventLog.Defines.RecommendClickNormal)
    end
    GoToUtil.CloseAllWindows()
    local pos = SceneUtils.TileIndexToWorld(self.buildData.pointId, ForceChangeScene.City)
    GoToUtil.GotoPos(pos, CS.SceneManager.World.InitZoom, 0.2, function()
      WorldArrowManager:GetInstance():ShowArrowEffect(0, self.buildData:GetCenterVec() + Vector3.New(0, 5, 0), ArrowType.Building)
    end)
  end
end

local function ComponentDestroy(self)
  self.imgBuildIcon = nil
  self.textBuildName = nil
  self.textLv = nil
  self.imgRecommand = nil
  self.imgUp = nil
  self.imgCover = nil
  self.textTime = nil
  self.compTime = nil
  self.anim = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function RecommendBuildCellComponent:OnSetData(buildData, recommendList)
  self.buildData = buildData
  self.recommendList = recommendList
  self.imgCover:SetActive(false)
  self.compTime:SetActive(false)
  self.imgUp:SetActive(false)
  local recommend = self:CheckRecommand()
  if recommend and (not recommendList[buildData.itemId] or recommendList[buildData.itemId].lv < buildData.level) then
    recommend = true
    if recommendList[buildData.itemId] then
      recommendList[buildData.itemId].comp.imgRecommand:SetActive(false)
    end
    recommendList[buildData.itemId] = {
      lv = buildData.level,
      comp = self
    }
    self.imgRecommand:SetActive(true)
  else
    self.imgRecommand:SetActive(false)
  end
  if buildData:IsUpgradeFinish() then
    self.state = State.Finish
    self.imgCover:SetActive(true)
  elseif buildData:IsUpgrading() then
    self.state = State.Upgrading
    self.compTime:SetActive(true)
    self.timer = TimerManager:GetInstance():GetTimer(1, function()
      self:UpdateTime()
    end, self, false, false, true)
    self.timer:Start()
    self.originalEndTime = self.buildData.updateTime
    self.endTime = self.buildData.updateTime
    self.startTime = self.buildData.startTime
    self:UpdateTime()
  else
    local canUp = self:CheckCanUp(buildData)
    self.state = canUp and State.CanUpgrate or State.Normal
    self.imgUp:SetActive(canUp)
  end
  local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildData.itemId, self.buildData.level)
  self.textBuildName:SetLocalTextWithLength(template.name, 175)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildData.itemId)
  if buildTemplate.max_level == self.buildData.level or not template:IsTimeConditionValid() then
    self.textLv:SetLocalText("newbies_buildinglist_rank_desc7")
  else
    self.textLv:SetText("Lv." .. self.buildData.level)
    if buildData.itemId == BuildingTypes.FUN_BUILD_MAIN then
      self.imgRecommand:SetActive(DataCenter.BuildManager.MainLv >= 8 and DataCenter.BuildManager.MainLv <= 30)
    end
  end
  self.imgBuildIcon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(buildData.itemId, buildData.level))
end

function RecommendBuildCellComponent:UpdateTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.startTime then
    self.startTime = curTime
  end
  local changeTime = self.endTime - curTime
  if changeTime <= 0 then
    self.timer:Stop()
    self.timer = nil
    self:OnSetData(self.buildData, self.recommendList)
    return
  end
  self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(changeTime))
end

function RecommendBuildCellComponent:CheckCanUp(buildData)
  local level = buildData.level
  local buildId = buildData.itemId
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil and level < buildTemplate.max_level then
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    if buildLevelTemplate ~= nil then
      if not buildLevelTemplate:IsPreBuildConditionValid() then
        return false
      end
      if not buildLevelTemplate:IsTimeConditionValid() then
        return false
      end
      if not ignore then
        local ret = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(buildData.uuid)
        if not ret.enough then
          return false
        end
      end
      return true
    end
  end
end

function RecommendBuildCellComponent:CheckRecommand()
  if not self.buildData:IsTheHighestLevel() then
    return false
  end
  return self.buildData:CheckRecommend()
end

RecommendBuildCellComponent.OnCreate = OnCreate
RecommendBuildCellComponent.OnDestroy = OnDestroy
RecommendBuildCellComponent.OnEnable = OnEnable
RecommendBuildCellComponent.OnDisable = OnDisable
RecommendBuildCellComponent.ComponentDefine = ComponentDefine
RecommendBuildCellComponent.ComponentDestroy = ComponentDestroy
RecommendBuildCellComponent.DataDefine = DataDefine
RecommendBuildCellComponent.DataDestroy = DataDestroy
RecommendBuildCellComponent.OnAddListener = OnAddListener
RecommendBuildCellComponent.OnRemoveListener = OnRemoveListener
return RecommendBuildCellComponent
