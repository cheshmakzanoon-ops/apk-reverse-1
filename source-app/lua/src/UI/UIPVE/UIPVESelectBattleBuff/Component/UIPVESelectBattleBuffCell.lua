local UIPVESelectBattleBuffCell = BaseClass("UIPVESelectBattleBuffCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local submit_btn_path = "Bg"
local buff_icon_path = "Bg/BuffIcon"
local des_text_path = "Bg/Txt"
local QualityBg = {
  [1] = "UIBattleBuff_bg_green",
  [2] = "UIBattleBuff_bg_blue",
  [3] = "UIBattleBuff_bg_purple",
  [4] = "UIBattleBuff_bg_orange",
  [5] = "UIBattleBuff_bg_red"
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
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.submit_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSubmitBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.submit_btn = nil
  self.buff_icon = nil
  self.des_text = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
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
  self.trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(param.triggerId)
  local descList = {}
  local line = LocalController:instance():getLine(TableName.BattleBuff, param.buffId)
  if line == nil then
    return
  end
  local buffListStr = tostring(line:getValue("buffId"))
  local icon = tostring(line:getValue("icon"))
  local localType = tonumber(line:getValue("LocalType"))
  local strs = string.split(buffListStr, "|")
  for _, str in ipairs(strs) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      local buff = tonumber(spls[1])
      local val = tonumber(spls[2])
      local desc = GetTableData(TableName.EffectNumDesc, buff, "des")
      local descStr = Localization:GetString(desc)
      local valStr = CommonUtil.GetValueWithLocalType(val, localType)
      table.insert(descList, descStr .. " " .. valStr)
    end
  end
  self.des_text:SetText(string.join(descList, "\n"))
  self.submit_btn:LoadSprite(string.format(LoadPath.UIPveBattleBuff, QualityBg[param.quality]))
  self.buff_icon:LoadSprite(string.format(LoadPath.UIPveBattleBuff, icon))
end

local function OnSubmitBtnClick(self)
  local levelId = DataCenter.BattleLevel.levelId
  SFSNetwork.SendMessage(MsgDefines.SelectPveBuff, levelId, self.param.triggerId, self.param.buffGroupId, self.param.buffId)
  DataCenter.BattleLevel:DoTrigger(self.trigger, true)
  self.view.ctrl:CloseSelf()
end

UIPVESelectBattleBuffCell.OnCreate = OnCreate
UIPVESelectBattleBuffCell.OnDestroy = OnDestroy
UIPVESelectBattleBuffCell.ComponentDefine = ComponentDefine
UIPVESelectBattleBuffCell.ComponentDestroy = ComponentDestroy
UIPVESelectBattleBuffCell.DataDefine = DataDefine
UIPVESelectBattleBuffCell.DataDestroy = DataDestroy
UIPVESelectBattleBuffCell.OnEnable = OnEnable
UIPVESelectBattleBuffCell.OnDisable = OnDisable
UIPVESelectBattleBuffCell.OnAddListener = OnAddListener
UIPVESelectBattleBuffCell.OnRemoveListener = OnRemoveListener
UIPVESelectBattleBuffCell.ReInit = ReInit
UIPVESelectBattleBuffCell.OnSubmitBtnClick = OnSubmitBtnClick
return UIPVESelectBattleBuffCell
