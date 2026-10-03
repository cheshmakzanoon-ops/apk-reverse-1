local UIHeroDetailPanelCtrl = BaseClass("UIHeroDetailPanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  if self.callBack ~= nil then
    self.callBack()
    self.callBack = nil
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroDetailPanel)
end

local function SetClsoeCallBack(self, callBack)
  self.callBack = callBack
end

local function OnCustomKeyCodeEscape(self)
  self:CloseSelf()
end

local function AutoUseExpItems(self, heroUuid)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if heroData == nil then
    return
  end
  local exp = heroData.exp
  local maxExp = HeroUtils.GetLevelUpNeedExp(heroData.level)
  local expCount = DataCenter.ResourceItemDataManager:GetHeroExpCount()
  if expCount <= 0 then
    return
  end
  local canUseAllItemsToNextLv = self:CheckItemsCanToNextLv(exp, maxExp)
  local costItems = {}
  local costItemsQuality = {
    0,
    0,
    0,
    0,
    0
  }
  local totalExp = 0
  if not canUseAllItemsToNextLv then
    return
  end
  
  local function Confirm()
    self:SaveHeroProp(heroUuid)
    SFSNetwork.SendMessage(MsgDefines.HeroLvUp, heroUuid)
  end
  
  Confirm()
  return costItemsQuality
end

local function GetHeroPropChange(self, heroUuid)
  if self.cacheHeroProp and self.cacheHeroProp[heroUuid] then
    local template = self.cacheHeroProp[heroUuid]
    local hero = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    local res = {}
    res.atkChange = math.floor(hero:GetProperty(HeroEffectDefine.Hero_ATK_Result)) - template.atk
    res.hpChange = math.floor(hero:GetProperty(HeroEffectDefine.Hero_HP_Result)) - template.hp
    res.defChange = math.floor(hero:GetProperty(HeroEffectDefine.Hero_DEF_Result)) - template.def
    res.powerChange = hero.power - template.power
    return res
  end
  return nil
end

local function SaveHeroProp(self, heroUuid)
  if self.cacheHeroProp == nil then
    self.cacheHeroProp = {}
  end
  local hero = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if not hero then
    return
  end
  local prop = {}
  prop.uuid = heroUuid
  prop.atk = math.floor(hero:GetProperty(HeroEffectDefine.Hero_ATK_Result))
  prop.hp = math.floor(hero:GetProperty(HeroEffectDefine.Hero_HP_Result))
  prop.def = math.floor(hero:GetProperty(HeroEffectDefine.Hero_DEF_Result))
  prop.power = hero.power
  self.cacheHeroProp[heroUuid] = prop
end

local function CheckItemsCanToNextLv(self, exp, maxExp)
  local needExpToUpgrade = maxExp - exp
  local expCount = DataCenter.ResourceItemDataManager:GetHeroExpCount()
  if needExpToUpgrade <= expCount then
    return true, 0
  else
    return false, expCount
  end
end

local function GetAllExpItems(self)
  return DataCenter.ResourceItemDataManager:GetHeroExpCount()
end

local function GetExpBookRatio(self, quality_list)
  local ratio = {
    0,
    0,
    0,
    0,
    0
  }
  local index = 0
  for quality, num in ipairs(quality_list) do
    if 0 < num then
      index = index + 1
      ratio[index] = quality
    end
  end
  if index == 1 then
    for i = 2, 5 do
      ratio[i] = ratio[1]
    end
  elseif index == 2 then
    local first_quality, second_quality
    for quality, num in ipairs(quality_list) do
      if 0 < num then
        if not first_quality then
          first_quality = quality
        else
          second_quality = quality
        end
      end
    end
    local s_f_ratio = quality_list[second_quality] / quality_list[first_quality]
    if 4 <= s_f_ratio then
      for i = 3, 5 do
        ratio[i] = second_quality
      end
    elseif s_f_ratio <= 0.25 then
      for i = 3, 5 do
        ratio[i] = first_quality
      end
    elseif 1 <= s_f_ratio then
      ratio[3] = first_quality
      for i = 4, 5 do
        ratio[i] = second_quality
      end
    else
      ratio[3] = second_quality
      for i = 4, 5 do
        ratio[i] = first_quality
      end
    end
  elseif index == 3 then
    local max_num = quality_list[1]
    local max_quality = 1
    for quality, num in ipairs(quality_list) do
      if num > max_num then
        max_num = num
        max_quality = quality
      end
    end
    for i = 4, 5 do
      ratio[i] = max_quality
    end
  elseif index == 4 then
    local max_num = quality_list[1]
    local max_quality = 1
    for quality, num in ipairs(quality_list) do
      if num > max_num then
        max_num = num
        max_quality = quality
      end
    end
    ratio[5] = max_quality
  end
  table.sort(ratio, function(a, b)
    return a < b
  end)
  return ratio
end

UIHeroDetailPanelCtrl.CloseSelf = CloseSelf
UIHeroDetailPanelCtrl.AutoUseExpItems = AutoUseExpItems
UIHeroDetailPanelCtrl.CheckItemsCanToNextLv = CheckItemsCanToNextLv
UIHeroDetailPanelCtrl.GetAllExpItems = GetAllExpItems
UIHeroDetailPanelCtrl.GetExpBookRatio = GetExpBookRatio
UIHeroDetailPanelCtrl.SaveHeroProp = SaveHeroProp
UIHeroDetailPanelCtrl.GetHeroPropChange = GetHeroPropChange
UIHeroDetailPanelCtrl.SetClsoeCallBack = SetClsoeCallBack
UIHeroDetailPanelCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UIHeroDetailPanelCtrl
