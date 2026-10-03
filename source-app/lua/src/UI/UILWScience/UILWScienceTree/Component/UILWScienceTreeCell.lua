local UILWScienceCell = BaseClass("UILWScienceCell", UIBaseContainer)
local base = UIBaseContainer
local string_IsNullOrEmpty = string.IsNullOrEmpty
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  scienceId,
  isReaching
}
local icon_path = "ScienceBg/ScienceIcon"
local btn_path = "ScienceBg"
local specialBg_path = "specialBg"
local slider_bg_path = "ScienceBg/SliderBg"
local slider_text_path = "ScienceBg/SliderBg/SliderText"
local level_text_path = "ScienceBg/LevelText"
local max_text_path = "ScienceBg/maxText"
local researching_frame_path = "ScienceBg/ResearchingFrame"
local commend1_path = "commend1"
local commend2_path = "commend2"
local PositionDelta = 86
local FinishedTextStr

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.slider_bg = self:AddComponent(UIBaseContainer, slider_bg_path)
  self.slider_text = self:AddComponent(UIText, slider_text_path)
  self.level_text = self:AddComponent(UIText, level_text_path)
  self.maxLvText = self:AddComponent(UIBaseContainer, max_text_path)
  self.scienceNumberIcon = self:AddComponent(UIImage, "ScienceBg/SliderBg/scienceIcon")
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    EventManager:GetInstance():Broadcast(EventId.StopSvAutoToCell)
    self:OnBtnClick()
  end)
  self.specialBg = self:AddComponent(UIBaseContainer, specialBg_path)
  self.researchingFrameGo = self:AddComponent(UIBaseContainer, researching_frame_path)
  self.anim = self:AddComponent(UISimpleAnimation, "")
  self.commend1 = self:AddComponent(UIImage, commend1_path)
  self.commend2 = self:AddComponent(UIImage, commend2_path)
  self.compSpecialBgFront = self:AddComponent(UIBaseContainer, "ScienceBg/specialBgFront")
  self.compMasterBg = self:AddComponent(UIBaseContainer, "masterBg")
  self.compVfxNode = self:AddComponent(UIVfx, "ScienceBg/vfxNode")
end

local function ComponentDestroy(self)
  self.icon = nil
  self.btn = nil
  self.specialBg = nil
  self.slider_bg = nil
  self.slider_text = nil
  self.level_text = nil
  self.maxLvText = nil
  self.researchingFrameGo = nil
  self.scienceNumberIcon = nil
  self.anim = false
  self.commend1 = nil
  self.commend2 = nil
  self.compSpecialBgFront = nil
  self.compMasterBg = nil
  self.compVfxNode = nil
end

local function DataDefine(self)
  self.param = {}
  self.template = nil
end

local function DataDestroy(self)
  self.param = nil
  self.template = nil
end

local function ResetResearchState(self, isResearching, isResetRefreshState)
  self.isRefreshResearchState = isResetRefreshState
  self.param.isReaching = isResearching
  self:RefreshUI()
end

local function ReInit(self, param)
  self.param = param
  self:RefreshUI()
end

function UILWScienceCell:LoadTeamNumerIcon()
  local queue = DataCenter.ScienceManager:GetScienceQueueByScienceId(tostring(self.param.scienceId))
  if queue then
    local data = DataCenter.BuildManager:GetBuildingDataByUuid(tonumber(queue.funcUuid))
    local path
    if data.itemId == BuildingTypes.LW_BUILE_SCIENCE_TWO then
      path = "Assets/Main/Sprites/UI/UILWScience/od_2stqianzhui.png"
    elseif data.itemId == BuildingTypes.FUN_BUILD_SCIENE then
      path = "Assets/Main/Sprites/UI/UILWScience/od_1stqianzhui.png"
    elseif data.itemId == BuildingTypes.LW_BUILE_SCIENCE_THREE then
      path = "Assets/Main/Sprites/UI/UILWScience/od_3stqianzhui.png"
    end
    if path then
      self.scienceNumberIcon:LoadSprite(path)
    else
      self.scienceNumberIcon:SetActive(false)
    end
  end
end

