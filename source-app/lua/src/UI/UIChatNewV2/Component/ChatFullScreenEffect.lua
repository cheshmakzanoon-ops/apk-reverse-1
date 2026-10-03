local base = UIBaseContainer
local ChatFullScreenEffect = BaseClass("ChatFullScreenEffect", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local EffectType = {BirthdayCake = 1}
local EffectConfig = {
  [EffectType.BirthdayCake] = {
    path = "Assets/Main/Prefabs/UI/LWMainUI/Birthday/Eff_ui_BirthdayWishes_cake.prefab",
    time = 6000,
    showRoomGroup = {
      [ChatGroupType.GROUP_ALLIANCE] = true,
      [ChatGroupType.GROUP_ALLIANCE_MANAGER] = true
    }
  }
}

function ChatFullScreenEffect:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ChatFullScreenEffect:OnDestroy()
  self:DestroyAllEffect()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatFullScreenEffect:ComponentDefine()
end

function ChatFullScreenEffect:ComponentDestroy()
end

function ChatFullScreenEffect:DataDefine()
  self.curRoomGroup = nil
  self.curEffectType = nil
  self.curEffectEndTime = nil
  self.curEffectShowRoomGroup = nil
  self.effectReqTab = {}
  self.effectObjTab = {}
  self.birthdayRedPacketEffectList = {}
  self.birthdayRedPacketEffectDict = {}
end

function ChatFullScreenEffect:DataDestroy()
  self.curRoomGroup = nil
  self.curEffectType = nil
  self.curEffectEndTime = nil
  self.curEffectShowRoomGroup = nil
  self.effectReqTab = nil
  self.effectObjTab = nil
  self.birthdayRedPacketEffectList = nil
  self.birthdayRedPacketEffectDict = nil
end

function ChatFullScreenEffect:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnChatViewRoomChange, self.OnRoomChange)
  self:AddUIListener(EventId.OnChatViewShowPrivateList, self.OnRoomChange)
  self:AddUIListener(EventId.OnChatBirthdayRedPacketLikeNumChange, self.OnBirthdayRedPacketLikeNumChange)
  self:AddUIListener(EventId.OnChatBirthdayRedPacketShow, self.OnChatBirthdayRedPacketShow)
end

function ChatFullScreenEffect:OnRemoveListener()
  self:RemoveUIListener(EventId.OnChatViewRoomChange, self.OnRoomChange)
  self:RemoveUIListener(EventId.OnChatViewShowPrivateList, self.OnRoomChange)
  self:RemoveUIListener(EventId.OnChatBirthdayRedPacketLikeNumChange, self.OnBirthdayRedPacketLikeNumChange)
  self:RemoveUIListener(EventId.OnChatBirthdayRedPacketShow, self.OnChatBirthdayRedPacketShow)
  base.OnRemoveListener(self)
end

function ChatFullScreenEffect:InitData()
  self:OnRoomChange()
end

function ChatFullScreenEffect:OnRoomChange()
  local roomGroup = DataCenter.ChatVieweDataManager.curSelectRoomGroup
  if roomGroup == self.curRoomGroup then
    return
  end
  self.curRoomGroup = roomGroup
  self.birthdayRedPacketEffectList = {}
  self.birthdayRedPacketEffectDict = {}
  self:OnEffectTypeRoomChange(roomGroup)
end

function ChatFullScreenEffect:OnEffectTypeRoomChange(roomGroup)
  if self.curEffectShowRoomGroup == roomGroup then
    return
  end
  if self.curEffectType then
    self.curEffectType = nil
    self.curEffectEndTime = nil
    self.curEffectShowRoomGroup = nil
    self:RefreshEffectShow()
  end
end

