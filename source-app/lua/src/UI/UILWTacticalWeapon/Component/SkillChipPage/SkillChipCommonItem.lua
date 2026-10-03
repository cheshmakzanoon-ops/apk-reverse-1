local SkillChipItem = BaseClass("SkillChipItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")
local click_btn_path = "skillChipCommon"
local content_container_path = "skillChipCommon/Container"
local bg_path = "skillChipCommon/Container/Bg"
local icon_path = "skillChipCommon/Container/Icon"
local skill_chip_type_icon_path = "skillChipCommon/Container/SkillChipTypeIcon"
local level_text_path = "skillChipCommon/Container/LevelText"
local stars_layout_path = "skillChipCommon/Container/StarsLayout"
local border_path = "skillChipCommon/Container/border"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ClearStars(self)
  if self.starupSeq then
    self.starupSeq:Kill()
    self.starupSeq = nil
  end
  if self.stars then
    self.starsLayout:RemoveComponents(UIHeroSkillStar)
    for i, v in ipairs(self.stars) do
      DOTween.Kill(v.transform)
      self:GameObjectDestroy(v)
    end
    self.stars = {}
  end
end

local function ClearChipInfo(self)
  self.chipInfo = nil
  self.index = nil
  self.chipId = nil
  self.level = nil
  self.star = nil
end

local function OnDestroy(self)
  ClearStars(self)
  if self.clickBtn then
    DOTween.Kill(self.clickBtn.transform)
  end
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.contentContainer = self:AddComponent(UIBaseContainer, content_container_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.skillChipTypeIcon = self:AddComponent(UIImage, skill_chip_type_icon_path)
  self.levelText = self:AddComponent(UIText, level_text_path)
  self.levelText:SetActive(false)
  self.starsLayout = self:AddComponent(UIBaseContainer, stars_layout_path)
  self.border = self:AddComponent(UIImage, border_path)
end

local function ComponentDestroy(self)
  self.clickBtn = nil
  self.contentContainer = nil
  self.bg = nil
  self.icon = nil
  self.skillChipTypeIcon = nil
  self.levelText = nil
  self.starsLayout = nil
  self.starTemplate = nil
end

local function DataDefine(self)
  self.stars = {}
end

local function DataDestroy(self)
  self.stars = nil
  self.chipTemplate = nil
  ClearChipInfo(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function SetStars(self, starCount, animStarId)
  ClearStars(self)
  if 0 < starCount then
    local showStarCount = math.min(starCount, 5)
    local rightWindow = starCount
    for i = 1, showStarCount do
      local starRequest = self:GameObjectInstantiateAsync(UIAssets.UIHeroSkillStar, function(request)
        if IsNull(request.gameObject) then
          return
        end
        local go = request.gameObject
        local transform = go.transform
        go.gameObject:SetActive(true)
        transform:SetParent(self.starsLayout.transform)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = i
        local cell = self.starsLayout:AddComponent(UIHeroSkillStar, go)
        cell:SetFilled(true)
        local viewStarIndex = rightWindow - i + 1
        cell:SetStarIndex(viewStarIndex)
        cell.transform:Set_sizeDelta(24.98, 23.84)
        if animStarId and animStarId == viewStarIndex then
          transform:Set_localScale(2.5, 2.5, 2.5)
          if viewStarIndex <= 5 then
            cell:SetFilled(false)
          else
            cell:SetStarIndex(viewStarIndex)
          end
          self.starupSeq = DOTween.Sequence()
          self.starupSeq:AppendInterval(0.4)
          self.starupSeq:Append(transform:DOScale(0.6, 0.05):SetEase(CS.DG.Tweening.Ease.OutBack))
          self.starupSeq:AppendInterval(0.08)
          self.starupSeq:Append(transform:DOScale(1.2, 0.08):SetEase(CS.DG.Tweening.Ease.InBack))
          self.starupSeq:Append(transform:DOScale(0.8, 0.03):SetEase(CS.DG.Tweening.Ease.OutBack))
          self.starupSeq:AppendCallback(function()
            cell:SetFilled(true)
            cell:SetStarIndex(viewStarIndex)
          end)
          self.starupSeq:Append(transform:DOScale(1, 0.04):SetEase(CS.DG.Tweening.Ease.InBack))
        end
      end)
      table.insert(self.stars, starRequest)
    end
  end
end

local function GetBgPath(self, chipId)
  return DataCenter.RewardManager:GetRewardQualityBg(RewardType.TWSkillChip, chipId)
end

local function SetData(self, chipInfo, index)
  if chipInfo == nil or chipInfo.template == nil then
    return
  end
  ClearChipInfo(self)
  self.chipInfo = chipInfo
  self.index = index
  self.bg:LoadSprite(self:GetBgPath(self.chipInfo:GetId()))
  self.icon:LoadSpriteAuto(self.chipInfo:GetIcon())
  self.skillChipTypeIcon:LoadSprite(TacticalWeaponUtils.GetSkillChipTypeIcon(self.chipInfo:GetType()))
  local starCount = self.chipInfo:GetStar()
  SetStars(self, starCount)
end

local function SetLevelText(self, level)
end

local function AnimRefreshLevelText(self, animTime, delayTime)
end

local function SetOnClick(self, func)
  self.onClick = func
end

local function OnClick(self)
  if self.onClick then
    self.onClick(self, self.chipInfo, self.index)
    return
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWTWSkillChipDetail) then
    if self.chipInfo then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, self.chipInfo)
    elseif self.chipId then
      if not self.chipTemplate then
        self.chipTemplate = TWSkillChipInfo.New()
      end
      self.chipTemplate:CreateFromTemplate(self.chipId, self.level, self.star)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, self.chipTemplate)
    end
  end
end

local function SetTemplate(self, chipId, level, star)
  ClearChipInfo(self)
  if not chipId then
    return
  end
  local chipTemplate = DataCenter.TWSkillChipTemplateManager:GetTemplate(chipId)
  if not chipTemplate then
    return
  end
  self.bg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(RewardType.TWSkillChip, chipId))
  self.icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.TWSkillChip, chipId))
  self.skillChipTypeIcon:LoadSprite(TacticalWeaponUtils.GetSkillChipTypeIcon(chipTemplate.skill_type))
  local starCount = star ~= nil and star or 0
  SetStars(self, starCount)
  self.chipId = chipId
  self.level = level
  self.star = star
end

SkillChipItem.OnCreate = OnCreate
SkillChipItem.OnDestroy = OnDestroy
SkillChipItem.ComponentDefine = ComponentDefine
SkillChipItem.ComponentDestroy = ComponentDestroy
SkillChipItem.DataDefine = DataDefine
SkillChipItem.DataDestroy = DataDestroy
SkillChipItem.OnEnable = OnEnable
SkillChipItem.OnDisable = OnDisable
SkillChipItem.OnClick = OnClick
SkillChipItem.SetData = SetData
SkillChipItem.SetOnClick = SetOnClick
SkillChipItem.ClearStars = ClearStars
SkillChipItem.SetStars = SetStars
SkillChipItem.AnimRefreshLevelText = AnimRefreshLevelText
SkillChipItem.SetLevelText = SetLevelText
SkillChipItem.SetTemplate = SetTemplate
SkillChipItem.ClearChipInfo = ClearChipInfo
SkillChipItem.GetBgPath = GetBgPath
return SkillChipItem
