local UIPositionAddCtrl = BaseClass("UIPositionAddCtrl", UIBaseCtrl)

function UIPositionAddCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPositionAdd)
end

function UIPositionAddCtrl:CheckIfCanAddAllianceMark()
  if not LuaEntry.Player:IsInAlliance() then
    return false
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    return false
  end
  return true
end

function UIPositionAddCtrl:CheckIfCanShowCountryMark()
  return DataCenter.LandlordMgr:CanShowWarZoneMark()
end

function UIPositionAddCtrl:CheckIfCanAddCountryMark()
  if self:CheckIfCanShowCountryMark() then
    local myServer = LuaEntry.Player:GetSourceServerId()
    return LuaEntry.Player:IsPresident(myServer) or LuaEntry.Player:IsFirstLady(myServer)
  end
  return false
end

function UIPositionAddCtrl:GetCDTimeTextList(max_hour, max_min)
  max_hour = max_hour or 99
  max_min = max_min or 59
  local hour_list = {}
  local min_list = {}
  for i = 0, max_hour do
    if i < 10 then
      table.insert(hour_list, "0" .. tostring(i))
    else
      table.insert(hour_list, tostring(i))
    end
  end
  for i = 0, max_min do
    if i < 10 then
      table.insert(min_list, "0" .. tostring(i))
    else
      table.insert(min_list, tostring(i))
    end
  end
  return hour_list, min_list
end

function UIPositionAddCtrl:GetTimingTimeTextList(max_day, max_hour, max_min)
  max_day = max_day or 7
  max_hour = max_hour or 23
  max_min = max_min or 59
  local data_list = {}
  local hour_list = {}
  local min_list = {}
  local cur_time = UITimeManager:GetInstance():GetServerTime()
  cur_time = math.modf(cur_time / 1000)
  for i = 0, max_day do
    table.insert(data_list, UITimeManager:GetInstance():GetTimeToMD(cur_time + i * 24 * 60 * 60))
  end
  for i = 0, max_hour do
    if i < 10 then
      table.insert(hour_list, "0" .. tostring(i))
    else
      table.insert(hour_list, tostring(i))
    end
  end
  for i = 0, max_min do
    if i < 10 then
      table.insert(min_list, "0" .. tostring(i))
    else
      table.insert(min_list, tostring(i))
    end
  end
  return data_list, hour_list, min_list
end

function UIPositionAddCtrl:CalcTimeStampByDate(day, hour, min, zeroStamp)
  if not zeroStamp then
    return
  end
  day = day or 0
  hour = hour or 0
  min = min or 0
  local target_time_stamp = day * 24 * 60 * 60 + hour * 60 * 60 + min * 60
  target_time_stamp = zeroStamp + target_time_stamp * 1000
  return target_time_stamp
end

function UIPositionAddCtrl:AddBookMark(point, server, name, type, topFlag, param)
  if name ~= nil and name ~= "" then
    if DataCenter.WorldFavoDataManager:CheckBookMarkNameLength(name) then
      DataCenter.WorldFavoDataManager:AddBookmark(point, server, name, type, topFlag, param)
      self:CloseSelf()
    end
  else
    UIUtil.ShowTipsId(GameDialogDefine.PLEASE_INPUT_NUM)
  end
end

function UIPositionAddCtrl:AddAllianceMark(point, server, name, type, planTimeStamp, notice, param)
  if notice == nil then
    notice = true
  end
  if name and name ~= "" then
    if DataCenter.WorldFavoDataManager:CheckBookMarkNameLength(name) then
      DataCenter.WorldFavoDataManager:TryAddAllianceMask(point, server, type, name, planTimeStamp, notice, param)
      self:CloseSelf()
    end
  else
    UIUtil.ShowTipsId(GameDialogDefine.PLEASE_INPUT_NUM)
  end
end

function UIPositionAddCtrl:DelAllianceMark(markType)
  DataCenter.WorldFavoDataManager:TryDelAllianceMask(markType)
  self:CloseSelf()
end

function UIPositionAddCtrl:AddCountryMark(markType, point, worldId, serverId, pointInfo, planTimeStamp, notice)
  if notice == nil then
    notice = true
  end
  DataCenter.WorldFavoDataManager:TryAddCountryMask(markType, point, worldId, serverId, pointInfo, planTimeStamp, notice)
  self:CloseSelf()
end

function UIPositionAddCtrl:DelCountryMark(markType)
  DataCenter.WorldFavoDataManager:TryDelCountryMask(markType)
  self:CloseSelf()
end

function UIPositionAddCtrl:DelBookMark(selectItem)
  SFSNetwork.SendMessage(MsgDefines.WorldFavoDel, selectItem.pos, selectItem.type, selectItem.server, selectItem.worldId)
end

return UIPositionAddCtrl
