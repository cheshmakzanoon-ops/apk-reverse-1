local UIItemRevertResItemComView = BaseClass("UIItemRevertResItemComView", UIBaseContainer)
local base = UIBaseContainer
local UIItemRevertResItemComAuto = require("UI.UIItemRevert.Auto.UIItemRevertResItemComAuto")

function UIItemRevertResItemComView:OnCreate()
  base.OnCreate(self)
  self.binder = UIItemRevertResItemComAuto.New()
  self.binder:bind(self)
  self.isEnough = false
end

function UIItemRevertResItemComView:OnDestroy()
  self.binder:unbind(self)
  self.binder = nil
  base.OnDestroy(self)
end

function UIItemRevertResItemComView:SetData(data)
  if data.type > 0 then
    local param = {
      rewardType = data.type,
      itemId = data.id,
      count = data.num
    }
    self.bind_uicommonresitem:ReInit(param)
  else
    local rewardType1 = ResTypeToReward[data.id]
    if rewardType1 ~= nil then
      local param = {
        rewardType = rewardType1,
        itemId = data.id,
        count = data.num
      }
      self.bind_uicommonresitem:ReInit(param)
    else
      Logger.LogError("UIItemRevertResItemComView:SetData - Invalid resource type for item ID: " .. tostring(data.id))
    end
  end
  local remainingNum = data.own or 0
  self.txt_textremaining:SetLocalText("undo_system_inventory", self:FormatNum(remainingNum, data.id))
  self.isEnough = remainingNum >= data.num
  self.txt_textremaining:SetColor(self.isEnough and GreenColor or RedColor)
end

function UIItemRevertResItemComView:GetCntByResType(resourceType)
  if resourceType > ResourceType.Max and DataCenter.ItemTemplateManager:GetItemTemplate(resourceType) ~= nil then
    local item = DataCenter.ItemData:GetItemById(resourceType)
    if item ~= nil then
      return item.count
    end
    return 0
  end
  return LuaEntry.Resource:GetCntByResType(resourceType)
end

function UIItemRevertResItemComView:FormatNum(num, type)
  if type == ResourceType.People then
    if 10000 <= num then
      return string.GetFormattedStr(num)
    else
      return string.GetFormattedSeperatorNum(num)
    end
  else
    return string.GetFormattedStr(num)
  end
end

return UIItemRevertResItemComView
