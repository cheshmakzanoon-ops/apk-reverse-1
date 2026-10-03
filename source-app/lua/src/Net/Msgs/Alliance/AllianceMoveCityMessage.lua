local AllianceMoveCityMessage = BaseClass("AllianceMoveCityMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, costType, isInviteMove, pinMsgUUid)
  base.OnCreate(self)
  self.sfsObj:PutInt("costType", costType)
  local byInvite = isInviteMove and 1 or 0
  self.sfsObj:PutInt("byInvite", byInvite)
  if (costType == 4 or costType == 5) and pinMsgUUid then
    self.sfsObj:PutLong("uuid", pinMsgUUid)
  end
  if not LuaEntry.Player:IsLoginSourceServer() then
    self.sfsObj:PutInt("type", MoveCrossServerType.BackToSrcServer)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.firstFreeMoveAlliance then
      LuaEntry.Player:InitFirstFreeAlliance(t.firstFreeMoveAlliance)
    end
    if t.crossMoveCDEnd then
      DataCenter.LeagueMatchManager:SetCrossMoveCDEnd(t.crossMoveCDEnd)
    end
    if t.result then
      if t.result == 1 then
        GoToUtil.CloseAllWindows()
        DataCenter.BuildManager:WorldMvHandle(t, 240)
        if t.lastFreeMoveTime then
          LuaEntry.Player:SetLastFreeMvTime(t.lastFreeMoveTime)
        end
        if t.gold then
          LuaEntry.Player.gold = t.gold
          EventManager:GetInstance():Broadcast(EventId.UpdateGold)
        end
        UIUtil.ShowTipsId(455107)
        if t.serverInfo and (t.serverInfo.ip or t.serverInfo.ws_ip or t.serverInfo.zone or t.serverInfo.port) then
          DataCenter.AllianceCompeteDataManager:MoveCrossServerHandle(t)
        end
      elseif t.result == 2 then
        if t.byInvite and t.byInvite == 1 then
          local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
          if allianceInfo and not string.IsNullOrEmpty(allianceInfo.leaderUid) then
            UIUtil.ShowMessage(Localization:GetString("391081"), 1, "390086", "", function()
              local userId = allianceInfo.leaderUid
              local roomId = ChatManager2:GetInstance().Room:GetPrivateRoomByUserId(userId)
              local param = {}
              param.roomId = roomId
              param.userId = userId
              param.username = allianceInfo.leaderName
              GoToUtil.OpenChatView(true, {
                anim = false,
                hideTop = true,
                UIMainAnim = UIMainAnimType.AllHide
              }, param)
            end)
          end
        else
          UIUtil.ShowTipsId(391081)
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SetMovingUI, UIMovingType.Close)
  EventManager:GetInstance():Broadcast(EventId.RefreshMainAlEvent, true)
end

AllianceMoveCityMessage.OnCreate = OnCreate
AllianceMoveCityMessage.HandleMessage = HandleMessage
return AllianceMoveCityMessage