local function RefreshUI(self)
  self.template = DataCenter.ScienceManager:GetScienceTemplate(self.param.scienceId)
  UIGray.SetGrayWithIgnore(self.btn.transform, false, "specialBg")
  self.specialBg:SetActive(false)
  self.compSpecialBgFront:SetActive(false)
  self.compMasterBg:SetActive(false)
  self.level_text:SetActive(true)
  self.maxLvText:SetActive(false)
  if self.template ~= nil then
    self.icon:LoadSprite(string.format(LoadPath.UILWScience, self.template.icon))
    self.specialBg:SetActive(self.template.is_special == 1)
    self.compSpecialBgFront:SetActive(self.template.is_special == 1)
    self.compMasterBg:SetActive(self.template.is_special == 2)
    if self.template.is_special == 1 then
      self.compVfxNode:PlayByStay(VfxAssets.ScienceTreeItemSpecialBg1)
    elseif self.template.is_special == 2 then
      self.compVfxNode:PlayByStay(VfxAssets.ScienceTreeItemSpecialBg2)
    end
    local curLevel = DataCenter.ScienceManager:GetScienceLevel(self.param.scienceId)
    local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(self.param.scienceId)
    local isAlCompeteOpen = DataCenter.ActivityListDataManager:CheckIfAlCompeteActivityOpen()
    if self.template.inactivity and self.template.inactivity == 1 and not isAlCompeteOpen then
      UIGray.SetGrayWithIgnore(self.btn.transform, true, "specialBgFront")
      self.level_text:SetActive(true)
      self.level_text:SetText(curLevel .. "/" .. maxLevel)
      self.maxLvText:SetActive(false)
    elseif curLevel >= maxLevel then
      self.level_text:SetActive(false)
      self.maxLvText:SetActive(true)
    elseif self:IsUnLockScience() then
      self.level_text:SetActive(true)
      self.level_text:SetText(curLevel .. "/" .. maxLevel)
      self.maxLvText:SetActive(false)
    else
      UIGray.SetGrayWithIgnore(self.btn.transform, true, "specialBgFront")
      self.level_text:SetActive(true)
      self.level_text:SetText(curLevel .. "/" .. maxLevel)
      self.maxLvText:SetActive(false)
    end
    self:LoadTeamNumerIcon()
    local isReaching = self.param.isReaching
    self.slider_bg:SetActive(isReaching)
    self.researchingFrameGo:SetActive(isReaching)
    local queue = DataCenter.ScienceManager:GetScienceQueueByScienceId(tostring(self.param.scienceId))
    if queue and queue:GetQueueState() == NewQueueState.Finish then
      self:SetSliderValue(1)
      if string_IsNullOrEmpty(FinishedTextStr) then
        FinishedTextStr = CS.GameEntry.Localization:GetString("research_finish")
      end
      self:SetSliderText(FinishedTextStr)
    end
    local showRecommend1Data, showRecommend2Data = DataCenter.ScienceRecommendManager:GetRecommendScience()
    if showRecommend1Data and showRecommend1Data.science_id == self.template.science_id then
      self.commend1:SetActive(true)
      self.commend2:SetActive(false)
    elseif showRecommend2Data and showRecommend2Data.science_id == self.template.science_id then
      self.commend1:SetActive(false)
      self.commend2:SetActive(true)
    else
      self.commend1:SetActive(false)
      self.commend2:SetActive(false)
    end
  end
end

local function OnBtnClick(self)
  local isAlCompeteOpen = DataCenter.ActivityListDataManager:CheckIfAlCompeteActivityOpen()
  if self.template.inactivity and self.template.inactivity == 1 and not isAlCompeteOpen then
    UIUtil.ShowTipsId(200521)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceDetail, {anim = true}, self.param.scienceId, self.view.bUuid)
  end
end

local function IsUnLockScience(self)
  local needScience = self.template.needScience
  if needScience ~= nil then
    for k, v in ipairs(needScience) do
      if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v.scienceId, v.level) then
        return false
      end
    end
  end
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.bUuid)
  if buildingData ~= nil then
    local needBuild = self.template.needBuild
    if needBuild ~= nil then
      for k, v in ipairs(needBuild) do
        if not DataCenter.BuildManager:HasBuildByIdAndLevel(buildingData.itemId, v.level) then
          return false
        end
      end
    end
  end
  return true
end

local function SetSliderValue(self, value)
end

local function SetSliderText(self, value)
  self.slider_text:SetText(value)
end

local function GetLineCenterPosition(self, isUp)
  local x, y = self.transform:Get_lossyScale()
  local lossyScale = y
  if lossyScale <= 0 then
    lossyScale = 1
  end
  local x, y, z = self.transform.position.x, self.transform.position.y, self.transform.position.z
  local result = Vector3.New(x, y, z)
  if isUp then
    result.y = result.y + PositionDelta * lossyScale
  else
    result.y = result.y - PositionDelta * lossyScale
  end
  return result
end

local function GetGuideBtn(self)
  return self.btn.gameObject
end

local function ShowSelect(self)
  if self.anim then
    self.anim:Play("Select")
  end
end

local function IsRefreshResearchState(self)
  if not self.isRefreshResearchState then
    self.isRefreshResearchState = true
  end
  return not self.isRefreshResearchState
end

UILWScienceCell.OnCreate = OnCreate
UILWScienceCell.OnDestroy = OnDestroy
UILWScienceCell.Param = Param
UILWScienceCell.OnEnable = OnEnable
UILWScienceCell.OnDisable = OnDisable
UILWScienceCell.ComponentDefine = ComponentDefine
UILWScienceCell.ComponentDestroy = ComponentDestroy
UILWScienceCell.DataDefine = DataDefine
UILWScienceCell.DataDestroy = DataDestroy
UILWScienceCell.ReInit = ReInit
UILWScienceCell.OnBtnClick = OnBtnClick
UILWScienceCell.IsUnLockScience = IsUnLockScience
UILWScienceCell.SetSliderText = SetSliderText
UILWScienceCell.SetSliderValue = SetSliderValue
UILWScienceCell.GetLineCenterPosition = GetLineCenterPosition
UILWScienceCell.ResetResearchState = ResetResearchState
UILWScienceCell.RefreshUI = RefreshUI
UILWScienceCell.GetGuideBtn = GetGuideBtn
UILWScienceCell.ShowSelect = ShowSelect
UILWScienceCell.IsRefreshResearchState = IsRefreshResearchState
return UILWScienceCell
