local ISeasonDonateInterface = BaseClass("ISeasonDonateInterface")

function ISeasonDonateInterface:__init(data)
  self.data = data
end

function ISeasonDonateInterface:__delete()
end

function ISeasonDonateInterface:GetProgressInfo()
end

function ISeasonDonateInterface:GetProgressIcon()
end

function ISeasonDonateInterface:GetExtraIcon()
end

function ISeasonDonateInterface:GetExtraCount(selectList)
  local extraCount = 0
  for id, count in pairs(selectList) do
    local meta = DataCenter.FishMetaManager:GetMeta(id)
    extraCount = extraCount + meta.military_num * count
  end
  local add = LuaEntry.Effect:GetGameEffect(EffectDefine.Military_ADD_PERCENT)
  return extraCount, extraCount * add
end

function ISeasonDonateInterface:GetDonateInfo()
end

function ISeasonDonateInterface:GetShowDonateList()
end

function ISeasonDonateInterface:ToDonate(selectList)
end

function ISeasonDonateInterface:RecoverTimeFinish()
end

return ISeasonDonateInterface
