local base = UIBaseContainer
local TranslateContentComp = BaseClass("TranslateContentComp", base)
local Localization = CS.GameEntry.Localization
local translateTrans_path = ""
local translateBtn_path = "TranslateBtn"
local translateRefreshBtn_path = "TranslateRefreshBtn"
local translateFinishImg_path = "TranslateFinishImg"
local translating_path = "Translating"
local translatingText_path = "Translating/TranslatingText"

local function OnCreate(self)
  base.OnCreate(self)
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
  self.translateTrans = self:AddComponent(UIBaseContainer, translateTrans_path)
  self.translateBtn = self:AddComponent(UIButton, translateBtn_path)
  self.translateRefreshBtn = self:AddComponent(UIButton, translateRefreshBtn_path)
  self.translateFinishImg = self:AddComponent(UIBaseContainer, translateFinishImg_path)
  self.translating = self:AddComponent(UIBaseContainer, translating_path)
  self.translatingText = self:AddComponent(UIText, translatingText_path)
  self.translatingText:SetLocalText("120039")
  self.translateBtn:SetOnClick(function()
    self:OnTranslateBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.translateTrans = nil
  self.translateBtn = nil
  self.translateRefreshBtn = nil
  self.translateFinishImg = nil
  self.translating = nil
  self.translatingText = nil
end

local function DataDefine(self)
  self.clickFunc = nil
  self.translateState = nil
end

local function DataDestroy(self)
  self.clickFunc = nil
  self.translateState = nil
end

function TranslateContentComp:SetData(translateState, clickFunc)
  self.clickFunc = clickFunc
  self.translateState = translateState
  self:RefreshView()
end

function TranslateContentComp:SetStateData(translateState)
  self.translateState = translateState
  self:RefreshView()
end

function TranslateContentComp:RefreshView()
  self:RefreshTxtContent()
end

function TranslateContentComp:RefreshTxtContent()
  local translateState = self.translateState
  if translateState ~= TranslateStateType.TranslationCompleted then
    self.translateTrans:SetActive(true)
    local isTranslating = translateState == TranslateStateType.Translating
    local hasTranslated = translateState == TranslateStateType.TranslationCompleted
    self.translating:SetActive(isTranslating and not hasTranslated)
    self.translateBtn:SetActive(not isTranslating and not hasTranslated)
    self.translateFinishImg:SetActive(false)
    self.translateRefreshBtn:SetActive(false)
  else
    self.translateTrans:SetActive(false)
  end
end

function TranslateContentComp:OnTranslateBtnClick()
  if self.clickFunc then
    self.clickFunc()
  end
end

TranslateContentComp.OnCreate = OnCreate
TranslateContentComp.OnDestroy = OnDestroy
TranslateContentComp.OnEnable = OnEnable
TranslateContentComp.OnDisable = OnDisable
TranslateContentComp.ComponentDefine = ComponentDefine
TranslateContentComp.ComponentDestroy = ComponentDestroy
TranslateContentComp.DataDefine = DataDefine
TranslateContentComp.DataDestroy = DataDestroy
return TranslateContentComp
