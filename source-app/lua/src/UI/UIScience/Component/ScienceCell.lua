local ScienceCell = BaseClass("ScienceCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  scienceId,
  isReaching
}
local icon_path = "ScienceBg/ScienceIcon"
local name_path = "ScienceBg/layout/ScienceName"
local btn_path = "ScienceBg"
local slider_path = "ScienceBg/layout/Slider"
local slider_text_path = "ScienceBg/layout/Slider/SliderText"
local level_text_path = "ScienceBg/LevelText"
local max_text_path = "ScienceBg/maxText"
local lock_path = "ScienceBg/Lock"
local level_text_bg_path = "ScienceBg/LevelText_BG"
local PositionDelta = 172

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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.name = self:AddComponent(UIText, name_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_text = self:AddComponent(UIText, slider_text_path)
  self.level_text = self:AddComponent(UIText, level_text_path)
  self.maxLvText = self:AddComponent(UIText, max_text_path)
  self.lock = self:AddComponent(UIBaseContainer, lock_path)
  self.level_text_bg = self:AddComponent(UIImage, level_text_bg_path)
  self.bg_icon = self:AddComponent(UIImage, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    EventManager:GetInstance():Broadcast(EventId.StopSvAutoToCell)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.btn = nil
  self.name = nil
  self.slider = nil
  self.slider_text = nil
  self.level_text = nil
  self.maxLvText = nil
  self.bg_icon = nil
  self.lock = nil
  self.level_text_bg = nil
end

local function DataDefine(self)
  self.param = {}
  self.template = nil
end

local function DataDestroy(self)
  self.param = nil
  self.template = nil
end

local function ResetResearchState(self, isResearching)
  self.param.isReaching = isResearching
  self:RefreshUI()
end

local function ReInit(self, param)
  self.param = param
  self:RefreshUI()
end

local function RefreshUI(self)
  self.template = DataCenter.ScienceManager:GetScienceTemplate(self.param.scienceId)
  self.lock:SetActive(false)
  self.level_text_bg:SetActive(true)
  self.level_text:SetActive(true)
  self.maxLvText:SetActive(false)
  if self.template ~= nil then
    self.name:SetLocalText(self.template.name)
    self.icon:LoadSprite(string.format(LoadPath.ScienceIcons, self.template.icon))
    local curLevel = DataCenter.ScienceManager:GetScienceLevel(self.param.scienceId)
    local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(self.param.scienceId)
    local isAlCompeteOpen = DataCenter.ActivityListDataManager:CheckIfAlCompeteActivityOpen()
    if self.template.inactivity and self.template.inactivity == 1 and not isAlCompeteOpen then
      self.lock:SetActive(true)
      self.level_text_bg:SetActive(false)
      self.level_text:SetActive(false)
      self.maxLvText:SetActive(false)
    elseif curLevel >= maxLevel then
      self.level_text:SetActive(false)
      self.level_text_bg:SetActive(false)
      self.maxLvText:SetActive(true)
    elseif self:IsUnLockScience() then
      self.level_text:SetActive(true)
      self.level_text:SetText(curLevel .. "/" .. maxLevel)
      self.level_text_bg:SetActive(true)
      self.maxLvText:SetActive(false)
    else
      self.lock:SetActive(true)
      self.level_text_bg:SetActive(false)
      self.level_text:SetActive(false)
      self.maxLvText:SetActive(false)
    end
    self.slider:SetActive(self.param.isReaching)
    if self.param.isReaching then
    else
    end
  end
end

local function OnBtnClick(self)
  local isAlCompeteOpen = DataCenter.ActivityListDataManager:CheckIfAlCompeteActivityOpen()
  if self.template.inactivity and self.template.inactivity == 1 and not isAlCompeteOpen then
    UIUtil.ShowTipsId(200521)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIScienceInfo, {anim = true}, self.param.scienceId, self.view.bUuid)
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
  self.slider:SetValue(value)
end

local function SetSliderText(self, value)
  self.slider_text:SetText(value)
end

local function GetLineCenterPosition(self, isLeft)
  local x, y = self.transform:Get_lossyScale()
  local lossyScale = y
  if lossyScale <= 0 then
    lossyScale = 1
  end
  local x, y, z = self.transform.position.x, self.transform.position.y, self.transform.position.z
  local result = Vector3.New(x, y, z)
  if isLeft then
    result.x = result.x - PositionDelta * lossyScale
  else
    result.x = result.x + PositionDelta * lossyScale
  end
  return result
end

local function GetGuideBtn(self)
  return self.btn.gameObject
end

ScienceCell.OnCreate = OnCreate
ScienceCell.OnDestroy = OnDestroy
ScienceCell.Param = Param
ScienceCell.OnEnable = OnEnable
ScienceCell.OnDisable = OnDisable
ScienceCell.ComponentDefine = ComponentDefine
ScienceCell.ComponentDestroy = ComponentDestroy
ScienceCell.DataDefine = DataDefine
ScienceCell.DataDestroy = DataDestroy
ScienceCell.ReInit = ReInit
ScienceCell.OnBtnClick = OnBtnClick
ScienceCell.IsUnLockScience = IsUnLockScience
ScienceCell.SetSliderText = SetSliderText
ScienceCell.SetSliderValue = SetSliderValue
ScienceCell.GetLineCenterPosition = GetLineCenterPosition
ScienceCell.ResetResearchState = ResetResearchState
ScienceCell.RefreshUI = RefreshUI
ScienceCell.GetGuideBtn = GetGuideBtn
return ScienceCell
