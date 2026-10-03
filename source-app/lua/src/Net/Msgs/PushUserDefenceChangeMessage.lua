local PushUserDefenceChangeMessage = BaseClass("PushUserDefenceChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushUserDefenceChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushUserDefenceChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.nowDurability ~= nil then
    DataCenter.DefenceWallDataManager:UpdateCurDurability(t)
  end
  if t.cityBroken ~= nil then
    local state = t.cityBroken
    if state == true then
      if t.uid == LuaEntry.Player.uid then
        if BattleFieldUtil.InBattleField() then
          UIUtil.ShowMessage(Localization:GetString("300543"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            GoToUtil.GotoDragonBuildPos()
          end, function()
            GoToUtil.GotoDragonBuildPos()
          end)
        else
          UIUtil.ShowMessage(Localization:GetString("300543"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            GoToUtil.GotoMainBuildPos()
          end, function()
            GoToUtil.GotoMainBuildPos()
          end)
        end
      end
      return
    end
  end
  BuildBloodManager:GetInstance():ShowCityBlood(t)
end

return PushUserDefenceChangeMessage
