local base = UIBaseContainer
local UIChampionDuelWorldBg = BaseClass("UIChampionDuelWorldBg", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIChampionDuelWorldBg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIChampionDuelWorldBg:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelWorldBg:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnTranslateFinish = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnTranslateFinish:SetOnClick(function()
    self:OnBtnTranslateFinishClick()
  end)
  self.btnTranslate = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnTranslate:SetOnClick(function()
    self:OnBtnTranslateClick()
  end)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
end

function UIChampionDuelWorldBg:ComponentDestroy()
  self.viewSkin = nil
  self.textDesc = nil
  self.btnTranslateFinish = nil
  self.btnTranslate = nil
  self.btnInfo = nil
end

function UIChampionDuelWorldBg:DataDefine()
end

function UIChampionDuelWorldBg:DataDestroy()
  self.info = nil
end

function UIChampionDuelWorldBg:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelBattleTranslateFinish, self.OnTranslateBack)
end

function UIChampionDuelWorldBg:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelBattleTranslateFinish, self.OnTranslateBack)
  base.OnRemoveListener(self)
end

function UIChampionDuelWorldBg:OnBtnTranslateFinishClick()
  if self.info == nil or not self.btnInfo:GetActive() then
    return
  end
  local msg = self.info:GetMessage()
  self.textDesc:SetText(msg)
  self.btnTranslateFinish:SetActive(false)
  self.btnTranslate:SetActive(true)
end

function UIChampionDuelWorldBg:OnBtnTranslateClick()
  if self.info == nil or not self.btnInfo:GetActive() then
    return
  end
  local transMsg = self.info.translateMsg
  if string.IsNullOrEmpty(transMsg) then
    self.info:SetIsTranslating(true)
    local translateManager = DataCenter.MailDataManager.Translate
    translateManager:Translate(self.info, translateManager.TranslateEnum.ChampionDuel)
    self.textDesc:SetLocalText(120039)
  else
    self.textDesc:SetText(transMsg)
  end
  self.btnTranslateFinish:SetActive(true)
  self.btnTranslate:SetActive(false)
end

function UIChampionDuelWorldBg:OnBtnInfoClick()
  if self.info ~= nil then
    self.info:OnWordClick()
  end
end

function UIChampionDuelWorldBg:OnTranslateBack(data)
  if not (self.info ~= nil and data ~= nil and self.btnInfo:GetActive()) or self.info.uid ~= data.uid then
    return
  end
  self.textDesc:SetText(data.translateMsg)
  self.btnTranslateFinish:SetActive(true)
  self.btnTranslate:SetActive(false)
end

function UIChampionDuelWorldBg:SetData(info)
  self.info = info
  self:SetActive(info ~= nil)
  if info == nil then
    return
  end
  info:SetBattleWord(self.textDesc, self.btnInfo)
  local flag = self.btnInfo:GetActive()
  if flag then
    self.btnTranslateFinish:SetActive(false)
    self.btnTranslate:SetActive(true)
  else
    self.btnTranslate:SetActive(false)
    self.btnTranslateFinish:SetActive(false)
  end
end

return UIChampionDuelWorldBg
