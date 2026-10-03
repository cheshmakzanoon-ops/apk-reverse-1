local FetchSeasonFactionDeclareWarDetailMessage = BaseClass("FetchSeasonFactionDeclareWarDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonFactionDeclareWarDetailMessage:OnCreate(campId)
  base.OnCreate(self)
  self.sfsObj:PutInt("campId", campId)
end

function FetchSeasonFactionDeclareWarDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.list ~= nil and t.campId ~= nil then
    local dataList = {}
    local filter = {}
    for k, v in ipairs(t.list) do
      if filter[v.allianceId] == nil then
        filter[v.allianceId] = v
        table.insert(dataList, v)
      else
        Logger.LogError("\233\152\181\232\144\165\230\149\176\230\141\174\230\156\137\233\135\141\229\164\141! -> " .. v.allianceId .. " , " .. v.serverId)
      end
    end
    table.sort(dataList, function(a, b)
      if a.rank == b.rank then
        if a.resourceNum == b.resourceNum then
          return a.power < b.power
        end
        return a.resourceNum > b.resourceNum
      end
      return a.rank < b.rank
    end)
    if t.campId == SeasonFactionType.Rebels then
      DataCenter.SeasonFactionWarDataManager.dataList1 = dataList
    elseif t.campId == SeasonFactionType.Gendarmerie then
      DataCenter.SeasonFactionWarDataManager.dataList2 = dataList
    end
    DataCenter.SeasonFactionWarDataManager.targetAllianceId = t.targetAllianceId
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionGroupInfoUpdate)
  end
end

return FetchSeasonFactionDeclareWarDetailMessage
