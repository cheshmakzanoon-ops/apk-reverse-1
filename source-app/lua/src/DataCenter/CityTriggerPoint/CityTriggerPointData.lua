local CityTriggerPointData = BaseClass("CityTriggerPointData")
local Const = require("Scene.CityPioneer.Const")

function CityTriggerPointData:__init()
  self.id = 0
  self.giveRes = {}
  self.needRes = {}
end

function CityTriggerPointData:__delete()
end

function CityTriggerPointData:GetPointArray()
  return self.temp.posArr
end

function CityTriggerPointData:SetData(temp)
  self.temp = temp
  if temp.unlockType ~= nil then
    for i, t in ipairs(temp.unlockType) do
      if temp.unlockPara ~= nil and temp.unlockPara[i] then
        self.needRes[t] = temp.unlockPara[i]
      end
    end
  end
end

function CityTriggerPointData:GetTemplateId()
  return self.temp.id
end

function CityTriggerPointData:GiveRes(t, n)
  local num = self.giveRes[t] or 0
  num = num + n
  self.giveRes[t] = num
  local showPos = self.pos
  if showPos then
    local p = SceneUtils.TileToWorld(showPos)
    DataCenter.CityPioneerYellowArrowManager:RemoveOneArrowByPos(p)
  end
end

function CityTriggerPointData:SetGiveRes(t, n)
  self.giveRes[t] = n
end

function CityTriggerPointData:GetGiveRes(t)
  return self.giveRes[t] or 0
end

function CityTriggerPointData:GetAllNeedRes()
  return self.needRes
end

function CityTriggerPointData:GetTotalCnt()
  local cnt = 0
  if self.needRes == nil then
    return cnt
  end
  for _, v in pairs(self.needRes) do
    cnt = cnt + v
  end
  return cnt
end

function CityTriggerPointData:HasType(type)
  for t, need in pairs(self.needRes) do
    local resType = Const.UnlockToResType[t]
    if resType == type then
      return true
    end
  end
  return false
end

function CityTriggerPointData:IsFull()
  for t, need in pairs(self.needRes) do
    local give = self:GetGiveRes(t)
    if 0 < need - give then
      return false
    end
  end
  return true
end

function CityTriggerPointData:GetUnlockType()
  return self.temp.unlockRewardType
end

function CityTriggerPointData:GetUnlockBuilding()
  return self.temp.unlockRewardPara
end

function CityTriggerPointData:GetUnlockFog()
  return self.temp.unlockRewardPara
end

function CityTriggerPointData:GetGuideId()
  return self.temp.unlockRewardPara
end

function CityTriggerPointData:GetAllGiveRes()
  return self.giveRes
end

function CityTriggerPointData:GetShowPos()
  return self.temp.showPos
end

function CityTriggerPointData:GetTag()
  return self.temp.tag
end

function CityTriggerPointData:GetTagPara()
  return self.temp.tagPara
end

function CityTriggerPointData:IsNeedShowArrow()
  local arrowShow = self.temp.arrowShow
  if arrowShow == nil or arrowShow == "" then
    return false
  end
  return tonumber(arrowShow) == 1
end

function CityTriggerPointData:IsWeaponType()
  return table.hasvalue(self.temp.unlockType, Const.CommitType.Weapon)
end

return CityTriggerPointData
