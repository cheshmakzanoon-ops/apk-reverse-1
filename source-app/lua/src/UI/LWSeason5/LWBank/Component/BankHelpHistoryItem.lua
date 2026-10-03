local base = UIBaseContainer
local BankHelpHistoryItem = BaseClass("BankHelpHistoryItem", base)
local bg_path = "bg"
local head_path = "head"
local name_path = "name"
local desc_path = "desc"
local time_path = "Txt_Time"

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
  self.bg = self:AddComponent(UIImage, bg_path)
  self.head = self:AddComponent(UIBaseContainer, head_path)
  self.name = self:AddComponent(UIText, name_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.time = self:AddComponent(UIText, time_path)
end

local function ComponentDestroy(self)
  if self.headReq then
    self.headReq:Destroy()
    self.headReq = nil
  end
  self.bg = nil
  self.head = nil
  self.name = nil
  self.desc = nil
  self.time = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function BankHelpHistoryItem:ReInit(data, index)
  self:RefreshInfo(data.logTypeCode, data.logTime, data.amount, data.depositDays, data.finalAmount)
  self:RefreshHead(data.user)
  self:RefreshName(data.user)
end

function BankHelpHistoryItem:RefreshInfo(type, time, save, day, value)
  local subTitle = DataCenter.SeasonBankTemplateManager.subTitle[type]
  local bg = DataCenter.SeasonBankTemplateManager.titleBg[type]
  if not subTitle or not bg then
    return
  end
  self.desc:SetLocalText(subTitle, save, day, value or 0)
  self.bg:LoadSpriteAsync(bg)
  if time then
    self.time:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(time, false))
  else
    self.time:SetText("")
  end
end

function BankHelpHistoryItem:RefreshName(head)
  if string.IsNullOrEmpty(head.abbr) then
    self.name:SetText(string.format("#%s%s", head.serverId, head.name))
  else
    self.name:SetText(string.format("#%s[%s]%s", head.serverId, head.abbr, head.name))
  end
end

function BankHelpHistoryItem:RefreshHead(head)
  self.headData = head
  if self.headCell then
    self.headCell:ParseHeadInfo(self.headData)
    self.headCell:SetEnableClickShowInfo(true, true)
    return
  end
  if not self.headReq then
    self.headReq = self:GameObjectInstantiateAsync(UIAssets.UIPlayerHead, function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local trans = obj.transform
      trans:SetParent(self.head.transform)
      trans.localScale = Vector3.one
      trans.localPosition = Vector3.zero
      trans:Set_pivot(0.5, 0.5)
      trans:Set_sizeDelta(150, 150)
      obj.name = "headCell"
      local headCell = self.head:AddComponent(UICommonHead, obj.name)
      headCell:ParseHeadInfo(self.headData)
      headCell:SetEnableClickShowInfo(true, true)
      self.headCell = headCell
    end)
  end
end

BankHelpHistoryItem.OnCreate = OnCreate
BankHelpHistoryItem.OnDestroy = OnDestroy
BankHelpHistoryItem.OnEnable = OnEnable
BankHelpHistoryItem.OnDisable = OnDisable
BankHelpHistoryItem.ComponentDefine = ComponentDefine
BankHelpHistoryItem.ComponentDestroy = ComponentDestroy
BankHelpHistoryItem.DataDefine = DataDefine
BankHelpHistoryItem.DataDestroy = DataDestroy
return BankHelpHistoryItem
