local base = UIBaseContainer
local SnowStormWorldInfoPlayerInfoGroup = BaseClass("SnowStormWorldInfoPlayerInfoGroup", base)
local Localization = CS.GameEntry.Localization
local playerParent_path = "playerList"
local headPrefab_path = "UIPlayerHead"
local scrollView_path = "ScrollView"
local count_path = "count1"

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
  self.playerParent = self:AddComponent(UIBaseContainer, playerParent_path)
  self.headPrefab = self:AddComponent(UIBaseContainer, headPrefab_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.count = self:AddComponent(UIText, count_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.playerParent = nil
  self.headPrefab = nil
  self.scrollView = nil
  self.count = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self:ClearScroll()
end

function SnowStormWorldInfoPlayerInfoGroup:SetData(list)
  self.list = list
  self:RefreshCollector()
end

function SnowStormWorldInfoPlayerInfoGroup:RefreshCollector()
  local total = #self.list
  self.count:SetText(Localization:GetString("season_s2_storm_event_16", total))
  if 0 < total then
    self.scrollView:SetTotalCount(total)
    self.scrollView:RefillCells(1, true)
  else
    self:ClearScroll()
  end
end

function SnowStormWorldInfoPlayerInfoGroup:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local player = self.list[index]
  local cellItem = self.scrollView:AddComponent(UICommonHead, itemObj)
  cellItem:SetHeadAndFrame(player.uid, player.headPic, player.headPicVer, false, player.headSkinId, player.headSkinET)
  cellItem:SetEnableClickShowInfo(true, true)
end

function SnowStormWorldInfoPlayerInfoGroup:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UICommonHead)
end

function SnowStormWorldInfoPlayerInfoGroup:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UICommonHead)
end

SnowStormWorldInfoPlayerInfoGroup.OnCreate = OnCreate
SnowStormWorldInfoPlayerInfoGroup.OnDestroy = OnDestroy
SnowStormWorldInfoPlayerInfoGroup.OnEnable = OnEnable
SnowStormWorldInfoPlayerInfoGroup.OnDisable = OnDisable
SnowStormWorldInfoPlayerInfoGroup.ComponentDefine = ComponentDefine
SnowStormWorldInfoPlayerInfoGroup.ComponentDestroy = ComponentDestroy
SnowStormWorldInfoPlayerInfoGroup.DataDefine = DataDefine
SnowStormWorldInfoPlayerInfoGroup.DataDestroy = DataDestroy
return SnowStormWorldInfoPlayerInfoGroup
