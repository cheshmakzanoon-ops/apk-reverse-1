local base = UIAsyncContainer
local UIActEpidemicMainCompMVP = BaseClass("UIActEpidemicMainCompMVP", base)
local UIPlayerHead = require("Framework.UI.Component.UIPlayerHead")
local Localization = CS.GameEntry.Localization

local function OnCreate(self, mainView)
  base.OnCreate(self)
  self.mainView = mainView
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgLight = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgBgLeft = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgBgRight = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textTmpTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnPlayerDogHead = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnPlayerDogHead:SetOnClick(function()
    self:OnBtnPlayerDogHeadClick()
  end)
  self.textTmpMvpInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTmpMvpNotice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compHeadIcon = self.viewSkin:AddComponent(self, UIPlayerHead, 8)
  self.btnLoveDog = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnLoveDog:SetOnClick(function()
    self:OnBtnLoveDogClick()
  end)
  self.compFinishText = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.currentGroup = nil
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.imgLight = nil
  self.imgBgLeft = nil
  self.imgBgRight = nil
  self.textTmpTitle = nil
  self.btnPlayerDogHead = nil
  self.textTmpMvpInfo = nil
  self.textTmpMvpNotice = nil
  self.compHeadIcon = nil
  self.btnLoveDog = nil
  self.compFinishText = nil
  self.compRoot = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local winSprite = "mjc_guanzhijineng_sidai"
local loseSprite = "mjc_yibianjinqu_sidai_shibai"
local winLightColor = Color.New(1, 0.5882353, 0.1176471, 1)
local loseLightColor = Color.New(0.1921569, 0.282353, 0.3686275, 1)

function UIActEpidemicMainCompMVP:Show()
  self:SetActive(true)
  if not self:AsyncLoadDone() then
    return
  end
  local showInfo = ActEpidemicUtils.GetMvpShowInfo(self.mainView:GetGroupIndex())
  local haveMvp = showInfo ~= nil and showInfo.mvp ~= nil
  self.compFinishText:SetActive(not haveMvp)
  self.compRoot:SetActive(haveMvp)
  if not haveMvp then
    return
  end
  local mvp = showInfo.mvp
  self.mvp = mvp
  self.mvpUid = mvp.uid
  local name = mvp.name or ""
  local fraction = mvp.score or 0
  self.textTmpMvpInfo:SetText(string.format([[
%s
%s]], name, string.GetFormattedStr(fraction)))
  local pic = mvp.pic
  local picVer = mvp.picVer
  self.compHeadIcon:SetData(mvp.uid, pic, picVer)
  self.textTmpTitle:SetLocalText("YiBianJinQu_event_tips_9")
  local bg = string.format(LoadPath.LWBattleFieldEpidemicPath, winSprite)
  self.imgBgLeft:LoadSpriteAuto(bg)
  self.imgBgRight:LoadSpriteAuto(bg)
  self.imgLight:SetColor(winLightColor)
  local teamName = Localization:GetString(self.mainView:GetGroupIndex() == ActEpidemicUtils.Group1 and "A" or "B")
  local roleName = ActEpidemicUtils.GetRoleNameByRoleId(self.mainView:GetCurrentGroupRole())
  self.textTmpMvpNotice:SetText(Localization:GetString("YiBianJinQu_event_tips_10", teamName, roleName))
  self.btnLoveDog:SetActive(self.mvp ~= nil)
end

function UIActEpidemicMainCompMVP:Hide()
  self:SetActive(false)
  if self:AsyncLoadDone() then
    return
  end
end

function UIActEpidemicMainCompMVP:OnBtnPlayerDogHeadClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.mvpUid)
end

function UIActEpidemicMainCompMVP:OnBtnLoveDogClick()
  if not self.mvp then
    return
  end
  InteractiveUtil.TryThumbsUp(self.mvp.uid, InteractiveUtil.ThumbsUpType.EpidemicBattleMvp, "UIActEpidemicBattleHistoryItem", function()
    UIUtil.ShowTipsId("YiBianJinQu_trivial_tips_21")
  end)
end

UIActEpidemicMainCompMVP.OnCreate = OnCreate
UIActEpidemicMainCompMVP.OnDestroy = OnDestroy
UIActEpidemicMainCompMVP.OnEnable = OnEnable
UIActEpidemicMainCompMVP.OnDisable = OnDisable
UIActEpidemicMainCompMVP.ComponentDefine = ComponentDefine
UIActEpidemicMainCompMVP.ComponentDestroy = ComponentDestroy
UIActEpidemicMainCompMVP.DataDefine = DataDefine
UIActEpidemicMainCompMVP.DataDestroy = DataDestroy
UIActEpidemicMainCompMVP.OnAddListener = OnAddListener
UIActEpidemicMainCompMVP.OnRemoveListener = OnRemoveListener
return UIActEpidemicMainCompMVP
