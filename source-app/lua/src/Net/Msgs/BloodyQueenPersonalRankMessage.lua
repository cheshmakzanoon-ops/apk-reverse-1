local BloodyQueenPersonalRankMessage = BaseClass("BloodyQueenPersonalRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BloodyQueenPersonalRankMessage:OnCreate(activityCount, needDetail, thumbUpdate)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityCount", activityCount)
  if needDetail ~= nil then
    self.sfsObj:PutBool("needDetail", needDetail)
  end
  if thumbUpdate ~= nil then
    self.sfsObj:PutBool("thumbUpdate", thumbUpdate)
  end
end

function BloodyQueenPersonalRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.needDetail and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMain) then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIQueenOfBloodRankPop) then
      EventManager:GetInstance():Broadcast(EventId.PushBloodyQueenBattlePersonalRank, t)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIQueenOfBloodRankPop, {anim = true}, t)
    end
  else
    EventManager:GetInstance():Broadcast(EventId.PushBloodyQueenBattlePersonalRank, t)
  end
end

return BloodyQueenPersonalRankMessage
