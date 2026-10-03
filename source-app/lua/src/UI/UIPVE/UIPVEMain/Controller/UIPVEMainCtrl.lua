local UIPVEMainCtrl = BaseClass("UIPVEMainCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEMain, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

local function GetRedPotCountByType(self, type)
  return 0
end

local function OnFunctionClick(self, type)
  if type == UIMainFunctionInfo.Hero then
    local UIHeroList = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroList)
    if UIHeroList == nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroList, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide,
        hideTop = true
      })
      local num = DataCenter.HeroDataManager:GetHeroRedNum()
      if 0 < num then
        DataCenter.HeroDataManager:MarkHeroRedPoint()
      end
    end
  elseif type == UIMainFunctionInfo.Goods then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTable, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide,
      hideTop = true
    })
  elseif type == UIMainFunctionInfo.Info then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide,
      hideTop = true
    }, LuaEntry.Player.uid)
  end
end

local function SendUserResetHeroes(levelId, heroes)
  SFSNetwork.SendMessage(MsgDefines.UserResetPVEHero, levelId, heroes)
end

local function GetPlayerLevel(self)
  return DataCenter.BuildManager.MainLv
end

local function GetGoldNum(self)
  return LuaEntry.Player.gold
end

local function GetCanAddHero(self)
  local maxHeroCount = DataCenter.BattleLevel:GetMaxHeroCount()
  local heroDataDict = DataCenter.HeroDataManager:GetAllHeroBySort()
  local heroes = DataCenter.BattleLevel.heroMgr:GetCurHeroes()
  local curHeroCount = 0
  if heroes ~= nil then
    curHeroCount = table.count(heroes)
  end
  if curHeroCount < 5 and maxHeroCount > curHeroCount and curHeroCount < table.count(heroDataDict) then
    return true
  end
  return false
end

local function GetCntByResType(self, resourceType)
  local list = DataCenter.BattleLevel:GetAllResList()
  if list ~= nil then
    for _, v in ipairs(list) do
      if v.resourceType == resourceType then
        return v.num
      end
    end
  end
  return 0
end

local function GetWarningBallByType(self, type)
  return DataCenter.WarningBallManager:GetWarningBallByType(type)
end

local function OnWarningBallClick(self, type)
  local data = self:GetWarningBallByType(type)
  if data ~= nil then
    data:OnActionClick()
  end
end

UIPVEMainCtrl.CloseSelf = CloseSelf
UIPVEMainCtrl.GetRedPotCountByType = GetRedPotCountByType
UIPVEMainCtrl.OnFunctionClick = OnFunctionClick
UIPVEMainCtrl.GetPlayerLevel = GetPlayerLevel
UIPVEMainCtrl.GetGoldNum = GetGoldNum
UIPVEMainCtrl.SetLevelHeroes = SetLevelHeroes
UIPVEMainCtrl.GetCanAddHero = GetCanAddHero
UIPVEMainCtrl.GetCntByResType = GetCntByResType
UIPVEMainCtrl.GetWarningBallByType = GetWarningBallByType
UIPVEMainCtrl.OnWarningBallClick = OnWarningBallClick
return UIPVEMainCtrl