function ChatFullScreenEffect:TryShowEffect(effectType)
  local showEffectType = effectType
  if self.effectReqTab[showEffectType] then
    if self.effectObjTab[showEffectType] then
      self.effectObjTab[showEffectType]:SetActive(false)
      self.effectObjTab[showEffectType]:SetActive(true)
      local curTime = UITimeManager:GetInstance():GetServerTime()
      self.curEffectEndTime = curTime + EffectConfig[showEffectType].time
    end
  else
    local effectConfig = EffectConfig[showEffectType]
    local effectPath = effectConfig.path
    self.effectReqTab[showEffectType] = self:GameObjectInstantiateAsync(effectPath, function(request)
      if request.isError then
        return
      end
      local effectObj = request.gameObject
      if IsNull(effectObj) then
        return
      end
      self.effectObjTab[showEffectType] = effectObj
      effectObj.transform:SetParent(self.transform)
      local rectTransform = effectObj:GetComponent(typeof(CS.UnityEngine.RectTransform))
      if not IsNull(rectTransform) then
        rectTransform:Set_anchorMin(0.5, 1)
        rectTransform:Set_anchorMax(0.5, 1)
        rectTransform:Set_pivot(0.5, 1)
        rectTransform:Set_anchoredPosition(0, 0)
        rectTransform:Set_localScale(1, 1, 1)
      end
      if self.curEffectType == showEffectType then
        effectObj:SetActive(false)
        effectObj:SetActive(true)
        local curTime = UITimeManager:GetInstance():GetServerTime()
        self.curEffectEndTime = curTime + EffectConfig[showEffectType].time
      else
        effectObj:SetActive(false)
      end
    end)
  end
end

function ChatFullScreenEffect:RefreshEffectShow()
  for effectType, effectObj in pairs(self.effectObjTab) do
    effectObj:SetActive(effectType == self.curEffectType)
  end
end

function ChatFullScreenEffect:DestroyAllEffect()
  for effectType, effectReq in pairs(self.effectReqTab) do
    self:GameObjectDestroy(effectReq)
  end
  self.effectReqTab = nil
  self.effectObjTab = nil
end

function ChatFullScreenEffect:OnBirthdayRedPacketLikeNumChange(chatData)
  if self.curRoomGroup == nil or self.curRoomGroup ~= chatData.group then
    return
  end
  if self.curEffectType ~= nil then
    return
  end
  if EffectConfig[EffectType.BirthdayCake].showRoomGroup[self.curRoomGroup] then
    self.curEffectType = EffectType.BirthdayCake
    self.curEffectShowRoomGroup = self.curRoomGroup
    self.curEffectEndTime = nil
    self:TryShowEffect(self.curEffectType)
  end
end

function ChatFullScreenEffect:OnChatBirthdayRedPacketShow(chatData)
  if self.curRoomGroup == nil or self.curRoomGroup ~= chatData.group then
    return
  end
  if EffectConfig[EffectType.BirthdayCake].showRoomGroup[self.curRoomGroup] then
    local createTime = chatData.serverTime
    if not DataCenter.BirthdayDataManager:CheckTimeIsExpiredInRedPacketShowEffect(createTime) then
      local seqId = chatData.roomId .. "_" .. chatData.seqId
      if self.birthdayRedPacketEffectDict[seqId] == nil then
        local histroyDict = DataCenter.BirthdayDataManager:GetBirthdayRedPacketShowEffectDict()
        if histroyDict[tostring(seqId)] == nil then
          self.birthdayRedPacketEffectList[#self.birthdayRedPacketEffectList + 1] = seqId
          self.birthdayRedPacketEffectDict[seqId] = createTime
          self:TryPlayBirthdayEffect()
        end
      end
    end
  end
end

function ChatFullScreenEffect:TryPlayBirthdayEffect()
  local isPlaySuccess = false
  if self.curEffectType == nil and #self.birthdayRedPacketEffectList > 0 then
    local showSeqId = self.birthdayRedPacketEffectList[1]
    local showCreateTime = self.birthdayRedPacketEffectDict[showSeqId]
    self.birthdayRedPacketEffectDict[showSeqId] = nil
    table.remove(self.birthdayRedPacketEffectList, 1)
    DataCenter.BirthdayDataManager:AddBirthdayRedPacketShowEffectRecord(showSeqId, showCreateTime)
    self.curEffectType = EffectType.BirthdayCake
    self.curEffectShowRoomGroup = self.curRoomGroup
    self.curEffectEndTime = nil
    self:TryShowEffect(self.curEffectType)
    isPlaySuccess = true
  end
  return isPlaySuccess
end

function ChatFullScreenEffect:Update100MS()
  if self.curEffectEndTime and self.curEffectEndTime <= UITimeManager:GetInstance():GetServerTime() then
    self.curEffectType = nil
    self.curEffectEndTime = nil
    self.curEffectShowRoomGroup = nil
    if self:TryPlayBirthdayEffect() then
    else
      self:RefreshEffectShow()
    end
  end
end

return ChatFullScreenEffect
