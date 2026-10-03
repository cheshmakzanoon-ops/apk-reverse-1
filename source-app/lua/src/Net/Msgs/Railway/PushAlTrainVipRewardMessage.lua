local PushAlTrainVipRewardMessage = BaseClass("PushAlTrainVipRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushAlTrainVipRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAlTrainVipRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local type = t.type
    if type then
      local name = t.name
      if name then
        if type == 0 then
          UIUtil.ShowTips(Localization:GetString("alliance_train_vip050", name))
        elseif type == 1 then
          UIUtil.ShowTips(Localization:GetString("alliance_train_vip051", name))
        end
      end
    end
  end
end

return PushAlTrainVipRewardMessage
