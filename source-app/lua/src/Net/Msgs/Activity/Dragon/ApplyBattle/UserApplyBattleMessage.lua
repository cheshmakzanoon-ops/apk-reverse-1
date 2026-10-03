local UserApplyBattleMessage = BaseClass("UserApplyBattleMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function UserApplyBattleMessage:OnCreate(apply, chooseTimeList)
  base.OnCreate(self)
  self.sfsObj:PutInt("apply", apply)
  local list = SFSArray.New()
  table.walk(chooseTimeList, function(k, v)
    list:AddInt(v)
  end)
  self.sfsObj:PutSFSArray("chooseTimeList", list)
end

function UserApplyBattleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    local time = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k7", 24)
    if errCode == 501066 or errCode == 501103 then
      UIUtil.ShowTips(Localization:GetString("376092", time))
    elseif errCode == 376167 then
      UIUtil.ShowTips(376167)
      UIUtil.ShowTips(Localization:GetString("376167", time))
    elseif errCode == 458258 or errCode == "458258" then
      UIUtil.ShowTips(Localization:GetString(errCode, time))
    else
      UIUtil.ShowTips(Localization:GetString(errCode))
    end
    return
  end
  UIUtil.ShowTipsId("458188")
  DataCenter.ActDragonManager:SendGetPlayerList()
end

return UserApplyBattleMessage
