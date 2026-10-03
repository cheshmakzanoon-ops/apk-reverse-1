local UIPVERewardLayer = BaseClass("UIPVERewardLayer", UIBaseContainer)
local base = UIBaseContainer
local UIPVEResourceCell = require("UI.UIPVE.UIPVEMain.Component.UIPVEResourceCell")
local title_path = "Title"
local bg_path = "Bg"
local list_path = "Bg/List"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetLocalText(130065)
  self.bg_go = self:AddComponent(UIBaseContainer, bg_path)
  self.list_go = self:AddComponent(UIBaseContainer, list_path)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.bg_go = nil
  self.list_go = nil
end

local function DataDefine(self)
  self.resource = {}
end

local function DataDestroy(self)
  self.resource = nil
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

local function ReInit(self)
  self:Refresh()
end

local function AddOneCell(self, index, data)
  local param = {}
  param.icon = DataCenter.RewardManager:GetPicByType(data.rewardType, data.itemId)
  param.curNum = data.count
  param.index = index
  if self.resource[index] == nil then
    self.resource[index] = {}
    self.resource[index].param = param
    self.resource[index].req = self:GameObjectInstantiateAsync(UIAssets.UIPveNeedResourceCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.list_go.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsFirstSibling()
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.resource[index].model = self.list_go:AddComponent(UIPVEResourceCell, nameStr)
      self.resource[index].model:ReInit(self.resource[index].param)
    end)
  elseif self.resource[index].model ~= nil then
    self.resource[index].model:ChangeParam(param)
  else
    self.resource[index].param = param
  end
end

local function RemoveOneCell(self, id)
  if self.resource[id] ~= nil and self.resource[id].req ~= nil then
    self.resource[id].req:Destroy()
    self.resource[id] = nil
  end
end

local function Refresh(self)
  self.list = DataCenter.BattleLevel:GetAllFrontRewardGot()
  if self.list ~= nil then
    local count = table.count(self.list)
    if count == 0 then
      self.title_text:SetActive(false)
      self.bg_go:SetActive(false)
    else
      self.title_text:SetActive(true)
      self.bg_go:SetActive(true)
    end
    for k, v in ipairs(self.list) do
      self:AddOneCell(k, v)
    end
    local curCount = table.count(self.resource)
    if count < curCount then
      for i = count + 1, curCount do
        self:RemoveOneCell(i)
      end
    end
  else
    self.title_text:SetActive(false)
    self.bg_go:SetActive(false)
  end
end

UIPVERewardLayer.OnCreate = OnCreate
UIPVERewardLayer.OnDestroy = OnDestroy
UIPVERewardLayer.ComponentDefine = ComponentDefine
UIPVERewardLayer.ComponentDestroy = ComponentDestroy
UIPVERewardLayer.DataDefine = DataDefine
UIPVERewardLayer.DataDestroy = DataDestroy
UIPVERewardLayer.OnEnable = OnEnable
UIPVERewardLayer.OnDisable = OnDisable
UIPVERewardLayer.OnAddListener = OnAddListener
UIPVERewardLayer.OnRemoveListener = OnRemoveListener
UIPVERewardLayer.AddOneCell = AddOneCell
UIPVERewardLayer.RemoveOneCell = RemoveOneCell
UIPVERewardLayer.ReInit = ReInit
UIPVERewardLayer.Refresh = Refresh
return UIPVERewardLayer
