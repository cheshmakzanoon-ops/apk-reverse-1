local UIHeroInfoView = require("UI.UIHero2.UIHeroInfo.View.UIHeroInfoView")
local UIHeroTipsView = BaseClass("UIHeroTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local MinHeight = 80
local MaxHeight = 300
local MarginX = 30
local MarginY = 20
local Screen = CS.UnityEngine.Screen
local Direction = {
  ABOVE = 1,
  BELOW = 2,
  LEFT = 3,
  RIGHT = 4
}
local ParamData = {
  title = "",
  content = "",
  heroId = nil,
  dir = Direction.ABOVE,
  defWidth = 280,
  pivot = 0.5,
  position = Vector2.zero,
  deltaX = 0,
  deltaY = 0
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  local param = self:GetUserData()
  assert(param.bindObject ~= nil)
  if param.bindObject.gameObject == nil or not param.bindObject.gameObject.activeInHierarchy then
    Logger.Log("UIHeroTipsView init aborted because its bindObject has been destroyed.")
    self.ctrl:CloseSelf()
    return
  end
  if CommonUtil.IsArabicAutoMirrorOpen() then
    if param.dir == Direction.LEFT then
      param.dir = Direction.RIGHT
    elseif param.dir == Direction.RIGHT then
      param.dir = Direction.LEFT
    end
  end
  self.param = param
  local dir = param.dir
  local pivot = param.pivot
  local defWidth = param.defWidth
  local rootRt = self.root.rectTransform
  local arrowRt = self.imgArrow.rectTransform
  local contentRt = self.textContent.rectTransform
  local titleRt = self.textTitle.rectTransform
  local deltaX = 0
  if param.deltaX ~= nil then
    deltaX = param.deltaX
  end
  local deltaY = 0
  if param.deltaY ~= nil then
    deltaY = param.deltaY
  end
  if dir == Direction.ABOVE then
    rootRt.pivot = Vector2.New(pivot, 0)
    arrowRt.localRotation = Quaternion.Euler(0, 0, 90)
    arrowRt.anchorMin = Vector2.New(pivot, 0)
    arrowRt.anchorMax = Vector2.New(pivot, 0)
    arrowRt.anchoredPosition = Vector2.New(0 - deltaX, 7 - deltaY)
  elseif dir == Direction.BELOW then
    rootRt.pivot = Vector2.New(pivot, 1)
    arrowRt.localRotation = Quaternion.Euler(0, 0, -90)
    arrowRt.anchorMin = Vector2.New(pivot, 1)
    arrowRt.anchorMax = Vector2.New(pivot, 1)
    arrowRt.anchoredPosition = Vector2.New(0 - deltaX, -7 - deltaY)
  elseif dir == Direction.RIGHT then
    rootRt.pivot = Vector2.New(0, pivot)
    arrowRt.localRotation = Quaternion.Euler(0, 0, 0)
    arrowRt.anchorMin = Vector2.New(0, pivot)
    arrowRt.anchorMax = Vector2.New(0, pivot)
    arrowRt.anchoredPosition = Vector2.New(9 - deltaX, 0 - deltaY)
  elseif dir == Direction.LEFT then
    rootRt.pivot = Vector2.New(1, pivot)
    arrowRt.localRotation = Quaternion.Euler(0, 0, 180)
    arrowRt.anchorMin = Vector2.New(1, pivot)
    arrowRt.anchorMax = Vector2.New(1, pivot)
    arrowRt.anchoredPosition = Vector2.New(-9 - deltaX, 0 - deltaY)
  end
  rootRt:Set_sizeDelta(defWidth, MinHeight)
  contentRt:Set_sizeDelta(param.defWidth, MinHeight)
  titleRt:Set_sizeDelta(param.defWidth, MinHeight)
  self.textContent:SetText(param.content)
  self.textTitle.gameObject:SetActive(false)
  local contentHeigth = self.textContent:GetHeight()
  if param.title ~= nil then
    self.textTitle.gameObject:SetActive(true)
    self.textTitle:SetText(param.title)
    contentHeigth = contentHeigth + self.textTitle:GetHeight() + 14
    titleRt.sizeDelta = Vector2.New(param.defWidth, self.textTitle:GetHeight())
  end
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  rootRt.position = param.position + Vector3.New(deltaX, deltaY, 0) * scaleFactor
  contentRt:Set_sizeDelta(param.defWidth, contentHeigth)
  rootRt.sizeDelta = contentRt.sizeDelta + Vector2.New(MarginX * 2, MarginY * 2)
  self.checkHero:SetActive(self.param.heroId)
  DOTween.Kill(rootRt)
  rootRt:Set_localScale(0, 0, 0)
  rootRt:DOScale(Vector3.New(1.1, 1.1, 0), 0.1):OnComplete(function()
    rootRt:DOScale(Vector3.one, 0.1)
  end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

local function OnDisable(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.imgArrow = self:AddComponent(UIImage, "Root/ImgArrow")
  self.textContent = self:AddComponent(UIText, "Root/Content/TextContent")
  self.textTitle = self:AddComponent(UIText, "Root/Content/TextTitle")
  self.checkHero = self:AddComponent(UIButton, "Root/checkHeroBtn")
  self.checkHero:SetOnClick(function()
    self:OnClickCheckHeroBtn()
  end)
end

local function ComponentDestroy(self)
  self.root = nil
  self.imgArrow = nil
  self.textContent = nil
  self.textTitle = nil
end

local function OnClickCheckHeroBtn(self)
  local fromType = UIHeroInfoView.FromType.SingleHeroId
  self.ctrl:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroInfo, {
    anim = true,
    hideTop = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, fromType, self.param.heroId)
end

UIHeroTipsView.Param = Param
UIHeroTipsView.Direction = Direction
UIHeroTipsView.OnCreate = OnCreate
UIHeroTipsView.OnDestroy = OnDestroy
UIHeroTipsView.OnEnable = OnEnable
UIHeroTipsView.OnDisable = OnDisable
UIHeroTipsView.ComponentDefine = ComponentDefine
UIHeroTipsView.ComponentDestroy = ComponentDestroy
UIHeroTipsView.OnClickCheckHeroBtn = OnClickCheckHeroBtn
return UIHeroTipsView
