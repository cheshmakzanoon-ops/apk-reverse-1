local UIEpidemicBattleCommanderSetItem = BaseClass("UIEpidemicBattleCommanderSetItem", UIBaseContainer)
local base = UIBaseContainer
local head_path = "Head/UIPlayerHead"
local img_r_path = "Head/RImg"
local text_name_path = "NameText"
local text_lv_path = "LvText"
local text_power_path = "Power/PowerText"
local text_state_path = "StateText"
local checkbox_path = "checkbox"
local active_path = "checkbox/active"

function UIEpidemicBattleCommanderSetItem:OnCreate()
  base.OnCreate(self)
  self.head = self:AddComponent(UICommonHead, head_path)
  self.head:SetEnableClickShowInfo(true, false)
  self.img_r = self:AddComponent(UIImage, img_r_path)
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.text_lv = self:AddComponent(UIText, text_lv_path)
  self.text_power = self:AddComponent(UIText, text_power_path)
  self.text_state = self:AddComponent(UIText, text_state_path)
  self.checkbox = self:AddComponent(UIButton, checkbox_path)
  self.checkbox:SetOnClick(BindCallback(self, self.OnClick))
  self.active = self:AddComponent(UIBaseComponent, active_path)
end

function UIEpidemicBattleCommanderSetItem:OnDestroy()
  self.uid = nil
  self.cb = nil
  base.OnDestroy(self)
end

function UIEpidemicBattleCommanderSetItem:OnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local isR4orR5 = ActEpidemicUtils.CanChangeBattlePlayer()
  if not isR4orR5 then
    UIUtil.ShowTipsId(2010348)
    return
  end
  local flag = not self.active:GetActive()
  if self.cb then
    self.active:SetActive(flag)
    self.cb(self, self.uid, flag)
  end
end

function UIEpidemicBattleCommanderSetItem:UpdateActive(state)
  self.active:SetActive(state)
end

function UIEpidemicBattleCommanderSetItem:ReInit(idx, data, cb)
  self.idx = idx
  self.uid = data.uid
  self.cb = cb
  self.head:SetData(data.uid, data.pic, data.picVer)
  local showName = UIUtil.FormatAllianceAndName(nil, data.name, data.uid)
  self.text_name:SetText(showName)
  self.text_lv:SetLocalText(140002, data.lv or 0)
  self.text_power:SetText(string.GetFormattedSeperatorNum(data.power or 0))
  local inBattle = data.inBF
  local keyId = inBattle and "390188" or "390811"
  local r = inBattle and 95 or 249
  local g = inBattle and 239 or 128
  local b = inBattle and 135 or 136
  self.text_state:SetLocalText(keyId)
  self.text_state:SetColorRGBA255(r, g, b, 255)
  local memberData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(data.uid)
  local rank = memberData ~= nil and memberData:GetRank() or 1
  self.img_r:SetActive(4 <= rank)
  if 4 <= rank then
    self.img_r:LoadSpriteAuto(LWAlMemberRankParam[rank].Icon)
  end
  self.active:SetActive(data.commander)
end

return UIEpidemicBattleCommanderSetItem
