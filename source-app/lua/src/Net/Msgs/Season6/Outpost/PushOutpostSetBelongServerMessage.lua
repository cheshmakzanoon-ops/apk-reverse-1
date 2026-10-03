local PushOutpostSetBelongServerMessage = BaseClass("PushOutpostSetBelongServerMessage", SFSBaseMessage)
local base = SFSBaseMessage
local FetchOutpostDetailInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostDetailInfoMessage")
local FetchOutpostBattleInfoMessage = require("Net.Msgs.Season5.Outpost.FetchOutpostBattleInfoMessage")

function PushOutpostSetBelongServerMessage:OnCreate()
  base.OnCreate(self)
end

function PushOutpostSetBelongServerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local cityId = toInt(t.cityId)
  if cityId <= 0 then
    return
  end
  if SceneUtils.GetIsInWorld() then
    local world = CS.SceneManager.World
    if world then
      world:SetFirstViewRequestFlag(true)
      world:UpdateViewRequest(true)
    end
  end
  FetchOutpostDetailInfo.OutpostOwnerChanged(t)
  if not FetchOutpostBattleInfoMessage.OutpostOwnerChanged(t) then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSeasonOutpostAttackS5) then
      SFSNetwork.SendMessage(MsgDefines.FetchOutpostBattleInfo)
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSeasonOutpostAttackS6) then
      SFSNetwork.SendMessage(MsgDefines.FetchOutpostBattleInfo)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.OutpostBattleFinish, cityId)
  SFSNetwork.SendMessage(MsgDefines.FetchOutpostPosList)
  SFSNetwork.SendMessage(MsgDefines.FetchSourceMapOutpostList)
end

return PushOutpostSetBelongServerMessage
