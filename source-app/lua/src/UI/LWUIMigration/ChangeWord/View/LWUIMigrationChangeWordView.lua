local LWUIMigrationChangeWordView = BaseClass("LWUIMigrationChangeWordView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local close_btn_path = "Common_bg_orange/CloseBtn"
local title_path = "Common_bg_orange/Common_img_title/titleText"
local des_path = "ImgBg/desText"
local input_path = "ImgBg/InputField"
local num_path = "ImgBg/numText"
local use_txt_path = "ImgBg/Button/Txt1"
local use_btn_path = "ImgBg/Button"

function LWUIMigrationChangeWordView:OnCreate()
  base.OnCreate(self)
  self.checkState = CheckNameType.None
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("champion_duel_tips1047")
  self.use_txt = self:AddComponent(UIText, use_txt_path)
  self.use_txt:SetLocalText(GameDialogDefine.CONFIRM)
  self.des = self:AddComponent(UIText, des_path)
  self.des:SetLocalText("migration_activity_tips_20038")
  self.numTxt = self:AddComponent(UIText, num_path)
  self.numTxt:SetText("")
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn:SetOnClick(BindCallback(self, self.OnChangeNameClick))
  self.input = self:AddComponent(UIInput, input_path)
  self.input:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.input:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function LWUIMigrationChangeWordView:OnDestroy()
  self.title = nil
  self.des = nil
  self.use_txt = nil
  self.nameTxt = nil
  self.numTxt = nil
  self.use_btn = nil
  self.input = nil
  self.close_btn = nil
  self.panel = nil
  self.inputValue = nil
  self.cb = nil
  base.OnDestroy(self)
end

function LWUIMigrationChangeWordView:OnEnable()
  base.OnEnable(self)
  local sInfo, max, cb = self:GetUserData()
  self.maxLength = max
  self.cb = cb
  self.input:SetText(sInfo.notice)
  self.inputValue = sInfo.notice
end

function LWUIMigrationChangeWordView:IptOnValueChange(value)
  self.inputValue = value
  local len = #value
  if len > self.maxLength then
    self.checkState = CheckNameType.MaxNameChar
  else
    self.checkState = CheckNameType.None
  end
  if self.inputValue == "" then
    self.des:SetActive(true)
    self.numTxt:SetText("")
  else
    self.des:SetActive(false)
    local tmpV = string.trim(value)
    if #tmpV == 0 then
      len = 0
    end
    self.numTxt:SetText(len .. "/" .. self.maxLength)
  end
end

function LWUIMigrationChangeWordView:OnChangeNameClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local state = self.checkState
  if state == CheckNameType.MaxNameChar then
    UIUtil.ShowTipsId(120193)
    return
  end
  if self.cb then
    self.cb(self.inputValue)
  end
  self.ctrl:CloseSelf()
end

return LWUIMigrationChangeWordView
