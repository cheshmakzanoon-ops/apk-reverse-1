local base = require("UI.BattleFieldBase.Misc.AreaMiniMapBase")
local LWMainWinterStormMiniMap = BaseClass("LWMainWinterStormMiniMap", base)
local MyStrNull = string.IsNullOrEmpty
local bg_path = "bg"
local left_tip_path = "bg/LeftTip"
local time_txt_path = "bg/TimeTxt"
local MapScale = 1

function LWMainWinterStormMiniMap:OnDestroy()
  self.air_drop_img = nil
  base.OnDestroy(self)
end

function LWMainWinterStormMiniMap:GetBfType()
  return BattleFieldType.WinterStorm
end

function LWMainWinterStormMiniMap:GetMapScale()
  return MapScale
end

function LWMainWinterStormMiniMap:ComponentDefine()
  self.air_drop_bg = self:AddComponent(UIBaseContainer, bg_path)
  self.air_drop_text = self:AddComponent(UIText, time_txt_path)
  self.air_drop_img = self:AddComponent(UIImage, left_tip_path)
end

function LWMainWinterStormMiniMap:DoBaseGroundSpriteLoad()
  local mySide = self.actMgr:GetMySide()
  local diIdx = {
    mySide == 2 and 1 or -1,
    mySide == 2 and -1 or 1
  }
  for mainIndex, info in pairs(self.buildList) do
    if info.id == 1 or info.id == 2 then
      local ground = self.groundList[mainIndex]
      if ground then
        ground:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, self:GetDiName(diIdx[info.id])))
      end
    end
  end
end

function LWMainWinterStormMiniMap:DoRecycleItemEx(pointIndex)
  DataCenter.BattleFieldAnimManager:DeleteObj(pointIndex)
end

function LWMainWinterStormMiniMap:DoBuildingChangeEx(pointIndex)
  if self.dropToPlay then
    DataCenter.BattleFieldAnimManager:PlayDrop(pointIndex)
    self.dropToPlay = false
  end
end

function LWMainWinterStormMiniMap:GetSpValueTransIdx(value)
  if value == 2 or value == 3 then
    return value - 1
  end
end

function LWMainWinterStormMiniMap:GetIdxToSpValue(mainIndex)
  if mainIndex == 1 or mainIndex == 2 then
    return mainIndex + 1
  end
end

function LWMainWinterStormMiniMap:CheckSpIndex(index, bRes)
  if index == 1 or index == 2 then
    return true
  end
  if bRes and (index < 10 or 20 < index) then
    return true
  end
end

function LWMainWinterStormMiniMap:PreUpdate()
  local result = self.actMgr:GetResult()
  if result ~= nil then
    return true
  end
end

function LWMainWinterStormMiniMap:AfterUpdate()
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local mr = self.actMgr:GetMarchResult()
  local tipTemplate
  local remainTime = 0
  local preTime = 2
  if mr ~= nil then
    local sTime = mr.battleBeginTime
    local eTime = mr.battleEndTime
    for _, v in pairs(self.triggerList or {}) do
      local rTime = sTime + v.trigger_time
      if v.type == 5 then
        if curSec == rTime then
          EventManager:GetInstance():Broadcast(EventId.WinterStormNoticeNewShow, {
            config = v,
            actTime = preTime,
            time = eTime - curSec
          })
        end
      elseif tipTemplate == nil then
        local stTime = rTime - v.alert_time
        if curSec == stTime then
          EventManager:GetInstance():Broadcast(EventId.WinterStormNoticeNewShow, {config = v, actTime = preTime})
        elseif curSec >= stTime + preTime and curSec < rTime then
          tipTemplate = v
          remainTime = rTime - curSec
        end
      end
    end
  end
  self.air_drop_bg:SetActive(tipTemplate ~= nil)
  if tipTemplate ~= nil then
    self.air_drop_text:SetText(remainTime)
    if self.curId ~= tipTemplate.id then
      self.curId = tipTemplate.id
      if not MyStrNull(tipTemplate.icon) then
        self.air_drop_img:SetActive(true)
        self.air_drop_img:LoadSpriteAsyncWithCallback(tipTemplate.icon, function()
          if self.air_drop_img then
            self.air_drop_img:SetNativeSize()
          end
        end)
      else
        self.air_drop_img:SetActive(false)
      end
    end
  end
end

function LWMainWinterStormMiniMap:PreRefreshCheck(bInit, mainIndex, config)
  if not bInit and config ~= nil and config:IsDrop() and not self.stateList[mainIndex] then
    self.dropToPlay = true
  end
end

return LWMainWinterStormMiniMap
