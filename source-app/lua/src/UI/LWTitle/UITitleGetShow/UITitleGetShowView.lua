local base = UIBaseView
local UITitleGetShow = BaseClass("UITitleGetShow", base)
local TitleGetShowItem = require("UI.LWTitle.Component.TitleGetShowItem")
local BtnBack_path = "Panel"
local TxtTitle_path = "Content/bgContent1/titleBg/mask_titlebg/titlebg/titleTxt"
local Effect_path = "Content/TitleGetShowItem/Effect"
local EffectTop_path = "Content/EffectTop"
local Item_path = "Content/TitleGetShowItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.showList = self:GetUserData()
  self:ShowNextTitle()
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
  self.BtnBack = self:AddComponent(UIButton, BtnBack_path)
  self.TxtTitle = self:AddComponent(UIText, TxtTitle_path)
  self.Effect = self:AddComponent(UIBaseContainer, Effect_path)
  self.EffectTop = self:AddComponent(UIBaseContainer, EffectTop_path)
  self.Item = self:AddComponent(UIBaseContainer, Item_path)
  self.BtnBack:SetOnClick(BindCallback(self, self.ShowNextTitle))
  self.ShowItem = self:AddComponent(TitleGetShowItem, Item_path)
  self.Anim = self:AddComponent(UISimpleAnimation, "")
end

local function ComponentDestroy(self)
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  self.BtnBack = nil
  self.TxtTitle = nil
  self.Effect = nil
  self.EffectTop = nil
  self.Item = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UITitleGetShow:ShowNextTitle()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.nextShowTime and curTime < self.nextShowTime then
    return
  end
  self.Effect:SetActive(false)
  self.EffectTop:SetActive(false)
  if table.IsNullOrEmpty(self.showList) then
    self.ctrl:CloseSelf()
    return
  end
  local data = table.remove(self.showList, 1)
  if not data then
    self.ctrl:CloseSelf()
    return
  end
  local cd = self:RefreshView(data)
  if cd then
    self.nextShowTime = curTime + cd * 1000
  end
end

function UITitleGetShow:RefreshView(titleData)
  SFSNetwork.SendMessage(MsgDefines.UserTitleSetPopUpState, titleData.cfgId)
  local info = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(titleData.cfgId)
  if not info then
    return
  end
  self.Anim:Play("Default")
  local lastInfo = DataCenter.PlayerTitleTemplateManager:GetLastTitleInfo(titleData.cfgId)
  local lastData = lastInfo and DataCenter.PlayerInfoDataManager:GetTitle(lastInfo.id)
  if not lastData then
    self.TxtTitle:SetLocalText("lw_title_ui_2")
    self.ShowItem:ReInit(titleData)
    self.Effect:SetActive(true)
    self.EffectTop:SetActive(true)
    return 0.5
  end
  self.TxtTitle:SetLocalText("lw_title_ui_3")
  self.ShowItem:ReInit(lastData)
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:AppendInterval(2)
  self.tweenSeq:AppendCallback(function()
    self.Anim:Play("LevelUp")
    self.Effect:SetActive(true)
    self.EffectTop:SetActive(true)
    self.ShowItem:ReInit(titleData)
  end)
  return 2.5
end

UITitleGetShow.OnCreate = OnCreate
UITitleGetShow.OnDestroy = OnDestroy
UITitleGetShow.OnEnable = OnEnable
UITitleGetShow.OnDisable = OnDisable
UITitleGetShow.ComponentDefine = ComponentDefine
UITitleGetShow.ComponentDestroy = ComponentDestroy
UITitleGetShow.DataDefine = DataDefine
UITitleGetShow.DataDestroy = DataDestroy
return UITitleGetShow
