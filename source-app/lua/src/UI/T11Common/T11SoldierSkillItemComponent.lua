local base = UIBaseContainer
local T11SoldierSkillItemComponent = BaseClass("T11SoldierSkillItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local goldFramePath = "Assets/Main/Sprites/UI/UIT11/ljq_t11_jinengkuang_jin.png"
local silverFramePath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_jinengkuang_1.png"
local STANDARD_SIZE = 100

function T11SoldierSkillItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11SoldierSkillItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SoldierSkillItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.skillBtn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.skillBtn:SetOnClick(function()
    self:OnSkillBtnClick()
  end)
  self.imgSoldierSkill = self.viewSkin:AddComponent(self, UIImage, 2)
  self.compT11SkillLockImg = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.imgBG = self.viewSkin:AddComponent(self, UIImage, 4)
  self.compLockImg = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compT11SkillLockImg:SetActive(false)
end

function T11SoldierSkillItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.skillBtn = nil
  self.imgSoldierSkill = nil
  self.compT11SkillLockImg = nil
  self.imgBG = nil
  self.compLockImg = nil
end

function T11SoldierSkillItemComponent:DataDefine()
  self.skillData = {}
  self.cannotClick = false
  self.showLockImage = false
end

function T11SoldierSkillItemComponent:DataDestroy()
  self.skillData = nil
  self.cannotClick = nil
  self.showLockImage = nil
end

function T11SoldierSkillItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11SoldierSkillItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11SoldierSkillItemComponent:OnSkillBtnClick()
  if self.cannotClick then
    return
  end
  local param = {}
  param.alignObject = self.transform
  param.width = 515
  param.skillData = self.skillData
  param.fixedSoldierType = self.fixedSoldierType
  param.showArrow = true
  param.showLockImage = self.showLockImage
  param.addPosY = 80
  UIManager:GetInstance():OpenWindow(UIWindowNames.T11SoldierSkillTip, {anim = true}, param)
end

function T11SoldierSkillItemComponent:Init(skillData, isShowLockState, cannotClick, fixedSoldierType)
  if skillData == nil then
    return
  end
  self.skillData = skillData
  self.fixedSoldierType = fixedSoldierType
  local icon = skillData.icon
  icon = fixedSoldierType == SoldierType.Mummy and skillData.effect_mummy_icon or icon
  if not icon then
    Logger.LogError("T11SoldierSkillItemComponent:Init skillData.icon is nil, skillId: ")
  end
  self:LoadIconSprite(icon)
  if isShowLockState then
    self.compT11SkillLockImg:SetActive(not skillData.isUnlock)
    if self.compT11SkillLockImg.gameObject.activeSelf and self.compLockImg then
      local curCptSize = self.rectTransform.rect.width or 100
      local lockImgScale = curCptSize / STANDARD_SIZE
      self.compLockImg.transform:Set_localScale(lockImgScale, lockImgScale, lockImgScale)
    end
  end
  self.showLockImage = isShowLockState
  local framePath = skillData.ifCoreEffect and goldFramePath or silverFramePath
  self.imgBG:LoadSprite(framePath)
  self.cannotClick = cannotClick or false
end

function T11SoldierSkillItemComponent:LoadIconSprite(iconPath)
  if string.IsNullOrEmpty(iconPath) then
    Logger.LogError("T11SoldierSkillItemComponent:LoadIconSprite iconPath is nil")
    return
  end
  self.imgSoldierSkill:LoadSprite(iconPath)
end

return T11SoldierSkillItemComponent
