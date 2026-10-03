local UIHeroWeaponSkillTipView = BaseClass("UIHeroWeaponSkillTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local Screen = CS.UnityEngine.Screen
local ParamData = {
  title = "",
  content = "",
  alignObject = nil
}
local Pivot_Max = 1.0
local Pivot_Min = 0.0
local Pivot_Mid = 0.5

local function CheckAlign(self)
  local _arrowX = 0
  local _arrowY = 0
  local _rotation = 0
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local ScreenHeight = ScreenSize.height
  local widthScale = ScreenWidth / DefaultScreenWidth
  local heightScale = ScreenHeight / DefaultScreenHeight
  local _rect = self.bgRoot.rectTransform.rect
  local BgWidth = _rect.width * widthScale
  local BgHeight = _rect.height * heightScale
  local alignObject = self.alignObject
  local position = alignObject.transform.position
  local yPosFix = self.param.yPosFix or 0
  position.y = position.y + yPosFix * heightScale
  local _screenPos = PosConverse.UIWorldToScreenPos(position)
  local targetScreenPos = _screenPos
  local pivot = Vector2.New(0.5, 0.5)
  local offsetX = 0
  if _screenPos.x - BgWidth / 2 < 10 then
    offsetX = BgWidth / 2 - _screenPos.x
  elseif _screenPos.x + BgWidth / 2 > ScreenWidth - 10 then
    offsetX = ScreenWidth - _screenPos.x - BgWidth / 2
  end
  targetScreenPos.x = targetScreenPos.x + offsetX
  pivot.x = Pivot_Mid
  _arrowX = -offsetX / widthScale
  if _screenPos.y + BgHeight < ScreenHeight - 10 or _screenPos.y - BgHeight > 10 then
    if _screenPos.y + BgHeight < ScreenHeight - 10 then
      pivot.y = Pivot_Min
      _arrowY = -BgHeight / heightScale * 0.5
    elseif _screenPos.y - BgHeight > 10 then
      pivot.y = Pivot_Max
      _arrowY = BgHeight / heightScale * 0.5
    end
  else
    pivot.y = Pivot_Mid
  end
  if pivot.x == Pivot_Max and pivot.y == Pivot_Min then
    _rotation = 270
    _arrowX = _arrowX + 8
    _arrowY = _arrowY + 20
  elseif pivot.x == Pivot_Max and pivot.y == Pivot_Max then
    _rotation = 270
    _arrowX = _arrowX + 8
    _arrowY = _arrowY - 16
  elseif pivot.x == Pivot_Max and pivot.y == Pivot_Mid then
    _rotation = 270
    _arrowX = _arrowX + 8
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Min then
    _rotation = 90
    _arrowX = _arrowX - 8
    _arrowY = _arrowY + 20
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Max then
    _rotation = 90
    _arrowX = _arrowX - 8
    _arrowY = _arrowY - 16
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Mid then
    _rotation = 90
    _arrowX = _arrowX - 8
  elseif pivot.x == Pivot_Mid and pivot.y == Pivot_Max then
    _rotation = 0
    _arrowY = _arrowY + 8
  elseif pivot.x == Pivot_Mid and pivot.y == Pivot_Min then
    _rotation = 180
    _arrowY = _arrowY - 4
  else
    _rotation = 0
    _arrowX = 9999
    _arrowY = 9999
  end
  self.imgArrow.transform.localRotation = Quaternion.Euler(0, 0, _rotation)
  self.imgArrow.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)
  self.imgArrow:SetActive(true)
  self.bgRoot.rectTransform.pivot = pivot
  local uiPos = PosConverse.ScreenToUIPos(self.root.transform, targetScreenPos)
  self.bgRoot.transform.anchoredPosition = uiPos
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  local param = self:GetUserData()
  self.param = param
  self.alignObject = param.alignObject
  local rootRt = self.root.rectTransform
  self.titleText:SetLocalText(self.param.name)
  self.descText:SetText(self.param.desc)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgRoot.transform)
  CheckAlign(self)
  local skillId = self.param.skillId
  if skillId and 0 < skillId then
    local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(param.skillId)
    self.previewBtn:SetActive(skillTemplate:IsShowSkillPreviewBtn())
  else
    self.previewBtn:SetActive(false)
  end
  DOTween.Kill(rootRt)
  rootRt:Set_localScale(0, 0, 0)
  rootRt:DOScale(Vector3.New(1.1, 1.1, 0), 0.1):OnComplete(function()
    rootRt:DOScale(Vector3.one, 0.1)
  end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

local function OnDestroy(self)
  if self.root then
    local rootRt = self.root.rectTransform
    DOTween.Kill(rootRt)
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.bgRoot = self:AddComponent(UIBaseContainer, "Root/ImgBg")
  self.imgArrow = self:AddComponent(UIImage, "Root/ImgBg/Arrow")
  self.titleContent = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content/TitleContent")
  self.titleText = self:AddComponent(UIText, "Root/ImgBg/Content/TitleContent/TitleText")
  self.previewBtn = self:AddComponent(UIButton, "Root/ImgBg/Content/TitleContent/PreviewBtn")
  self.descText = self:AddComponent(UIText, "Root/ImgBg/Content/DescText")
  self.previewBtn:SetOnClick(function()
    if not self.param then
      return
    end
    local heroId = self.param.heroId
    local skillId = self.param.skillId
    local skillLv = self.param.skillLv
    local skillMaxLv = DataCenter.HeroSkillTemplateManager:GetSkillMaxLv(skillId)
    local weaponLv = self.param.weaponLv
    local awakenLv, skinId
    local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(self.param.heroId)
    if heroData then
      awakenLv = heroData:GetHeroAwakenRankLevel()
      skinId = heroData:GetSkinId()
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPreviewSkillWindow, {anim = true}, heroId, skillId, skillLv, skillMaxLv, weaponLv, awakenLv, skinId)
  end)
end

local function ComponentDestroy(self)
  self.root = nil
  self.bgRoot = nil
  self.imgArrow = nil
  self.titleContent = nil
  self.titleText = nil
  self.previewBtn = nil
  self.descText = nil
end

UIHeroWeaponSkillTipView.Param = Param
UIHeroWeaponSkillTipView.OnCreate = OnCreate
UIHeroWeaponSkillTipView.OnDestroy = OnDestroy
UIHeroWeaponSkillTipView.ComponentDefine = ComponentDefine
UIHeroWeaponSkillTipView.ComponentDestroy = ComponentDestroy
return UIHeroWeaponSkillTipView
