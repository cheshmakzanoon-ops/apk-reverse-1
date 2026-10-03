local UIPVEGainBuff = BaseClass("UIPVEGainBuff", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local icon_path = "SafeArea/Icon"
local name_path = "SafeArea/Name"
local desc_path = "SafeArea/Desc"
local fly_target_path = "SafeArea/FlyTarget"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg_btn = self:AddComponent(UIButton, bg_path)
  self.bg_btn:SetOnClick(function()
    self:OnConfirm()
  end)
  self.icon_image = self:AddComponent(UIImage, icon_path)
  self.name_text = self:AddComponent(UIText, name_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.fly_target_go = self:AddComponent(UIBaseContainer, fly_target_path)
end

local function ComponentDestroy(self)
  self.bg_btn = nil
  self.icon_image = nil
  self.name_text = nil
  self.desc_text = nil
  self.fly_target_go = nil
end

local function DataDefine(self)
  self.battleBuffId = nil
end

local function DataDestroy(self)
  self.battleBuffId = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
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

local function ReInit(self)
  local battleBuffId = self:GetUserData()
  local descList = {}
  local line = LocalController:instance():getLine(TableName.BattleBuff, battleBuffId)
  if line == nil then
    self.ctrl:CloseSelf()
    return
  end
  local buffListStr = tostring(line:getValue("buffId"))
  local name = line:getValue("name")
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
  self.battleBuffId = battleBuffId
  self.icon = string.format(LoadPath.UIPveBattleBuff, icon)
  if not string.IsNullOrEmpty(name) then
    self.name_text:SetLocalText(name)
  else
    self.name_text:SetText("")
  end
  self.desc_text:SetText(string.join(descList, "\n"))
  self.icon_image:LoadSprite(self.icon)
end

local function OnConfirm(self)
  UIUtil.DoFlyCustom(self.icon, nil, 1, self.icon_image.transform.position, self.fly_target_go.transform.position, 50, 50)
  self.ctrl:CloseSelf()
end

UIPVEGainBuff.OnCreate = OnCreate
UIPVEGainBuff.OnDestroy = OnDestroy
UIPVEGainBuff.OnEnable = OnEnable
UIPVEGainBuff.OnDisable = OnDisable
UIPVEGainBuff.ComponentDefine = ComponentDefine
UIPVEGainBuff.ComponentDestroy = ComponentDestroy
UIPVEGainBuff.DataDefine = DataDefine
UIPVEGainBuff.DataDestroy = DataDestroy
UIPVEGainBuff.OnAddListener = OnAddListener
UIPVEGainBuff.OnRemoveListener = OnRemoveListener
UIPVEGainBuff.ReInit = ReInit
UIPVEGainBuff.OnConfirm = OnConfirm
return UIPVEGainBuff
