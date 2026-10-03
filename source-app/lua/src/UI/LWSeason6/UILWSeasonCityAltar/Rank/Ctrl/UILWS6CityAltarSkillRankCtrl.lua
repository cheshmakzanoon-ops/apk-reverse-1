local UILWS6CityAltarSkillRankCtrl = BaseClass("UILWS6CityAltarSkillRankCtrl", UIBaseCtrl)

function UILWS6CityAltarSkillRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWS6CityAltarSkillRank)
end

function UILWS6CityAltarSkillRankCtrl:ParseRankData(rankData)
  if rankData == nil then
    return nil
  end
  local rankList = rankData.list
  local ret = {}
  for _, v in ipairs(rankList) do
    local oneData = {}
    oneData.uid = v.uid
    oneData.allianceId = v.allianceId
    oneData.serverId = v.serverId
    oneData.isAlliance = false
    oneData.rank = v.rank
    oneData.score = v.score
    oneData.pic = v.pic
    oneData.picVer = v.picVer
    oneData.headFrame = DataCenter.DecorationDataManager:GetHeadFrame(v.headSkinId, v.headSkinET, false)
    oneData.icon = v.icon
    oneData.firstName = v.name
    if not string.IsNullOrEmpty(v.abbr) then
      oneData.firstName = "[" .. v.abbr .. "] " .. v.name
    end
    table.insert(ret, oneData)
  end
  return ret
end

function UILWS6CityAltarSkillRankCtrl:GetSelfData(rankData)
  if rankData == nil then
    return nil
  end
  local rankType = rankData.skill
  local oneData = {}
  oneData.uid = LuaEntry.Player.uid
  oneData.allianceId = LuaEntry.Player.allianceId
  oneData.serverId = LuaEntry.Player.serverId
  oneData.type = rankType
  oneData.isAlliance = false
  oneData.pic = LuaEntry.Player:GetPic()
  oneData.picVer = LuaEntry.Player.picVer
  oneData.headFrame = LuaEntry.Player:GetHeadBgImg()
  oneData.firstName = LuaEntry.Player:GetFullName()
  local curData = rankData.userInfo
  if curData ~= nil then
    oneData.rank = checknumber(curData.rank)
    oneData.score = checknumber(curData.score)
  end
  return oneData
end

return UILWS6CityAltarSkillRankCtrl
