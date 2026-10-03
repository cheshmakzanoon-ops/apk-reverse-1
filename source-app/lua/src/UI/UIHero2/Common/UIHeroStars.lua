local UIHeroStars = BaseClass("UIHeroStars", UIBaseContainer)
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local starNamePrefix = "star_bg"
local starPrefix = "Stars/" .. starNamePrefix
local progressNamePrefix = "Progress"
local progressPrefix = "Progress/" .. progressNamePrefix
local star_bg_path = "StarBG"
local star_bg_name_prefix = "ZeroStar"
local star_bg_prefix = "StarBG/" .. star_bg_name_prefix
local max_star_num = 5
local max_progress_num = 5

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  for index = 0, max_star_num do
    local bgPath = self:GetStarPath(index)
    self[self:GetStarComponentName(index)] = self:AddComponent(UIImage, bgPath)
  end
  self.star_bg = self:AddComponent(UIImage, star_bg_path)
end

local function SliderDefine(self)
  if self.progress ~= nil then
    return
  end
  for index = 1, max_progress_num do
    local bgPath = self:GetProgressPath(index)
    self[self:GetProgressName(index)] = self:AddComponent(UIImage, bgPath)
  end
  self.progress = self:AddComponent(UIBaseContainer, progressNamePrefix)
end

local function DataDefine(self)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function DataDestroy(self)
  self.data = nil
end

local function ComponentDestroy(self)
  if self.effectRequest ~= nil then
    self.effectRequest:Destroy()
  end
  if self.starEffectRequest ~= nil then
    self.starEffectRequest:Destroy()
  end
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function SetData(self, param)
  self.data = param
  self.starNum, self.progressNum = HeroUtils.GetHeroStarAndProgress(self.data.showStarNum)
  self:RefreshView()
end

local function RefreshView(self)
  if self.effectRequest ~= nil then
    self.effectRequest:Destroy()
  end
  if self.starEffectRequest ~= nil then
    self.starEffectRequest:Destroy()
  end
  for index = 0, max_star_num do
    local starBGComponentName = self:GetStarComponentName(index)
    local bg = self[starBGComponentName]
    if bg == nil then
      break
    end
    if index == 0 then
      bg:SetActive(self.starNum == 0 and self.data.showZeroStar)
    else
      bg:SetActive(index <= self.starNum)
    end
  end
  self:ResetProgressBg()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function GetStarPath(self, index)
  return starPrefix .. index
end

local function GetStarComponentName(self, index)
  return starNamePrefix .. index
end

local function GetProgressPath(self, index)
  return progressPrefix .. index
end

local function GetProgressName(self, index)
  return progressNamePrefix .. index
end

local function GetStarBgPath(self, index)
  return star_bg_prefix .. index
end

local function GetStarBgName(self, index)
  return star_bg_name_prefix .. index
end

local function GetLastStarPos(self)
  local index = 1
  local pos
  while index <= max_star_num do
    local obj = self[self:GetStarComponentName(index)]
    if obj and obj:GetActive() then
      pos = obj.transform.position
    else
      break
    end
    index = index + 1
  end
  if pos == nil then
    return Vector3.New(0, 0, 0)
  end
  return pos
end

local function SetProgressType(self, progressType)
  self.data.progressType = progressType
  self:ResetProgressBg()
end

local function ResetProgressBg(self)
  if self.data.showBG then
    self.star_bg:SetActive(self.data.showBG == true)
  end
  if self.data.progressType ~= nil then
    self:SliderDefine()
    self.progress:SetActive(false)
    local starNum, progressNum = HeroUtils.GetHeroStarAndProgress(self.data.maxStarNum)
    if self.data.progressType ~= UIHeroStarProgressType.UIHeroStarProgressType_Slider and self.data.progressType ~= UIHeroStarProgressType.UIHeroStarProgressType_Block then
      goto lbl_151
    end
    self.progress:SetActive(true)
    for index = 1, max_progress_num do
      local progressComponentName = self:GetProgressName(index)
      local progress = self[progressComponentName]
      if progress == nil then
        break
      end
      progress:SetActive(index <= self.progressNum)
    end
    if self.data.progressType == UIHeroStarProgressType.UIHeroStarProgressType_Block then
      local starBg = self[self:GetStarBgName(1)]
      if starBg == nil then
        for index = 1, max_star_num do
          local bgPath = self:GetStarBgPath(index)
          self[self:GetStarBgName(index)] = self:AddComponent(UIImage, bgPath)
        end
      end
      for index = 1, max_star_num do
        self[self:GetStarBgName(index)]:SetActive(starNum >= index)
      end
      if self.layout == nil then
        self.layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, star_bg_path)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
      end
      for index = 1, max_star_num do
        local obj = self[self:GetStarComponentName(index)]
        local bg = self[self:GetStarBgName(index)]
        if obj ~= nil and bg ~= nil then
          obj.transform.localPosition = bg.transform.localPosition
        end
      end
    end
  elseif self.progress ~= nil then
    self.progress:SetActive(false)
  end
  ::lbl_151::
