local UILWMailDetailMigrationMarketItem = BaseClass("UILWMailDetailMigrationMarketItem", UIBaseContainer)
local base = UIBaseContainer
local head_path = "Head"
local lv_text_path = "LvText"
local flag_path = "Flag"
local name_text_path = "NameText"
local power_text_path = "PowerText"
local server_text_path = "ServerText"
local btn_path = "Btn"
local tag_path = "Tag"
local state_text_path = "StateText"

function UILWMailDetailMigrationMarketItem:OnCreate()
  base.OnCreate(self)
  self.head = self:AddComponent(UICommonHead, head_path)
  self.head:SetEnableClickShowInfo(true, true)
  self.lv_text = self:AddComponent(UITextMeshProUGUIEx, lv_text_path)
  self.flag = self:AddComponent(UIImage, flag_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.power_text = self:AddComponent(UITextMeshProUGUIEx, power_text_path)
  self.server_text = self:AddComponent(UITextMeshProUGUIEx, server_text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnBtnInviteClick))
  self.tag = self:AddComponent(UIImage, tag_path)
  self.state_text = self:AddComponent(UITextMeshProUGUIEx, state_text_path)
end

function UILWMailDetailMigrationMarketItem:OnDestroy()
  self.head = nil
  self.lv_text = nil
  self.flag = nil
  self.name_text = nil
  self.power_text = nil
  self.server_text = nil
  self.btn = nil
  self.tag = nil
  self.state_text = nil
  base.OnDestroy(self)
end

function UILWMailDetailMigrationMarketItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailMigrationMarketItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailMigrationMarketItem:OnBtnInviteClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.info == nil then
    return
  end
  if DataCenter.ActMigrationManager:SharePersonInvite(self.info.uid) then
    self.market:UpdateInvite(self.index)
    self.info.bInvited = true
    self:SetData(self.info)
  end
end

function UILWMailDetailMigrationMarketItem:SetData(info, index, market)
  self.info = info
  self.index = index
  self.market = market
  self.head:ParseHeadInfo(info)
  self.lv_text:SetText(info.lv)
  local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(info.flag or info.countryflag)
  local flagPath = nationTemplate ~= nil and nationTemplate:GetNationFlagPath() or nil
  if not string.IsNullOrEmpty(flagPath) then
    self.flag:LoadSprite(flagPath)
  end
  self.name_text:SetText(UIUtil.FormatAllianceAndName(nil, info.name, info.uid))
  self.power_text:SetText(string.GetFormattedSeparatorNum(math.floor(info.power)))
  self.server_text:SetLocalText("migration_activity_interface_10128", info.serverId, info.abbr)
  local bInvited = info.bInvited
  local bNew = not bInvited
  if bNew then
    local signTime = DataCenter.ActMigrationManager:GetMarketTime()
    bNew = signTime < info.time
  end
  self.btn:SetActive(not bInvited)
  self.tag:SetActive(bNew)
  self.state_text:SetActive(bInvited)
end

return UILWMailDetailMigrationMarketItem
