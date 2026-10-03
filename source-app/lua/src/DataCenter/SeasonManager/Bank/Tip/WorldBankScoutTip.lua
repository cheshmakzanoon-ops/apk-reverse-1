local WorldBankScoutTip = BaseClass("WorldBankScoutTip")
local icon_path = "PosGo/Bg/icon"
local value_path = "PosGo/Bg/value"

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.value = self.transform:Find(value_path):GetComponent(typeof(CS.SuperTextMesh))
end

local function ComponentDestroy(self)
end

local function ShowMarchInfo(self, marchInfo)
  self.data = marchInfo
  self:UpdatePosition()
  self:RefreshBank()
end

local function UpdatePosition(self)
  self.transform.position = self.data:GetMarchCurPos()
end

local function RefreshBank(self)
  self.value.text = string.GetFormattedStr(self.data.bankDeposit or 0)
  local itemId = not string.IsNullOrEmpty(self.data.itemId) and self.data.itemId or 0
  local itemConf = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if itemConf then
    self.icon:LoadSprite(string.format(LoadPath.ItemPath, itemConf.icon))
  end
end

WorldBankScoutTip.OnCreate = OnCreate
WorldBankScoutTip.OnDestroy = OnDestroy
WorldBankScoutTip.ComponentDefine = ComponentDefine
WorldBankScoutTip.ComponentDestroy = ComponentDestroy
WorldBankScoutTip.ShowMarchInfo = ShowMarchInfo
WorldBankScoutTip.UpdatePosition = UpdatePosition
WorldBankScoutTip.RefreshBank = RefreshBank
return WorldBankScoutTip
