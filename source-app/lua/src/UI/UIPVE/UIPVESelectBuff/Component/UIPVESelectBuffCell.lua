local UIPVESelectBuffCell = BaseClass("UIPVESelectBuffCell", UIBaseContainer)
local base = UIBaseContainer
local submit_btn_path = "Bg"
local buff_icon_path = "BuffIcon"
local des_text_path = "Text_num"
local BgNameList = {
  "UIBattleBuff_bg_blue",
  "UIBattleBuff_bg_green",
  "UIBattleBuff_bg_purple",
  "UIBattleBuff_bg_orange",
  "UIBattleBuff_bg_red"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.submit_btn = self:AddComponent(UIButton, submit_btn_path)
  self.buff_icon = self:AddComponent(UIImage, buff_icon_path)
  self.bg_icon = self:AddComponent(UIImage, submit_btn_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.submit_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_select_pve_effect, false)
    self:OnSubmitBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.submit_btn = nil
  self.buff_icon = nil
  self.bg_icon = nil
  self.des_text = nil
end

local function DataDefine(self)
  self.param = nil
  self.trigger = nil
end

local function DataDestroy(self)
  self.param = nil
  self.trigger = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, param)
  self.param = param
  self.trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(self.param.triggerId)
  if self.trigger ~= nil and self.trigger.config.buffId ~= nil then
    local bgName = BgNameList[1]
    if self.param.index <= table.count(BgNameList) then
      bgName = BgNameList[self.param.index]
    end
    self.bg_icon:LoadSprite(string.format(LoadPath.UIPveBattleBuff, bgName))
    local buffTemplate = DataCenter.PveBuffTemplateManager:GetTemplate(self.trigger.config.buffId)
    if buffTemplate ~= nil then
      self.buff_icon:LoadSprite(string.format(LoadPath.PVEScene, buffTemplate.pic))
      self.des_text:SetLocalText(buffTemplate.des)
    end
  end
end

local function OnSubmitBtnClick(self)
  DataCenter.BattleLevel:DoTrigger(self.trigger, true)
  self.view:OnClick()
  self.view.ctrl:CloseSelf()
end

UIPVESelectBuffCell.OnCreate = OnCreate
UIPVESelectBuffCell.OnDestroy = OnDestroy
UIPVESelectBuffCell.ComponentDefine = ComponentDefine
UIPVESelectBuffCell.ComponentDestroy = ComponentDestroy
UIPVESelectBuffCell.DataDefine = DataDefine
UIPVESelectBuffCell.DataDestroy = DataDestroy
UIPVESelectBuffCell.OnEnable = OnEnable
UIPVESelectBuffCell.OnDisable = OnDisable
UIPVESelectBuffCell.OnAddListener = OnAddListener
UIPVESelectBuffCell.OnRemoveListener = OnRemoveListener
UIPVESelectBuffCell.ReInit = ReInit
UIPVESelectBuffCell.OnSubmitBtnClick = OnSubmitBtnClick
return UIPVESelectBuffCell
