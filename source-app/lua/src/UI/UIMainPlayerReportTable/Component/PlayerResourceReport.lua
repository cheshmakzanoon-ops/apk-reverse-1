local PlayerResourceReport = BaseClass("PlayerResourceReport", UIBaseContainer)
local base = UIBaseContainer
local PlayerResourceReportCell = require("UI.UIMainPlayerReportTable.Component.PlayerResourceReportCell")
local Localization = CS.GameEntry.Localization
local content_path = "ScrollView/Viewport/Content"
local own_path = "Obj/Text"
local need_path = "Obj/Text1"
local output_path = "Obj/Text2"
local capacity_path = "Obj/Text3"
local space_path = "Obj/Text4"
local month_path = "Obj/Text5"

local function OnCreate(self)
  base.OnCreate(self)
  self.own = self:AddComponent(UIText, own_path)
  self.need = self:AddComponent(UIText, need_path)
  self.output = self:AddComponent(UIText, output_path)
  self.capacity = self:AddComponent(UIText, capacity_path)
  self.space = self:AddComponent(UIText, space_path)
  self.month = self:AddComponent(UIText, month_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.own:SetLocalText(100039)
  self.need:SetLocalText(GameDialogDefine.NEED)
  self.output:SetLocalText(100041)
  self.capacity:SetLocalText(100042)
  self.space:SetLocalText(100043)
  self.month:SetText("month")
  self.item_prefab = self.transform:Find("PlayerResourceReportCell").gameObject
  self.item_prefab:GameObjectCreatePool()
end

local function OnDestroy(self)
  self.own = nil
  self.need = nil
  self.output = nil
  self.capacity = nil
  self.space = nil
  self.month = nil
  self.content = nil
  self.items = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:OnRefresh(self)
end

local function OnDisable(self)
  self.content:RemoveComponents(PlayerResourceReportCell)
  base.OnDisable(self)
end

local function OnRefresh(self)
  local list = self.view.ctrl:GetResourceShowList(self.view.ctrl)
  if list ~= nil then
    for i = 1, table.length(list) do
      local item = self.item_prefab:GameObjectSpawn(self.content.transform)
      item.name = "item" .. i
      self.content:AddComponent(PlayerResourceReportCell, item.name, list[i])
    end
  end
end

PlayerResourceReport.OnCreate = OnCreate
PlayerResourceReport.OnDestroy = OnDestroy
PlayerResourceReport.OnRefresh = OnRefresh
PlayerResourceReport.OnEnable = OnEnable
PlayerResourceReport.OnDisable = OnDisable
return PlayerResourceReport
