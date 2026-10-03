local SiegeUtil = {}
local Localization = CS.GameEntry.Localization
local SiegeCampLang = {
  "new_city_activity_battle_tips1021",
  "new_city_activity_battle_tips1022",
  "new_city_activity_battle_tips1023"
}
local AllOutLang = {
  "new_city_activity_battle_tips1026",
  "new_city_activity_battle_tips1027",
  "new_city_activity_battle_tips1028"
}
local DISTANCE = 7

function SiegeUtil.ShowSiegeCampBubble(position, duration)
  local content = SiegeCampLang[math.random(3)]
  local bubbleParams = {}
  bubbleParams.fakePlotMeta = {
    duration = duration,
    appearance = 60001,
    content = content
  }
  position.y = position.y + 1
  bubbleParams.anchor = position
  bubbleParams.mode = "3D"
  local member = DataCenter.AllianceMemberDataManager:GetRandomMember()
  bubbleParams.playerInfo = {
    uid = member.uid,
    pic = member.pic,
    picVer = member.picVer,
    name = member.name
  }
  EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
end

function SiegeUtil.ShowAllOutHead(march, duration)
  local bubbleParams = {}
  bubbleParams.fakePlotMeta = {duration = duration}
  local targetPos = march.targetWorldPos
  local startPos = march.startWorldPos
  local direction = (startPos - targetPos).normalized
  local headPos = targetPos + direction * DISTANCE
  bubbleParams.anchor = headPos
  bubbleParams.mode = "3D"
  bubbleParams.playerInfo = {
    uid = march.ownerUid,
    pic = march.pic,
    picVer = march.picVer
  }
  EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
end

function SiegeUtil.ShowAllOutBubble(march, duration)
  local content = AllOutLang[math.random(3)]
  local bubbleParams = {}
  bubbleParams.fakePlotMeta = {duration = duration, content = content}
  local targetPos = march.targetWorldPos
  local startPos = march.startWorldPos
  local direction = (startPos - targetPos).normalized
  local headPos = targetPos + direction * DISTANCE
  bubbleParams.anchor = headPos + Vector3(0, 1, 0)
  bubbleParams.mode = "3D"
  EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
end

return ConstClass("SiegeUtil", SiegeUtil)
