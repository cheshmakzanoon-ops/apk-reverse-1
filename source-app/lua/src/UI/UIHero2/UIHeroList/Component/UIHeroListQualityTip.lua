local UIHeroListQualityTip = BaseClass("UIHeroListQualityTip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.mapData = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "BtnClose")
  self.btnClose:SetOnClick(BindCallback(self, self.CloseSelf))
  local dialogIds = {
    1,
    2,
    4,
    6,
    8,
    10,
    12
  }
  for i = 1, #dialogIds do
    local text = self:AddComponent(UIText, "NodeText/TextQualityName" .. i)
    text:SetText(HeroUtils.GetQualityName(dialogIds[i]))
  end
  self.textTitle = self:AddComponent(UIText, "TextTitle")
  self.textTitle:SetLocalText(161010)
end

local function ComponentDestroy(self)
end

local function OnEnable(self)
  DOTween.Kill(self.transform)
  self.transform:Set_localScale(0, 0, 0)
  self.transform:DOScale(Vector3.New(1.1, 1.1, 0), 0.1):OnComplete(function()
    self.transform:DOScale(Vector3.one, 0.1)
  end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

local function CloseSelf(self)
  self:SetActive(false)
end

UIHeroListQualityTip.OnCreate = OnCreate
UIHeroListQualityTip.OnDestroy = OnDestroy
UIHeroListQualityTip.ComponentDefine = ComponentDefine
UIHeroListQualityTip.ComponentDestroy = ComponentDestroy
UIHeroListQualityTip.OnEnable = OnEnable
UIHeroListQualityTip.CloseSelf = CloseSelf
return UIHeroListQualityTip
