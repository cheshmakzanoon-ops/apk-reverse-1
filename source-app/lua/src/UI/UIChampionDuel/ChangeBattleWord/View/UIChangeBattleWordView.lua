local UIChangeBattleWordView = BaseClass("UIChangeBattleWordView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local close_btn_path = "Common_bg_orange/CloseBtn"
local title_path = "Common_bg_orange/Common_img_title/titleText"
local des_path = "ImgBg/desText"
local input_path = "ImgBg/InputField"
local warn_path = "ImgBg/warnText"
local tip_path = "ImgBg/tipText"
local num_path = "ImgBg/numText"
local use_txt_path = "ImgBg/Button/Txt1"
local use_btn_path = "ImgBg/Button"

function UIChangeBattleWordView:OnCreate()
  base.OnCreate(self)
  self.checkState = CheckNameType.MinNameChar
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("champion_duel_tips1047")
  self.use_txt = self:AddComponent(UIText, use_txt_path)
  self.use_txt:SetLocalText(GameDialogDefine.CONFIRM)
  self.des = self:AddComponent(UIText, des_path)
  self.des:SetLocalText("champion_duel_tips1032")
  self.warn = self:AddComponent(UIText, warn_path)
  self.warn:SetText("")
  self.tip = self:AddComponent(UIText, tip_path)
  self.tip:SetLocalText("champion_duel_tips1037")
  self.numTxt = self:AddComponent(UIText, num_path)
  self.numTxt:SetText("")
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChangeNameClick()
  end)
  self.input = self:AddComponent(UIInput, input_path)
  self.input:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.input:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local teamInfo = DataCenter.ChampionDuelManager:GetMyTeamInfo()
  local battleWordExpireTime = teamInfo ~= nil and teamInfo.battleWordExpireTime or 0
  self.needCheckTime = false
  if battleWordExpireTime == 0 or curSec > battleWordExpireTime then
    CS.UIGray.SetGray(self.use_btn.transform, false, true)
    self.warn:SetActive(false)
    self.tip:SetActive(true)
  else
    CS.UIGray.SetGray(self.use_btn.transform, true, false)
    self.warn:SetActive(true)
    self.tip:SetActive(false)
    self.needCheckTime = true
    self:Update1000MS()
  end
end

function UIChangeBattleWordView:OnDestroy()
  self.title = nil
  self.des = nil
  self.warn = nil
  self.tip = nil
  self.use_txt = nil
  self.nameTxt = nil
  self.numTxt = nil
  self.use_btn = nil
  self.input = nil
  self.close_btn = nil
  self.panel = nil
  self.inputValue = nil
  self.needCheckTime = false
  base.OnDestroy(self)
end

function UIChangeBattleWordView:OnEnable()
  base.OnEnable(self)
  self.input:SetText("")
  self.inputValue = ""
end

function UIChangeBattleWordView:Update1000MS()
  if self.needCheckTime then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local teamInfo = DataCenter.ChampionDuelManager:GetMyTeamInfo()
    local battleWordExpireTime = teamInfo ~= nil and teamInfo.battleWordExpireTime or 0
    if battleWordExpireTime == 0 or curSec > battleWordExpireTime then
      self.needCheckTime = false
      CS.UIGray.SetGray(self.use_btn.transform, false, true)
      self.warn:SetActive(false)
      self.tip:SetActive(true)
    else
      local remainTime = battleWordExpireTime - curSec
      self.warn:SetLocalText("champion_duel_tips1036", remainTime)
    end
  end
end

function UIChangeBattleWordView:IptOnValueChange(value)
  self.inputValue = value
  local state = self.ctrl:CheckName(self.inputValue)
  if self.inputValue == "" then
    self.des:SetActive(true)
    self.numTxt:SetText("")
  else
    self.des:SetActive(false)
    local len = #self.inputValue
    local tmpV = string.trim(value)
    if #tmpV == 0 then
      len = 0
    end
    self.numTxt:SetText(len .. "/" .. MAX_AL_NAME_CHAR * 2)
  end
  self.checkState = state
end

function UIChangeBattleWordView:OnChangeNameClick()
  local state = self.checkState
  if self.inputValue == "" then
    state = CheckNameType.MinNameChar
  end
  if state == CheckNameType.IllegalChar then
    UIUtil.ShowTipsId(129082)
    return
  elseif state == CheckNameType.MinNameChar or state == CheckNameType.MaxNameChar then
    UIUtil.ShowTipsId(120193)
    return
  elseif state == CheckNameType.Exist then
    UIUtil.ShowTipsId(280038)
    return
  elseif state == CheckNameType.SensitiveWords then
    UIUtil.ShowTipsId(280073)
    return
  end
  DataCenter.ChampionDuelManager:SendBattleWord(self.inputValue)
  self.ctrl:CloseSelf()
end

return UIChangeBattleWordView
