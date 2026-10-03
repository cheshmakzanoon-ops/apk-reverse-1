local PushOutpostBattleFinishMessage = BaseClass("PushOutpostBattleFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage
local FetchOutpostDetailInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostDetailInfoMessage")
local FetchOutpostBattleInfoMessage = require("Net.Msgs.Season5.Outpost.FetchOutpostBattleInfoMessage")

function PushOutpostBattleFinishMessage:OnCreate()
  base.OnCreate(self)
end

function PushOutpostBattleFinishMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local curServerId = LuaEntry.Player:GetCurServerId()
  local cityId = toInt(t.cityId)
  if cityId <= 0 then
    return
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
  if t.state == 2 then
    SeasonUtil.PlayDestroyVfxByCityId(curServerId, cityId, true)
  elseif SceneUtils.GetIsInWorld() then
    local theWorld = CS.SceneManager.World
    if theWorld then
      theWorld:SetFirstViewRequestFlag(true)
      theWorld:UpdateViewRequest(true)
    end
  end
end

return PushOutpostBattleFinishMessage
