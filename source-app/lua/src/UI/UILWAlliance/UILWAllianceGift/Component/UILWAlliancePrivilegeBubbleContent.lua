local base = UIBaseContainer
local UILWAlliancePrivilegeBubbleContent = BaseClass("UILWAlliancePrivilegeBubbleContent", base)
local UILWAlliancePrivilegeItemRender = require("UI.UILWAlliance.UILWAllianceGift.Component.UILWAlliancePrivilegeItemRender")
local closePrivilegeBubbleBtn_path = "ClosePrivilegeBubbleBtn"
local alliancePrivilegeBubbleTipsText_path = "cfm_tongyon_tip_kuang/AlliancePrivilegeBubbleTipsText"
local alliancePrivilegeScrollView_path = "cfm_tongyon_tip_kuang/AlliancePrivilegeScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearScrollView()
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
  self.closePrivilegeBubbleBtn = self:AddComponent(UIButton, closePrivilegeBubbleBtn_path)
  self.alliancePrivilegeBubbleTipsText = self:AddComponent(UIText, alliancePrivilegeBubbleTipsText_path)
  self.alliancePrivilegeScrollView = self:AddComponent(UIScrollView, alliancePrivilegeScrollView_path)
  self.alliancePrivilegeBubbleTipsText:SetLocalText("alliance_gift_title_01")
  self.closePrivilegeBubbleBtn:SetOnClick(function()
    self:SetActive(false)
  end)
  self.alliancePrivilegeScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.alliancePrivilegeScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.closePrivilegeBubbleBtn = nil
  self.alliancePrivilegeBubbleTipsText = nil
  self.alliancePrivilegeScrollView = nil
end

local function DataDefine(self)
  local allTemplatesDict = DataCenter.LWAllianceRightShowTemplateManager:GetAllTemplates()
  self.allTemplates = table.values(allTemplatesDict)
  local rightsOpenState = LuaEntry.DataConfig:CheckSwitch("alliance_train_vip")
  if not rightsOpenState then
    for i = #self.allTemplates, 1, -1 do
      if self.allTemplates[i].is_train_right == 1 then
        table.remove(self.allTemplates, i)
      end
    end
  end
  table.sort(self.allTemplates, function(a, b)
    return a.id < b.id
  end)
end

local function DataDestroy(self)
  self.allTemplates = nil
end

local function ShowView(self)
  self:SetActive(true)
  local count = table.count(self.allTemplates)
  if 0 < count then
    self.alliancePrivilegeScrollView:SetTotalCount(count)
    self.alliancePrivilegeScrollView:RefillCells()
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.alliancePrivilegeScrollView:AddComponent(UILWAlliancePrivilegeItemRender, itemObj)
  if itemRender ~= nil then
    itemRender:ReInit(self.allTemplates[index])
  end
end

local function OnItemMoveOut(self, itemObj, index)
  self.alliancePrivilegeScrollView:RemoveComponent(itemObj.name, UILWAlliancePrivilegeItemRender)
end

local function ClearScrollView(self)
  self.alliancePrivilegeScrollView:ClearCells()
  self.alliancePrivilegeScrollView:RemoveComponents(UILWAlliancePrivilegeItemRender)
end

local function SetActive(self, isActive)
  self.gameObject:SetActive(isActive)
end

UILWAlliancePrivilegeBubbleContent.OnCreate = OnCreate
UILWAlliancePrivilegeBubbleContent.OnDestroy = OnDestroy
UILWAlliancePrivilegeBubbleContent.OnEnable = OnEnable
UILWAlliancePrivilegeBubbleContent.OnDisable = OnDisable
UILWAlliancePrivilegeBubbleContent.ComponentDefine = ComponentDefine
UILWAlliancePrivilegeBubbleContent.ComponentDestroy = ComponentDestroy
UILWAlliancePrivilegeBubbleContent.DataDefine = DataDefine
UILWAlliancePrivilegeBubbleContent.DataDestroy = DataDestroy
UILWAlliancePrivilegeBubbleContent.ShowView = ShowView
UILWAlliancePrivilegeBubbleContent.OnItemMoveIn = OnItemMoveIn
UILWAlliancePrivilegeBubbleContent.OnItemMoveOut = OnItemMoveOut
UILWAlliancePrivilegeBubbleContent.ClearScrollView = ClearScrollView
UILWAlliancePrivilegeBubbleContent.SetActive = SetActive
return UILWAlliancePrivilegeBubbleContent
