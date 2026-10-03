local SeasonBuildGroundEasterEggs = BaseClass("SeasonBuildGroundEasterEggs")

function SeasonBuildGroundEasterEggs:Init(go)
  local seasonType = SeasonUtil.GetSeasonType(false, true)
  local config = DataCenter.SeasonEasterEggManager:GetConfig(seasonType)
  if config == nil then
    return
  end
  local comp = config.Script
  if comp ~= nil then
    CommonUtil.ProtectCall(function()
      self.EasterEggComp = comp.New()
      self.EasterEggComp:ReInit(go)
    end)
  end
end

function SeasonBuildGroundEasterEggs:Clear()
  if self.EasterEggComp ~= nil then
    CommonUtil.ProtectCall(function()
      self.EasterEggComp:Clear()
    end)
  end
end

return SeasonBuildGroundEasterEggs
