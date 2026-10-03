local base = require("UI.BattleFieldBase.Misc.AreaMiniMapBase")
local LWMainEpidemicZoneMiniMap = BaseClass("LWMainEpidemicZoneMiniMap", base)
local bg_path = "bg"
local jifen_path = "jifen"
local MapScale = 0.8

function LWMainEpidemicZoneMiniMap:GetBfType()
  return BattleFieldType.EpidemicZone
end

function LWMainEpidemicZoneMiniMap:GetMapScale()
  return MapScale
end

function LWMainEpidemicZoneMiniMap:ComponentDefine()
  self.bgBtn = self:AddComponent(UIButton, bg_path)
  self.bgBtn:SetOnClick(function()
    self:OnMapShowClick()
  end)
  self.theJifen = self.transform:Find(jifen_path).gameObject
  self.theJifen:GameObjectCreatePool()
  local xp = CommonUtil.IsArabicAutoMirrorOpen() and 0 or 1
  self.bgBtn:SetAnchorMinXY(xp, 0)
  self.bgBtn:SetAnchorMaxXY(xp, 0)
  self.bgBtn:SetAnchoredPositionXY(-25, -30)
end

function LWMainEpidemicZoneMiniMap:ComponentDestroy()
  self.theJifen:GameObjectRecycleAll()
end

function LWMainEpidemicZoneMiniMap:DoBaseGroundSpriteLoad()
  local curSide = self.actMgr:GetCurSide()
  local diIdx = {
    0,
    0,
    0
  }
  if curSide == EpidemicBattleSide.Lord or curSide == EpidemicBattleSide.Default then
    diIdx[2] = -1
    diIdx[3] = -1
  elseif curSide == EpidemicBattleSide.FarmerL then
    diIdx[1] = -1
    diIdx[3] = 1
  elseif curSide == EpidemicBattleSide.FarmerR then
    diIdx[1] = -1
    diIdx[2] = 1
  end
  for mainIndex, info in pairs(self.buildList) do
    if info.id == 1 or info.id == 2 or info.id == 3 then
      local ground = self.groundList[mainIndex]
      if ground then
        ground:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldPath, self:GetDiName(diIdx[info.id])))
      end
    end
  end
end

function LWMainEpidemicZoneMiniMap:OnMapClick()
  if ActEpidemicUtils.InBattleGuide() then
    ActEpidemicUtils.Tips("\229\189\147\229\137\141\230\173\163\229\156\168\230\150\176\230\137\139\229\188\149\229\175\188\228\184\173\229\145\162")
    ActEpidemicUtils.ContinueBattleGuide()
    return
  end
  self:BaseMapClick()
  EventManager:GetInstance():Broadcast(EventId.GF_click_epidemic_guide_btn)
end

function LWMainEpidemicZoneMiniMap:GetSpValueTransIdx(value)
  if value == 2 then
    return 1
  elseif value == 4 then
    return 2
  elseif value == 5 then
    return 3
  end
end

function LWMainEpidemicZoneMiniMap:GetIdxToSpValue(mainIndex)
  if mainIndex == 1 then
    return 2
  elseif mainIndex == 2 then
    return 4
  elseif mainIndex == 3 then
    return 5
  end
end

function LWMainEpidemicZoneMiniMap:CheckSpIndex(index, bRes)
  if bRes and (index == 1 or index == 2 or index == 3) then
    return true
  end
end

function LWMainEpidemicZoneMiniMap:PreUpdate()
  if not self.click_jump:GetActive() then
    return true
  end
end

function LWMainEpidemicZoneMiniMap:AfterUpdate()
  local groupInfo = self.actMgr:GetCurGroup()
  local sTime = groupInfo ~= nil and groupInfo.startTime or 0
  local preTime = 2
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  for _, v in pairs(self.triggerList or {}) do
    local rTime = sTime + v.trigger_time
    local stTime = rTime - v.alert_time
    if curSec == stTime then
      EventManager:GetInstance():Broadcast(EventId.DragonNoticeShow, {config = v, actTime = preTime})
    end
  end
end

function LWMainEpidemicZoneMiniMap:SetUsingSkill()
  self.click_jump:SetActive(false)
end

function LWMainEpidemicZoneMiniMap:OnMapShowClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIEpidemicBattleMap)
end

return LWMainEpidemicZoneMiniMap
