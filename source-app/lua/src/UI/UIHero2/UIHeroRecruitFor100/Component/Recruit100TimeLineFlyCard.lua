local Recruit100TimeLineFlyCard = BaseClass("Recruit100TimeLineFlyCard")
local Resource = CS.GameEntry.Resource
local FIRST_MAIN_CARD_BOOM_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/UI/100chou/Eff_100chou_baofa_BIG.prefab"
local SEGMENT_COUNT = 20
local paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SEGMENT_COUNT)
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.boomEffPathaDic = {}
  self.boomEffPathaDic[HeroQualityType.Legendary] = "Assets/_Art_LastWar/Effect/Prefab/UI/100chou/Eff_100chou_baofa_cheng.prefab"
  self.boomEffPathaDic[HeroQualityType.Genius] = "Assets/_Art_LastWar/Effect/Prefab/UI/100chou/Eff_100chou_baofa_zi.prefab"
  self.boomEffPathaDic[HeroQualityType.Outstanding] = "Assets/_Art_LastWar/Effect/Prefab/UI/100chou/Eff_100chou_baofa_lan.prefab"
  self.trailEffPathaDic = {}
  self.trailEffPathaDic[HeroQualityType.Legendary] = "Assets/_Art_LastWar/Effect/Prefab/UI/100chou/Eff_100chou_tuowei_cheng.prefab"
  self.trailEffPathaDic[HeroQualityType.Genius] = "Assets/_Art_LastWar/Effect/Prefab/UI/100chou/Eff_100chou_tuowei_zi.prefab"
  self.trailEffPathaDic[HeroQualityType.Outstanding] = "Assets/_Art_LastWar/Effect/Prefab/UI/100chou/Eff_100chou_tuowei_lan.prefab"
  self.boomEffReq = nil
  self.trailEffReq = nil
end

local function __delete(self)
end

function Recruit100TimeLineFlyCard:ClearAll()
  self.boomEffPathaDic = nil
  self.trailEffPathaDic = nil
  if self.boomEffReq then
    self.boomEffReq:Destroy()
  end
  if self.trailEffReq then
    self.trailEffReq:Destroy()
  end
  self.boomEffReq = nil
  self.trailEffReq = nil
  self.trailEffHangPoint = nil
  self.boomEffHangPoint = nil
end

function Recruit100TimeLineFlyCard:Init(index, cardObj, quality)
  if IsNull(cardObj) then
    return
  end
  if cardObj.childCount > 0 then
    self.trailEffHangPoint = cardObj.transform:GetChild(0)
  end
  if cardObj.childCount > 1 then
    self.boomEffHangPoint = cardObj.transform:GetChild(1)
  end
  local boomEffPath = self.boomEffPathaDic[quality]
  local trailEffPath = self.trailEffPathaDic[quality]
  if quality == HeroQualityType.Legendary and index == 1 then
    boomEffPath = FIRST_MAIN_CARD_BOOM_EFF_PATH
  end
  if boomEffPath and self.boomEffHangPoint then
    self:GenBoomEff(boomEffPath)
  end
  if trailEffPath and self.trailEffHangPoint then
    self:GenTrailEff(trailEffPath)
  end
end

function Recruit100TimeLineFlyCard:GenBoomEff(path)
  if not path then
    return
  end
  self.boomEffReq = Resource:InstantiateAsync(path)
  self.boomEffReq:completed("+", function()
    local transform = self.boomEffReq.gameObject.transform
    self.boomEffReq.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
    transform:SetParent(self.boomEffHangPoint.transform)
    transform:Set_localPosition(0, 0, 0)
    transform.localRotation = Quaternion.Euler(0, 0, 0)
  end)
end

function Recruit100TimeLineFlyCard:GenTrailEff(path)
  if not path then
    return
  end
  self.trailEffReq = Resource:InstantiateAsync(path)
  self.trailEffReq:completed("+", function()
    local transform = self.trailEffReq.gameObject.transform
    self.trailEffReq.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
    transform:SetParent(self.trailEffHangPoint.transform)
    transform:Set_localPosition(0, 0, 0)
    transform.localRotation = Quaternion.Euler(0, 0, 0)
  end)
end

Recruit100TimeLineFlyCard.__init = __init
Recruit100TimeLineFlyCard.__delete = __delete
return Recruit100TimeLineFlyCard
