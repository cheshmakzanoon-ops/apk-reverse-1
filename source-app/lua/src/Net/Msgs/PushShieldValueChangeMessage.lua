local PushShieldValueChangeMessage = BaseClass("PushShieldValueChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushShieldValueChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if not SceneUtils.GetIsInWorld() then
      return
    end
    local pointId = t.pointId
    local shieldType = t.shieldType
    local addedValue = t.addedValue
    if shieldType == 1 then
      if 0 < addedValue then
        UIUtil.ShowBuildingPopIconText(pointId, "+" .. addedValue, 0, UIUtil.HexToColor32("FFFFFF"), "Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saijijianzhu_dunpaiicon_01.png")
      else
        UIUtil.ShowBuildingPopIconText(pointId, "-" .. addedValue, 0, UIUtil.HexToColor32("FFFFFF"), "Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saijijianzhu_dunpaiicon_01.png")
      end
    elseif shieldType == 2 then
      local text = CS.GameEntry.Localization:GetString("season_mastery_s6_tips_5", "<color=#fdc839>" .. addedValue .. "</color>")
      local operator = t.operator
      local sender = {
        uid = operator.uid,
        name = operator.name,
        pic = operator.headPic,
        picVer = operator.headPicVer
      }
      UIUtil.ShowThumbsUpBroadcastPopUI(LuaEntry.Player:GetCurServerId(), pointId, sender, text, "Assets/Main/SeasonRes/S6/Sprites/Mastery/lyt_S6_jiagu.png", "Assets/Main/SeasonRes/S6/Prefabs/World/ReinforceWallMessageTip.prefab")
      if 0 <= DisplaySettings.GetCurrentDisplayLevel() then
        MasteryEffectManager:GetInstance():OnReinforceWallEffect(pointId)
      end
      EventManager:GetInstance():Broadcast(EventId.PushWorldWallBarRefresh, pointId)
    end
  end
end

return PushShieldValueChangeMessage
