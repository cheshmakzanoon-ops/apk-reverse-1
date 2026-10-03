local UIKillZombieAdvanceTrailView = BaseClass("UIKillZombieAdvanceTrailView", UIBaseView)
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local base = UIBaseView
local panel_path = "panel"
local title_text_path = "PopUpTitle/RecImg/Title"
local content_text_path = "PopUpTitle/TipsTxt"
local chanllengeLater_Btn_path = "PopUpTitle/ChallengeLaterBtn"
local chanllengeLater_text_path = "PopUpTitle/ChallengeLaterBtn/ChallengeLaterText"
local chanllengeAccept_Btn_path = "PopUpTitle/AcceptBtn"
local chanllengeAccept_text_path = "PopUpTitle/AcceptBtn/AcceptText"
local heroSpineContainer = "PopUpTitle/HeroSpineContainer"
local close_btn_path = "PopUpTitle/CloseBtn"

function UIKillZombieAdvanceTrailView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function UIKillZombieAdvanceTrailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIKillZombieAdvanceTrailView:ComponentDefine()
  self.heroSpine = self:AddComponent(UIBaseContainer, heroSpineContainer)
  self.btnPanel = self:AddComponent(UIButton, panel_path)
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, title_text_path)
  self.textTitle:SetLocalText(self.param.titleTxt)
  self.contentText = self:AddComponent(UIText, content_text_path)
  self.contentText:SetFontSize(32)
  self.contentText:SetBestFitEnable(true)
  local content = Localization:GetString(self.param.contentTxt)
  self.contentText:SetText(content)
  self.contentText:ForceUpdate()
  local size = self.contentText:GetFontSize()
  self.contentText:SetBestFitEnable(false)
  self.contentText:SetFontSize(size)
  self.contentText:DOText(content, self.param.contentDoTime)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnChallengeLater = self:AddComponent(UIButton, chanllengeLater_Btn_path)
  self.btnChallengeLater:SetOnClick(function()
    self.param.cancelCallBack()
    self.ctrl:CloseSelf()
  end)
  self.textChallengeLater = self:AddComponent(UIText, chanllengeLater_text_path)
  self.textChallengeLater:SetLocalText(self.param.cancelTxt)
  self.btnChallengeAccept = self:AddComponent(UIButton, chanllengeAccept_Btn_path)
  self.btnChallengeAccept:SetOnClick(function()
    self.param.confirmCallBack()
    self.ctrl:CloseSelf()
  end)
  self.textChallengeAccept = self:AddComponent(UIText, chanllengeAccept_text_path)
  self.textChallengeAccept:SetLocalText(self.param.confirmTxt)
  self:Clear()
  self.heroSpine:SetActive(false)
  local request = ResourceManager:InstantiateAsync(self.param.heroSpinePath)
  self.heroSpineRequest = request
  request:completed("+", function()
    if request.isError or request.gameObject == nil then
      self.heroSpineRequest = nil
      return
    end
    request.gameObject:SetActive(true)
    self.heroSpine:SetActive(true)
    local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTransform ~= nil then
      rectTransform:SetParent(self.heroSpine.transform)
      rectTransform:Set_localScale(1, 1, 1)
      rectTransform:Set_anchoredPosition(0, 0)
    end
  end)
end

function UIKillZombieAdvanceTrailView:Clear()
  if self.heroSpineRequest ~= nil then
    self.heroSpineRequest:Destroy()
    self.heroSpineRequest = nil
  end
end

function UIKillZombieAdvanceTrailView:ComponentDestroy()
  self.btnPanel = nil
  self.titleText = nil
  self.contentText = nil
  self.closeBtn = nil
  self.textChallengeAccept = nil
  self.btnChallengeAccept = nil
  self.textChallengeLater = nil
  self.btnChallengeLater = nil
end

return UIKillZombieAdvanceTrailView
