local LWUICityRebuildNewView = BaseClass("LWUICityRebuildNewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
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
  self.panelBtn = self:AddComponent(UIButton, "panel")
  self.receiveBtn = self:AddComponent(UIButton, "panel/Bg/receive")
  self.panelBtn:SetOnClick(function()
    self:OnReceiveBtnClick()
  end)
  self.receiveBtn:SetOnClick(function()
    self:OnReceiveBtnClick()
  end)
  self.rewardContent = self:AddComponent(UIBaseContainer, "panel/Bg/list/rewardList/Viewport/Content")
  self.descText = self:AddComponent(UIText, "panel/Bg/descText")
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.receiveBtn = nil
  self.rewardContent = nil
  self.descText = nil
end

local function DataDefine(self)
  self.rewards = DataCenter.CityRebuildDataManager:GetRebuildRewardInfo()
  self.inCity = self:GetUserData()
  self.cells = {}
  self.asyncModels = {}
end

local function DataDestroy(self)
  self:ClearRewardItems()
  self.rewards = nil
  self.cells = nil
  self.asyncModels = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function LWUICityRebuildNewView:ClearRewardItems()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.asyncModels then
    for _, v in pairs(self.asyncModels) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.asyncModels = {}
  self.cells = {}
end

function LWUICityRebuildNewView:ShowRewardList()
  self:ClearRewardItems()
  for i = 1, #self.rewards do
    self.asyncModels[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.rewardContent.transform)
      go.transform:Set_localScale(0.9, 0.9, 0.9)
      go.name = "item" .. i
      local cell = self.rewardContent:AddComponent(UICommonResItem, go.name)
      cell:ReInit(self.rewards[i])
      self.cells[i] = go
    end)
  end
end

local function OnReceiveBtnClick(self)
  self.gameObject:SetActive(false)
  if self.rewards then
    local cfg = {}
    for i, v in pairs(self.cells) do
      if v and not IsNull(v.transform) and self.rewards[i] then
        table.insert(cfg, {
          v.transform.position,
          self.rewards[i]
        })
      end
    end
    DataCenter.CityRebuildDataManager:SetFlyRewardData(cfg)
  end
  self.ctrl:CloseSelf()
  DataCenter.CityRebuildAniManager:StartAnimator(self.inCity)
  self.inCity = nil
end

local function InitData(self)
  local descStr = LuaEntry.DataConfig:TryGetStr("alliance_rescue_config", "k5")
  if descStr then
    local result = {}
    for segment in string.gmatch(descStr, "([^;]+)") do
      table.insert(result, segment)
    end
    local alliance = DataCenter.CityRebuildDataManager:GetAllianceInfoInfo()
    if LuaEntry.Player:IsInAlliance() then
      self.descText:SetLocalText(result[1], LuaEntry.Player:GetFullAllianceName())
    elseif alliance and alliance.allianceName then
      self.descText:SetLocalText(result[2], "[" .. alliance.abbr .. "]" .. alliance.allianceName)
    else
      self.descText:SetLocalText(result[3])
    end
  end
  if self.rewards and #self.rewards > 0 then
    self:ShowRewardList()
  end
end

LWUICityRebuildNewView.OnCreate = OnCreate
LWUICityRebuildNewView.OnDestroy = OnDestroy
LWUICityRebuildNewView.OnEnable = OnEnable
LWUICityRebuildNewView.OnDisable = OnDisable
LWUICityRebuildNewView.ComponentDefine = ComponentDefine
LWUICityRebuildNewView.ComponentDestroy = ComponentDestroy
LWUICityRebuildNewView.DataDefine = DataDefine
LWUICityRebuildNewView.DataDestroy = DataDestroy
LWUICityRebuildNewView.OnAddListener = OnAddListener
LWUICityRebuildNewView.OnRemoveListener = OnRemoveListener
LWUICityRebuildNewView.OnReceiveBtnClick = OnReceiveBtnClick
LWUICityRebuildNewView.InitData = InitData
return LWUICityRebuildNewView