end

local function ShowUpgradeStarEffect(self)
  if self.data.progressType == UIHeroStarProgressType.UIHeroStarProgressType_Slider then
    local starNum, progressNum = HeroUtils.GetHeroStarAndProgress(self.data.showStarNum - 1)
    local showStarEffect = starNum < self.starNum
    self.starNum = starNum
    self.progressNum = progressNum
    self:RefreshView()
    local index = progressNum + 1
    local progressComponentName = self:GetProgressName(index)
    local progress = self[progressComponentName]
    if progress ~= nil then
      progress:SetActive(true)
      do
        local prefabName = "Assets/_Art/Effect/prefab/ui/VFX_ui_hero_jingyantiao01.prefab"
        if index == 1 then
          prefabName = "Assets/_Art/Effect/prefab/ui/VFX_ui_hero_jingyantiao.prefab"
        elseif index == max_progress_num then
          prefabName = "Assets/_Art/Effect/prefab/ui/VFX_ui_hero_jingyantiao01 (1).prefab"
        end
        self.effectRequest = ResourceManager:InstantiateAsync(prefabName)
        self.effectRequest:completed("+", function()
          self.effectRequest.gameObject.name = "effectRequest"
          self.effectRequest.gameObject.transform:SetParent(progress.transform)
          self.effectRequest.gameObject.transform.localPosition = ResetPosition
          self.effectRequest.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        end)
        if self.delayTimer ~= nil then
          self.delayTimer:Stop()
          self.delayTimer = nil
        end
        self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
          if self.delayTimer ~= nil then
            self.delayTimer:Stop()
            self.delayTimer = nil
          end
          self.starNum, self.progressNum = HeroUtils.GetHeroStarAndProgress(self.data.showStarNum)
          self:RefreshView()
          if showStarEffect then
            self.starEffectRequest = ResourceManager:InstantiateAsync("Assets/_Art/Effect/prefab/ui/VFX_ui_shengxing_one.prefab")
            self.starEffectRequest:completed("+", function()
              self.starEffectRequest.gameObject.name = "starEffectRequest"
              self.starEffectRequest.gameObject.transform:SetParent(self.transform)
              self.starEffectRequest.gameObject.transform.position = self:GetLastStarPos()
              self.starEffectRequest.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            end)
          end
        end, 1.2)
      end
    end
  end
end

UIHeroStars.SetProgressType = SetProgressType
UIHeroStars.GetStarPath = GetStarPath
UIHeroStars.GetStarComponentName = GetStarComponentName
UIHeroStars.OnCreate = OnCreate
UIHeroStars.OnDestroy = OnDestroy
UIHeroStars.OnEnable = OnEnable
UIHeroStars.OnDisable = OnDisable
UIHeroStars.ComponentDefine = ComponentDefine
UIHeroStars.DataDefine = DataDefine
UIHeroStars.DataDestroy = DataDestroy
UIHeroStars.ComponentDestroy = ComponentDestroy
UIHeroStars.SetData = SetData
UIHeroStars.RefreshView = RefreshView
UIHeroStars.GetLastStarPos = GetLastStarPos
UIHeroStars.GetProgressPath = GetProgressPath
UIHeroStars.GetProgressName = GetProgressName
UIHeroStars.ResetProgressBg = ResetProgressBg
UIHeroStars.GetStarBgPath = GetStarBgPath
UIHeroStars.GetStarBgName = GetStarBgName
UIHeroStars.SliderDefine = SliderDefine
UIHeroStars.ShowUpgradeStarEffect = ShowUpgradeStarEffect
return UIHeroStars
