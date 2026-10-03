local BoxItemDrawManager = BaseClass("BoxItemDrawManager")
local BoxItemDrawData = require("DataCenter/BoxItemDraw/BoxItemDrawData")
local BoxItemDrawTemplate = require("DataCenter/BoxItemDraw/BoxItemDrawTemplate")
local Localization = CS.GameEntry.Localization

function BoxItemDrawManager:__init()
  self.allDataDict = {}
  self:InitTemplateDict()
end

function BoxItemDrawManager:__delete()
  self.allDataDict = nil
end

function BoxItemDrawManager:InitUserData(msg)
  if msg == nil or table.IsNullOrEmpty(msg.itemGroupBoxes) then
    return
  end
  for i, v in pairs(msg.itemGroupBoxes) do
    if v.groupId ~= nil then
      self:UpdateUserData(v.groupId, v)
    end
  end
end

function BoxItemDrawManager:UpdateUserData(groupId, data)
  if self.allDataDict == nil then
    self.allDataDict = {}
  end
  if self.allDataDict[tostring(groupId)] == nil then
    local itemData = BoxItemDrawData.New()
    itemData:UpdateData(groupId, data)
    self.allDataDict[tostring(groupId)] = itemData
  else
    self.allDataDict[tostring(groupId)]:UpdateData(groupId, data)
  end
end

function BoxItemDrawManager:InitTemplateDict()
  self.templateDict = {}
  LocalController:instance():visitTable(TableName.Box_No_Put_Back, function(id, lineData)
    if lineData then
      local template = BoxItemDrawTemplate.New()
      template:InitData(lineData)
      if self.templateDict[tostring(template.group_id)] == nil then
        self.templateDict[tostring(template.group_id)] = {template}
      else
        table.insert(self.templateDict[tostring(template.group_id)], template)
      end
    end
  end)
end

function BoxItemDrawManager:GetBoxItemDrawTemplates(groupId)
  local id = tostring(groupId)
  if self.templateDict ~= nil then
    return self.templateDict[tostring(groupId)]
  end
end

function BoxItemDrawManager:GetUserData(groupId)
  if self.allDataDict == nil or self.allDataDict[tostring(groupId)] == nil then
    self:UpdateUserData(groupId, nil)
  end
  return self.allDataDict[tostring(groupId)]
end

function BoxItemDrawManager:IsSkipAnim()
  local key = "box_item_draw_skip_anim_"
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function BoxItemDrawManager:SetIsSkipAnim(isSkip)
  if isSkip then
    local key = "box_item_draw_skip_anim_"
    CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
  else
    local key = "box_item_draw_skip_anim_"
    CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, false)
  end
end

function BoxItemDrawManager:SendDrawMsg(itemId, num)
  SFSNetwork.SendMessage(MsgDefines.OpenItemGroupBox, {itemId = itemId, num = num})
end

function BoxItemDrawManager:OnOpenItemGroupBox(msg)
  if msg == nil then
    EventManager:GetInstance():Broadcast(EventId.BoxItemDrawShowDrawFailure)
    return
  end
  local itemGroupBox = msg.itemGroupBox
  local reward = msg.reward
  local bigClearAllRewards = msg.bigClearAllRewards
  local rewardIdList = msg.rewardIdList
  if not (itemGroupBox and reward) or not rewardIdList then
    EventManager:GetInstance():Broadcast(EventId.BoxItemDrawShowDrawFailure)
  else
    local groupId = itemGroupBox.groupId
    if groupId then
      self:UpdateUserData(groupId, itemGroupBox)
    end
    DataCenter.RewardManager:AddRewards(reward)
    if bigClearAllRewards then
      DataCenter.RewardManager:AddRewards(bigClearAllRewards)
    end
    EventManager:GetInstance():Broadcast(EventId.BoxItemDrawShowDrawSuccess, msg)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return BoxItemDrawManager
