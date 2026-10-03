local rapidjson = require("rapidjson")
local PushUtil = BaseClass("PushUtil")

function PushUtil:__init()
  self._pushInfoDic = {}
end

function PushUtil:pushNotice(noticeInfo)
  self:CancelPush(noticeInfo:GetPushId(), noticeInfo:GetPushType())
  if noticeInfo:GetPushTime() <= 0 then
    return
  end
  local pushId = noticeInfo:GetPushId()
  local pushItem = LocalController:instance():getLine(TableName.APS_PUSH, pushId)
  local push_times = pushItem:getValue("times")
  if not string.IsNullOrEmpty(push_times) then
    push_times = tonumber(push_times)
    if 1 < push_times then
      local curTime = CS.PushNoticeManager.GetPushCountById(pushId)
      if push_times <= curTime then
        return
      end
    end
  end
  local intervalTime = 0
  local type_value = pushItem:getValue("type_value")
  if not string.IsNullOrEmpty(type_value) then
    intervalTime = tonumber(type_value) * 60
  end
  self:PushNoticeToList(noticeInfo, intervalTime)
end

function PushUtil:PushNoticeToList(noticeInfo, intervalTime)
  local pushId = noticeInfo:GetPushId()
  if self._pushInfoDic[pushId] == nil then
    self._pushInfoDic[pushId] = {}
  end
  local notice_list = self._pushInfoDic[pushId]
  local notice_cnt = table.count(notice_list)
  local isNeedAdd = false
  if 0 < intervalTime and 0 < notice_cnt then
    for index = 1, notice_cnt do
      if index == 1 and intervalTime < notice_list[index]:GetPushTime() - noticeInfo:GetPushTime() then
        notice_list[#notice_list + 1] = noticeInfo
        isNeedAdd = true
        break
      elseif index == notice_cnt and intervalTime < noticeInfo:GetPushTime() - notice_list[index]:GetPushTime() then
        notice_list[#notice_list + 1] = noticeInfo
        isNeedAdd = true
        break
      elseif intervalTime < noticeInfo:GetPushTime() - notice_list[index]:GetPushTime() and intervalTime < notice_list[index + 1]:GetPushTime() - noticeInfo:GetPushTime() then
        isNeedAdd = true
        notice_list[#notice_list + 1] = noticeInfo
        break
      end
    end
    if isNeedAdd then
      table.sort(notice_list, function(param1, param2)
        if param1:GetPushTime() > param2:GetPushTime() then
          return 1
        elseif param1:GetPushTime() == param2:GetPushTime() then
          return 0
        elseif param1:GetPushTime() == param2:GetPushTime() then
          return -1
        end
      end)
    end
  else
    isNeedAdd = true
    notice_list[#notice_list + 1] = noticeInfo
  end
  if isNeedAdd then
    local param = {}
    param.type = noticeInfo:GetPushType()
    param.time = noticeInfo:GetPushTime()
    param.body = noticeInfo:GetPushBody()
    param.soundKey = ""
    param.pushType = noticeInfo:GetPushType()
    param.playerMark = 1
    param.gameUid = LuaEntry.Player.uid
    param.pushId = noticeInfo:GetPushId()
    local strJson = rapidjson.encode(param)
    CS.PushNoticeManager.PushNotice(strJson)
  end
end

function PushUtil:CancelPush(pushId, pushType)
  local param = {}
  param.type = pushType
  CS.PushNoticeManager.CancelNotice(param)
  local notice_list = self._pushInfoDic[pushId]
  if notice_list then
    for index, noticeItem in pairs(notice_list) do
      if noticeItem:GetPushType() == pushType then
        notice_list[index] = nil
      end
    end
    if table.count(notice_list) == 0 then
      self._pushInfoDic[pushId] = nil
    end
  end
end

return PushUtil
