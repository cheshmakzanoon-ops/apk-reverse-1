local UIFeatureIntegratedDifficultyTab = BaseClass("UIFeatureIntegratedDifficultyTab", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.onClick = nil
end

local function ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.selectBg = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.titleText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.completedText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.btn = nil
  self.selectBg = nil
  self.titleText = nil
  self.completedText = nil
end

local function SetDifficulty(self, difficulty)
  self.difficulty = difficulty
end

local function Refresh(self)
  local isUnlock = DataCenter.LWIntegratedStageFeatureChapterManager:IsDifficultyUnlocked(self.difficulty)
  if isUnlock then
    local isAllDone = DataCenter.LWIntegratedStageFeatureChapterManager:IsAllDoneByDiff(self.difficulty)
    if isAllDone then
      self.completedText:SetLocalText("frontline_unity_type_01")
    else
      self.completedText:SetLocalText("frontline_unity_type_02")
    end
  else
    self.completedText:SetLocalText("frontline_unity_type_03")
  end
end

local function OnBtnClick(self)
  if self.onClick then
    self.onClick()
  end
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function SetSelect(self, isSelect)
  self.selectBg:SetActive(isSelect)
end

UIFeatureIntegratedDifficultyTab.OnCreate = OnCreate
UIFeatureIntegratedDifficultyTab.OnDestroy = OnDestroy
UIFeatureIntegratedDifficultyTab.Refresh = Refresh
UIFeatureIntegratedDifficultyTab.OnBtnClick = OnBtnClick
UIFeatureIntegratedDifficultyTab.SetOnClick = SetOnClick
UIFeatureIntegratedDifficultyTab.SetDifficulty = SetDifficulty
UIFeatureIntegratedDifficultyTab.SetSelect = SetSelect
UIFeatureIntegratedDifficultyTab.ComponentDefine = ComponentDefine
UIFeatureIntegratedDifficultyTab.ComponentDestroy = ComponentDestroy
return UIFeatureIntegratedDifficultyTab
