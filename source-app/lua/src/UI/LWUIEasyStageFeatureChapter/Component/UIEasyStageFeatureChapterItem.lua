local UIEasyStageFeatureChapterItem = BaseClass("UIEasyStageFeatureChapterItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "Icon",
    name = "iconNode",
    type = nil
  },
  {
    path = "Icon/Next",
    name = "imgNext",
    type = UIImage
  },
  {
    path = "Icon/Lock",
    name = "imgLock",
    type = UIImage
  },
  {
    path = "Icon/Pass",
    name = "imgPass",
    type = UIImage
  },
  {
    path = "NameText",
    name = "txtName",
    type = UIText
  },
  {
    path = "Click",
    name = "btnClick",
    type = UIButton
  },
  {
    path = "Icon/Special",
    name = "imgSpecial",
    type = UIImage
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
  self.btnClick:SetOnClick(function()
    self:OnClick()
  end)
  self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
end

local function OnDestroy(self)
  self:ClearCompsByBook(compBook)
  base.OnDestroy(self)
  if self.fadeTween then
    self.fadeTween:Kill()
  end
  self.fadeTween = nil
  if self.dropTween then
    self.dropTween:Kill()
  end
  self.dropTween = nil
  self.canvasGroup = nil
  self.onClick = nil
end

local function __FadeIn(self, drop)
  if self.fadeTween then
    self.fadeTween:Kill()
  end
  self.canvasGroup.alpha = 0
  self.fadeTween = self.canvasGroup:DOFade(1, 0.5)
  if self.dropTween then
    self.dropTween:Kill()
  end
  if drop then
    self.iconNode.transform.anchoredPosition = Vector2.New(0, 50)
    self.dropTween = self.iconNode.transform:DOAnchorPosY(0, 0.25):SetDelay(0.25):SetEase(CS.DG.Tweening.Ease.InQuad)
  end
end

local function Refresh(self, stageId)
  local order = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order")
  self.txtName:SetText(tostring(order))
  local mgr = DataCenter.LWEasyStageFeatureChapterManager
  local isNext = mgr.nextStageId == stageId
  self.imgNext:SetActive(isNext)
  local isPassed = mgr.doneStageIds[stageId] == true
  self.imgPass:SetActive(isPassed)
  self.imgLock:SetActive(not isNext and not isPassed)
  __FadeIn(self, isNext)
  local special = tonumber(LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "special_level")) or 0
  self.imgSpecial:SetActive(special == 1)
end

local function OnClick(self)
  if self.onClick then
    self.onClick()
  end
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

UIEasyStageFeatureChapterItem.OnCreate = OnCreate
UIEasyStageFeatureChapterItem.OnDestroy = OnDestroy
UIEasyStageFeatureChapterItem.Refresh = Refresh
UIEasyStageFeatureChapterItem.OnClick = OnClick
UIEasyStageFeatureChapterItem.SetOnClick = SetOnClick
return UIEasyStageFeatureChapterItem
