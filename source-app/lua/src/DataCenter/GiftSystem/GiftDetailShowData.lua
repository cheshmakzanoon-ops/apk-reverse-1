local GiftDetailShowData = BaseClass("GiftDetailShowData")
local Localization = CS.GameEntry.Localization

function GiftDetailShowData:__init()
  self.itemId = nil
  self.giftDetailSet = {
    contentState = 1,
    maxState = 1,
    firstState = 1,
    contentId = 0,
    count = 0
  }
  self.contentObj = {senderUid = "", content = ""}
  self.maxObj = {senderUid = "", num = 0}
  self.firstObj = {senderUid = "", sendTime = 0}
end

function GiftDetailShowData:__delete()
  self.itemId = nil
  self.giftDetailSet = nil
  self.contentObj = nil
  self.maxObj = nil
  self.firstObj = nil
end

function GiftDetailShowData:UpdateData(data)
  if data == nil then
    return
  end
  self.itemId = data.itemId
  if data.giftDetailSet ~= nil then
    self.giftDetailSet.contentState = data.giftDetailSet.contentState or 1
    self.giftDetailSet.maxState = data.giftDetailSet.maxState or 1
    self.giftDetailSet.firstState = data.giftDetailSet.firstState or 1
    self.giftDetailSet.contentId = data.giftDetailSet.contentId or 0
    self.giftDetailSet.count = data.giftDetailSet.count or 0
  end
  if data.contentObj ~= nil then
    self.contentObj = data.contentObj
  end
  if data.maxObj ~= nil then
    self.maxObj = data.maxObj
  end
  if data.firstObj ~= nil then
    self.firstObj = data.firstObj
  end
end

function GiftDetailShowData:UpdateChangeData(data)
  if data == nil or data.params == nil then
    return
  end
  if data.params.contentState ~= nil then
    self.giftDetailSet.contentState = data.params.contentState
  end
  if data.params.maxState ~= nil then
    self.giftDetailSet.maxState = data.params.maxState
  end
  if data.params.firstState ~= nil then
    self.giftDetailSet.firstState = data.params.firstState
  end
  if data.params.contentId ~= nil then
    self.giftDetailSet.contentId = data.params.contentId
  end
  if data.contentObj ~= nil then
    self.contentObj = data.contentObj
  end
  if data.params.count ~= nil then
    self.giftDetailSet.count = data.params.count
  end
end

function GiftDetailShowData:SendSetDataMsg(isContentStateSet, isMaxStateSet, isFirstStateSet, newContentId, newCount)
  local sendContentState = isContentStateSet and 1 - self.giftDetailSet.contentState or self.giftDetailSet.contentState
  local sendMaxState = isMaxStateSet and 1 - self.giftDetailSet.maxState or self.giftDetailSet.maxState
  local sendFirstState = isFirstStateSet and 1 - self.giftDetailSet.firstState or self.giftDetailSet.firstState
  local sendContentId = newContentId
  local temp = DataCenter.GiftSystemManager:GetGiftGoods(self.itemId)
  if newCount then
    if temp == nil then
      newCount = 0
    elseif 0 < #temp.group_id then
      local getGroupId = false
      for i, v in ipairs(temp.group_id) do
        if tonumber(v) == tonumber(newCount) then
          getGroupId = true
          break
        end
      end
      if not getGroupId then
        newCount = tonumber(temp.group_id[1])
      end
    else
      newCount = 0
    end
  end
  local sendCount = newCount
  SFSNetwork.SendMessage(MsgDefines.SetGiftDetail, self.itemId, sendContentState, sendMaxState, sendFirstState, sendContentId, sendCount)
end

return GiftDetailShowData
