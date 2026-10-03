local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local PuzzleRewardItem = BaseClass("PuzzleRewardItem", UIBaseContainer)
local base = UIBaseContainer
local item_path = "UICommonResItem"

local function OnCreate(self)
  base.OnCreate(self)
  self.item = self:AddComponent(MailRewardItem, item_path)
end

local function OnDestroy(self)
  self.item = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data)
  self.item:RefreshData(data)
end

PuzzleRewardItem.OnCreate = OnCreate
PuzzleRewardItem.OnDestroy = OnDestroy
PuzzleRewardItem.OnEnable = OnEnable
PuzzleRewardItem.OnDisable = OnDisable
PuzzleRewardItem.RefreshData = RefreshData
return PuzzleRewardItem
