local ActCalendarActivityData = BaseClass("ActCalendarActivityData")

function ActCalendarActivityData:__init()
  self.durationDays = 0
end

function ActCalendarActivityData:__delete()
  self.template = nil
  self.propsList = nil
  self.propsDic = nil
end

function ActCalendarActivityData:OnUpdateServerData(serverData)
  if serverData == nil then
    return
  end
  self:_updateGiftList(serverData)
  self:_updateAttribute(serverData, "calendarDisplay")
  self:_updateAttribute(serverData, "calendarCountdown")
  self:_updateAttribute(serverData, "calendarColor")
  self:_updateAttribute(serverData, "endTimeStr")
  self:_updateAttribute(serverData, "beginTimeStr")
  self:_updateAttribute(serverData, "calendarAddGroup")
  self:_updateAttribute(serverData, "calendarBanner")
  self:_updateAttribute(serverData, "beginTime")
  self:_updateAttribute(serverData, "endTime")
  self:_updateAttribute(serverData, "calendarDes")
  self:_updateAttribute(serverData, "aid")
  self:_updateAttribute(serverData, "calendarIcon")
  self:_updateAttribute(serverData, "calendarBannerPriority")
  self:_updateAttribute(serverData, "calendarGroupPriority")
  self:_updateAttribute(serverData, "isNew")
  self:_updateAttribute(serverData, "name")
end

function ActCalendarActivityData:_initTemplate()
  if not self.aid or self.aid <= 0 then
    Logger.LogError("aid is error.  aid:" .. tostring(self.aid))
    return
  end
  self.template = LocalController:instance():getValue(TableName.Activity, self.aid)
end

function ActCalendarActivityData:_updateGiftList(serverData)
  if serverData and serverData.calendarGiftList then
    self.propsList = {}
    self.propsDic = {}
    self.calendarGiftList = serverData.calendarGiftList
    local propsStrList = string.split(self.calendarGiftList, "|")
    if propsStrList and 0 < #propsStrList then
      for i, str in ipairs(propsStrList) do
        local split = string.split(str, ",")
        if not string.IsNullOrEmpty(split[1]) then
          local propsData = DataCenter.RewardManager:ParseOneRewardStr(split[1])
          if propsData then
            if not propsData.itemColor and not string.IsNullOrEmpty(split[2]) then
              propsData.itemColor = tonumber(split[2])
            end
            table.insert(self.propsList, propsData)
            self.propsDic[propsData.itemId] = propsData
          else
            Logger.LogError("propsData is null!  check [calendarGiftList] in aid:" .. tostring(serverData.aid))
          end
        end
      end
    end
  end
end

function ActCalendarActivityData:_updateAttribute(serverData, key)
  if serverData[key] ~= nil then
    self[key] = serverData[key]
  end
end

function ActCalendarActivityData:GetDurationDays()
  if not self.durationDays or self.durationDays == 0 then
    local delta = self.endTime - self.beginTime
    self.durationDays = math.floor(delta / 86400 + 0.5)
  end
  return self.durationDays
end

function ActCalendarActivityData:GetBegin()
  return self.beginTime * 1000
end

function ActCalendarActivityData:GetEnd()
  return self.endTime * 1000
end

function ActCalendarActivityData:GetOrder()
  if not self.calendarGroupPriority then
    return 0
  end
  return self.calendarGroupPriority
end

function ActCalendarActivityData:HasProps(itemId)
  return self.propsDic ~= nil and self.propsDic[itemId] ~= nil
end

function ActCalendarActivityData:GetPropsList()
  return self.propsList
end

return ActCalendarActivityData
