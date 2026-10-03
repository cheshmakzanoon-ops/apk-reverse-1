local DesAssistanceCell = BaseClass("DesAssistanceCell", UIBaseContainer)
local PlayerInfoCell = require("UI.LWUICityBreach.Component.PlayerInfoCell")
local base = UIBaseContainer

function DesAssistanceCell:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function DesAssistanceCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DesAssistanceCell:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "bg")
  self.text = self:AddComponent(UIText, "Text")
  if self.transform:Find("assistanceInfoList") ~= nil then
    self.assistanceInfoList = self:AddComponent(UIScrollView, "assistanceInfoList")
    self.assistanceInfoList:SetOnItemMoveIn(function(itemObj, index)
      self:OnCreateCell(itemObj, index)
    end)
    self.assistanceInfoList:SetOnItemMoveOut(function(itemObj, index)
      self:OnDeleteCell(itemObj, index)
    end)
  end
end

function DesAssistanceCell:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.assistanceInfoList:AddComponent(PlayerInfoCell, itemObj)
  item:ReInit(self.param.assistanceDatas[index])
end

function DesAssistanceCell:OnDeleteCell(itemObj, index)
  self.assistanceInfoList:RemoveComponent(itemObj.name, PlayerInfoCell)
end

function DesAssistanceCell:ClearScroll()
  self.assistanceInfoList:ClearCells()
  self.assistanceInfoList:RemoveComponents(PlayerInfoCell)
end

function DesAssistanceCell:ShowScroll()
  self:ClearScroll()
  local count = #self.param.assistanceDatas
  self.assistanceInfoList:SetTotalCount(count)
  if 0 < count then
    self.assistanceInfoList:RefillCells()
  end
end

function DesAssistanceCell:ComponentDestroy()
  if self.assistanceInfoList then
    self.assistanceInfoList = nil
  end
  self.bg = nil
  self.text = nil
end

function DesAssistanceCell:DataDefine()
  self.param = nil
end

function DesAssistanceCell:DataDestroy()
end

function DesAssistanceCell:ReInit(param)
  self.param = param
  if self.param.type == "assistance" and self.param.assistanceDatas then
    self:ShowScroll()
  end
  if self.param.index % 2 == 0 then
    self.bg:SetAlpha(0.2)
  else
    self.bg:SetAlpha(0.3)
  end
  self.text:SetText(self.param.text)
end

return DesAssistanceCell
