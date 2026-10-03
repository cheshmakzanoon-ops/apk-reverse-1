local MainVirusInfo = BaseClass("MainVirusInfo", UIBaseContainer)
local base = UIBaseContainer
local MainVirusInfoItem = require("UI.UILWMail.UILWMailMain.Component.MainVirusInfoItem")

function MainVirusInfo:OnCreate()
  self.info = nil
  base.OnCreate(self)
end

function MainVirusInfo:OnDestroy()
  self:ClearLayout()
  self.info = nil
  base.OnDestroy(self)
end

function MainVirusInfo:parseEffect(index, player)
  if not player.effects then
    return
  end
  local effectBefore
  for k, v in ipairs(player.effects) do
    if v.effectId == EffectDefine.APS_SEASON_VIRUS_EFFECT then
      if not effectBefore then
        effectBefore = v.value or 0
      else
        if v.value then
          effectBefore = v.value
        end
        local reason, change, strEffect = self:ParseReasons(v.reasons, effectBefore, index)
        if not self.info then
          self.info = {
            effectId = v.effectId,
            reason = 0,
            left = {},
            right = {}
          }
        end
        if reason ~= 0 then
          self.info.reason = reason
        end
        local changeData = index == 1 and self.info.left or self.info.right
        changeData.reason = reason
        changeData.before = effectBefore
        changeData.change = change
        changeData.effectStr = strEffect
      end
    end
  end
end

function MainVirusInfo:ParseReasons(reasons, value, index)
  if table.IsNullOrEmpty(reasons) then
    return 0, 0, string.format("%d", value or 0)
  end
  local strEffect = string.format("%d", value or 0)
  local reason, change = 0
  for _, OneReason in pairs(reasons) do
    if OneReason.reason and OneReason.value then
      change = OneReason.value
      local theVirus = toInt(math.abs(change))
      if 0 < change then
        strEffect = strEffect .. string.format("<color=#E64141> + %s</color>", theVirus)
      elseif change < 0 then
        strEffect = strEffect .. string.format("<color=#E64141> - %s</color>", theVirus)
      end
      reason = index == 1 and OneReason.reason or -OneReason.reason
      break
    end
  end
  return reason, change, strEffect
end

function MainVirusInfo:fetchEffect(playerList)
  if playerList then
    local player1 = playerList[1]
    local player2 = playerList[2]
    if player1 and player2 then
      self:parseEffect(1, player1)
      self:parseEffect(2, player2)
    end
  end
end

function MainVirusInfo:SetData(data)
  self:ClearLayout()
  self.infoList = {}
  if data == nil then
    return false
  end
  if data.battleType ~= MailBattleReportType.DARK_KNIGHT_MONSTER_ATTACK_ALLIANCE_CITY and (data.targetType == MailTargetType.DragonBuild or data.targetType == MailTargetType.WinterStormBuilding or data.targetType == MailTargetType.EpidemicBuild) then
    return false
  end
  local playerList = data.player
  if playerList then
    self:fetchEffect(playerList)
    if not self.info and data.round then
      for k1, v1 in ipairs(data.round) do
        if v1 and v1.battle then
          for k2, v2 in ipairs(v1.battle) do
            if v2 and v2.player then
              self:fetchEffect(v2.player)
              if self.info then
                break
              end
            end
          end
          if self.info then
            break
          end
        end
      end
    end
    if self.info then
      self:RefreshLayout()
      return true
    end
  end
  return false
end

function MainVirusInfo:RefreshLayout()
  self:ClearLayout()
  self.req = self:GameObjectInstantiateAsync(UIAssets.VirusChange, function(req)
    if IsNull(req.gameObject) then
      return
    end
    local item = req.gameObject
    item.name = "VirusChange"
    item.transform:SetParent(self.transform)
    item.transform:Set_localScale(1, 1, 1)
    local obj = self:AddComponent(MainVirusInfoItem, item.name)
    obj:SetData(self.info.left.effectStr or 0, self.info.right.effectStr or 0, self.info.reason or 0)
  end)
end

function MainVirusInfo:ClearLayout()
  self:RemoveComponents(MainVirusInfoItem)
  if self.req then
    self:GameObjectDestroy(self.req)
    self.req = nil
  end
end

return MainVirusInfo
