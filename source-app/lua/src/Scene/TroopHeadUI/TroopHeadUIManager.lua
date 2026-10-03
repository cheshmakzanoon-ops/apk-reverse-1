local TroopHeadUIManager = BaseClass("TroopHeadUIManager", Singleton)
local TroopHeadUI = require("Scene.TroopHeadUI.TroopHeadUI")
local MonsterHeadUI = require("Scene.TroopHeadUI.MonsterHeadUI")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local troopHangPointPath = "rotationRoot/PvpHeadPoint"

local function __init(self)
  self.marchHeadTopUIList = {}
  self.exploreHeadUIList = {}
  self.isOnCreateList = {}
  self.cacheBattleHeadList = {}
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  self.marchHeadTopUIList = nil
  self.exploreHeadUIList = nil
  self.isOnCreateList = nil
  self.cacheBattleHeadList = nil
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.ShowTroopHeadInBattle, self.ShowTroopHeadInBattle)
  EventManager:GetInstance():AddListener(EventId.ShowTroopBattleValue, self.ShowTroopBattleSignal)
  EventManager:GetInstance():AddListener(EventId.HideTroopHead, self.HideTroopHead)
  EventManager:GetInstance():AddListener(EventId.TroopRotation, self.OnUpdateMarchSignal)
  EventManager:GetInstance():AddListener(EventId.ShowHeroHitedUiEffect, self.OnShowHitEffect)
  EventManager:GetInstance():AddListener(EventId.ShowCityTroopHead, self.ShowCityTroopHeadUISignal)
  EventManager:GetInstance():AddListener(EventId.HideCityTroopHead, self.HideCityTroopHeadUISignal)
  EventManager:GetInstance():AddListener(EventId.ShowExploreHeadInBattle, self.ShowExploreHeadInBattle)
  EventManager:GetInstance():AddListener(EventId.ShowExploreBattleValue, self.ShowExploreBattleSignal)
  EventManager:GetInstance():AddListener(EventId.HideExploreHead, self.HideExploreHead)
  EventManager:GetInstance():AddListener(EventId.ShowHeroIconByUseSkill, self.ShowTroopHeroShowUI)
  EventManager:GetInstance():AddListener(EventId.ShowBattleRedName, self.ShowBattleRedNameSignal)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():AddListener(EventId.WorldMarchUpdateDisplayMode, self.OnUpdateDisplayMode)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.ShowTroopHeadInBattle, self.ShowTroopHeadInBattle)
  EventManager:GetInstance():RemoveListener(EventId.ShowTroopBattleValue, self.ShowTroopBattleSignal)
  EventManager:GetInstance():RemoveListener(EventId.HideTroopHead, self.HideTroopHead)
  EventManager:GetInstance():RemoveListener(EventId.TroopRotation, self.OnUpdateMarchSignal)
  EventManager:GetInstance():RemoveListener(EventId.ShowHeroHitedUiEffect, self.OnShowHitEffect)
  EventManager:GetInstance():RemoveListener(EventId.ShowCityTroopHead, self.ShowCityTroopHeadUISignal)
  EventManager:GetInstance():RemoveListener(EventId.HideCityTroopHead, self.HideCityTroopHeadUISignal)
  EventManager:GetInstance():RemoveListener(EventId.ShowExploreHeadInBattle, self.ShowExploreHeadInBattle)
  EventManager:GetInstance():RemoveListener(EventId.ShowExploreBattleValue, self.ShowExploreBattleSignal)
  EventManager:GetInstance():RemoveListener(EventId.HideExploreHead, self.HideExploreHead)
  EventManager:GetInstance():RemoveListener(EventId.ShowHeroIconByUseSkill, self.ShowTroopHeroShowUI)
  EventManager:GetInstance():RemoveListener(EventId.ShowBattleRedName, self.ShowBattleRedNameSignal)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():RemoveListener(EventId.WorldMarchUpdateDisplayMode, self.OnUpdateDisplayMode)
end

local function ChangeCameraLodSignal(lod)
  TroopHeadUIManager:GetInstance():UpdateLod(lod)
end

local function UpdateLod(self, lod)
  if self.lodCache ~= lod then
    self.lodCache = lod
    if self.lodCache >= 1 and self.lodCache <= 3 then
      self:CreateCacheBattleHeadList()
    end
  end
end

local function CreateCacheBattleHeadList(self)
  if self.cacheBattleHeadList ~= nil then
    for k, v in pairs(self.cacheBattleHeadList) do
      self:ShowHeadUI(k, true)
    end
    self.cacheBattleHeadList = {}
  end
end

local function ShowTroopHeadInBattle(uuid)
  TroopHeadUIManager:GetInstance():ShowHeadUI(uuid, true)
end

local function ShowTroopHeadOutBattle(uuid)
  TroopHeadUIManager:GetInstance():ShowHeadUI(uuid, false)
end

local function HideTroopHead(uuid)
  TroopHeadUIManager:GetInstance():HideHeadUI(uuid)
end

local function ShowTroopHeroShowUI(param)
  TroopHeadUIManager:GetInstance():ShowHeroShowUI(param)
end

local function OnShowHitEffect(param)
  TroopHeadUIManager:GetInstance():ShowHitEffect(param)
end

local function ShowBattleRedNameSignal(uuid)
  TroopHeadUIManager:GetInstance():ShowBattleRedName(uuid)
end

local function ShowBattleRedName(self, uuid)
  if self.marchHeadTopUIList[uuid] ~= nil then
    self.marchHeadTopUIList[uuid]:ShowBattleRedName()
  end
end

local function ShowHitEffect(self, param)
  if self.marchHeadTopUIList[param] ~= nil then
    local headUI = self.marchHeadTopUIList[param]
    headUI:Hit()
  end
end

local function ShowSelectCircle(self, uuid)
  if self.marchHeadTopUIList[uuid] ~= nil then
    self.marchHeadTopUIList[uuid]:SetSelectCircle(true)
  end
end

local function HideSelectCircle(self, uuid)
  if self.marchHeadTopUIList[uuid] ~= nil then
    self.marchHeadTopUIList[uuid]:SetSelectCircle(false)
  end
end

local function ShowExploreHeadInBattle(data)
  local str = data
  if str ~= nil then
    local strArr = string.split(str, ";")
    if 3 < #strArr then
      local pointIndex = tonumber(strArr[1])
      local soliderNum = tonumber(strArr[2])
      local hp = tonumber(strArr[3])
      local hpMax = tonumber(strArr[4])
      TroopHeadUIManager:GetInstance():ShowExploreHeadUI(pointIndex, soliderNum, hp, hpMax)
    end
  end
end

local function ShowExploreHeadUI(self, pointIndex, soliderNum, hp, hpMax)
  local pointObject = CS.SceneManager.World:GetObjectByPoint(pointIndex)
  if pointObject ~= nil then
    local transform = pointObject:GetTransform()
    if transform == nil then
      return
    end
    if self.exploreHeadUIList[pointIndex] == nil and self.isOnCreateList[pointIndex] == nil then
      local request = ResourceManager:InstantiateAsync(UIAssets.WorldTroopMonsterPro)
      self.isOnCreateList[pointIndex] = request
      request:completed("+", function()
        self.isOnCreateList[pointIndex] = nil
        if request.isError then
          return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(transform)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        local tileUI = MonsterHeadUI.New()
        tileUI:OnCreate(request)
        self.exploreHeadUIList[pointIndex] = tileUI
        self.exploreHeadUIList[pointIndex]:ShowExploreInfo(pointIndex, soliderNum, hp, hpMax)
      end)
    elseif self.exploreHeadUIList[pointIndex] ~= nil then
      self.exploreHeadUIList[pointIndex]:ShowExploreInfo(pointIndex, soliderNum, hp, hpMax)
    end
  end
end

local function ShowExploreBattleSignal(data)
  local str = data
  if str ~= nil then
    local strArr = string.split(str, ";")
    if 3 < #strArr then
      local pointIndex = tonumber(strArr[1])
      local anger = tonumber(strArr[2])
      local hp = tonumber(strArr[3])
      local hpMax = tonumber(strArr[4])
      TroopHeadUIManager:GetInstance():UpdateExploreHeadUI(pointIndex, anger, hp, hpMax)
    end
  end
end

local function UpdateExploreHeadUI(self, pointIndex, anger, hp, hpMax)
  if self.exploreHeadUIList[pointIndex] ~= nil then
    local headUI = self.exploreHeadUIList[pointIndex]
    local maxAnger = LuaEntry.DataConfig:TryGetNum("battle_config", "k12")
    headUI:SetAnger(anger, maxAnger)
    headUI:SetHP(hp, hpMax)
  end
end

local function HideExploreHead(pointIndex)
  TroopHeadUIManager:GetInstance():HideExploreHeadUI(pointIndex)
end

local function HideExploreHeadUI(self, pointIndex)
  if self.exploreHeadUIList[pointIndex] ~= nil then
    local headUI = self.exploreHeadUIList[pointIndex]
    local request = headUI.request
    headUI:ComponentDestroy()
    if request ~= nil then
      request:Destroy()
    end
    self.exploreHeadUIList[pointIndex] = nil
  end
end

local function OnUpdateMarchSignal(uuid)
  TroopHeadUIManager:GetInstance():UpdateMarch(uuid)
end

local function UpdateMarch(self, uuid)
  if self.marchHeadTopUIList[uuid] ~= nil then
    local info = CS.SceneManager.World:GetMarch(uuid)
    if info ~= nil and info.inBattle == false then
      self.marchHeadTopUIList[uuid]:SetSelectRotation(uuid)
    end
  end
end

local function OnUpdateDisplayMode(uuid)
  TroopHeadUIManager:GetInstance():UpdateDisplayMode(uuid)
end

local function UpdateDisplayMode(self, uuid)
  if self.marchHeadTopUIList ~= nil then
    for k, v in pairs(self.marchHeadTopUIList) do
      v:UpdateDisplayMode()
    end
  end
end

local function ShowTroopBattleSignal(data)
  local str = data
  if str ~= nil then
    local strArr = string.split(str, ";")
    if 3 < #strArr then
      local marchUuid = tonumber(strArr[1])
      local anger = tonumber(strArr[2])
      local hp = tonumber(strArr[3])
      local hpMax = tonumber(strArr[4])
      TroopHeadUIManager:GetInstance():UpdateBattleHeadUI(marchUuid, anger, hp, hpMax)
    end
  end
end

local function ShowBattleGuideLine(self, isBattle, transform, gameObject, isMonster, troop, tileUI, firstShow)
  if self.lodCache ~= nil and self.lodCache > 3 then
    return
  end
  gameObject.transform:Set_localPosition(0, 0, 0)
  local targetFlow = gameObject.transform:Find("Transform"):GetComponent(typeof(CS.TargetFlow))
  if isBattle == true or troop:IsBattle() == true then
    local zOffset = -4.29
    local xOffset = 0
    local minY = 2
    local maxY = 6
    local target = transform:Find(troopHangPointPath)
    if target == nil then
      return
    end
    local color = CS.UnityEngine.Color.green
    if isMonster == true then
      color = CS.UnityEngine.Color.red
    end
    targetFlow.target = target
    targetFlow.zOffset = zOffset
    targetFlow.xOffset = xOffset
    targetFlow.minYoffset = minY
    targetFlow.maxYoffset = maxY
    targetFlow.lineColor = color
    if firstShow then
      targetFlow:DoFlowAnim(0.5)
    end
  else
    targetFlow.target = nil
    local marchData = troop:GetMarchInfo()
    if marchData ~= nil and marchData:IsMasstroops() == true then
      tileUI:SetTransformPositon(Vector3.New(-1.63, 6.5, 0))
    else
      tileUI:SetTransformPositon(Vector3.New(-1.18, 3, 0))
    end
  end
  gameObject:SetActive(true)
end

local function ShowHeroShowUI(self, param)
  if self.lodCache ~= nil and self.lodCache > 3 then
    return
  end
  local marchUuid = tonumber(param)
  local isMonster = false
  local troop = CS.SceneManager.World:GetTroop(marchUuid)
  if troop ~= nil then
    isMonster = troop:IsMonsterTroop()
  end
  if isMonster == true then
    return
  end
  if self.marchHeadTopUIList[marchUuid] ~= nil then
    self.marchHeadTopUIList[marchUuid]:ShowUseSkill()
  end
end

local function ShowHeadUI(self, marchUuid, isBattle)
  local troop = CS.SceneManager.World:GetTroop(marchUuid)
  if troop ~= nil then
    local isMonster = troop:IsMonsterTroop()
    if isMonster == true then
      self:ShowMonsterBlood(troop, marchUuid, isBattle)
    else
      local info = CS.SceneManager.World:GetMarch(marchUuid)
      if info ~= nil then
        do
          local marchType = info:GetMarchType()
          if marchType == NewMarchType.ACT_BOSS or marchType == NewMarchType.PUZZLE_BOSS or marchType == NewMarchType.TRAIN or marchType == NewMarchType.ZONE_TRAIN or marchType == NewMarchType.DETECT_ZOMBIE_BUS_TRAIN then
            return
          end
          local tempStatus = info:GetMarchStatus()
          if tempStatus == MarchStatus.GOLLOES_EXPLORING then
            return
          end
          local isTeam = info:IsMasstroops() == true
          if self.marchHeadTopUIList[marchUuid] == nil and self.isOnCreateList[marchUuid] == nil then
            if isBattle == true and troop:IsBattle() == false then
              return
            end
            if self.lodCache ~= nil and self.lodCache > 3 then
              if isBattle then
                self.cacheBattleHeadList[marchUuid] = isBattle
              end
              return
            end
            local request = ResourceManager:InstantiateAsync(UIAssets.WorldTroopHeadUI)
            self.isOnCreateList[marchUuid] = request
            request:completed("+", function()
              self.isOnCreateList[marchUuid] = nil
              if request.isError then
                return
              end
              troop = CS.SceneManager.World:GetTroop(marchUuid)
              request.gameObject:SetActive(true)
              if troop == nil then
                request:Destroy()
                return
              end
              local transform = troop:GetTransform()
              if transform == nil then
                request:Destroy()
                return
              end
              request.gameObject.transform:SetParent(transform)
              request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
              request.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
              TroopNameLabelManager:GetInstance():RemoveOneEffect(marchUuid)
              local tileUI = TroopHeadUI.New()
              tileUI:OnCreate(request)
              self.marchHeadTopUIList[marchUuid] = tileUI
              self.marchHeadTopUIList[marchUuid]:ShowMarchInfo(info, false, true)
            end)
          elseif self.marchHeadTopUIList[marchUuid] ~= nil then
            self.marchHeadTopUIList[marchUuid]:ShowMarchInfo(info, false, false, troop:GetTransform())
          end
        end
      end
    end
  end
end

local function ShowMonsterBlood(self, troop, marchUuid, isBattle)
  local transform = troop:GetTransform()
  local info = CS.SceneManager.World:GetMarch(marchUuid)
  if info ~= nil then
    if self.marchHeadTopUIList[marchUuid] == nil and self.isOnCreateList[marchUuid] == nil then
      if isBattle then
        local request = ResourceManager:InstantiateAsync(UIAssets.WorldTroopMonsterPro)
        self.isOnCreateList[marchUuid] = request
        request:completed("+", function()
          self.isOnCreateList[marchUuid] = nil
          if request.isError then
            return
          end
          request.gameObject:SetActive(true)
          if transform == nil then
            request:Destroy()
            return
          end
          request.gameObject.transform:SetParent(transform)
          request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          request.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
          local tileUI = MonsterHeadUI.New()
          tileUI:OnCreate(request)
          self.marchHeadTopUIList[marchUuid] = tileUI
          self.marchHeadTopUIList[marchUuid]:ShowMarchInfo(info, true)
        end)
      end
    elseif self.marchHeadTopUIList[marchUuid] ~= nil then
      if isBattle then
        self.marchHeadTopUIList[marchUuid]:ShowMarchInfo(info, false)
      else
        self:HideHeadUI(marchUuid)
      end
    end
  end
end

local function HideHeadUI(self, marchUuid)
  if self.marchHeadTopUIList[marchUuid] ~= nil or self.isOnCreateList[marchUuid] ~= nil then
    local troop = CS.SceneManager.World:GetTroop(marchUuid)
    if troop and troop:IsBattle() then
      WorldMarchTileUIManager:GetInstance():RemoveTroopByUuid(marchUuid)
    end
    local headUI = self.marchHeadTopUIList[marchUuid]
    if headUI ~= nil then
      local request = headUI.request
      headUI:OnDestroy()
      if request ~= nil then
        request:Destroy()
      end
      self.marchHeadTopUIList[marchUuid] = nil
    end
    local temp = self.isOnCreateList[marchUuid]
    if temp ~= nil then
      temp:Destroy()
      self.isOnCreateList[marchUuid] = nil
    end
  end
end

local function UpdateBattleHeadUI(self, marchUuid, anger, hp, hpMax)
  if self.lodCache ~= nil and self.lodCache > 3 then
    return
  end
  if self.marchHeadTopUIList[marchUuid] ~= nil then
    local headUI = self.marchHeadTopUIList[marchUuid]
    local maxAnger = LuaEntry.DataConfig:TryGetNum("battle_config", "k12")
    headUI:SetAnger(anger, maxAnger)
    headUI:SetHP(hp, hpMax)
  end
end

local function ShowCityTroopHeadUISignal(param)
  TroopHeadUIManager:GetInstance():ShowCityTroopHeadUI()
end

local function HideCityTroopHeadUISignal(param)
  TroopHeadUIManager:GetInstance():HideCityTroopHeadUI()
end

local function ShowCityTroopHeadUI(self)
  local troop = CS.SceneManager.World:GetCityTroop()
  if troop ~= nil then
    local transform = troop:GetTransform()
    local marchUuid = 1
    if self.marchHeadTopUIList[marchUuid] == nil and self.isOnCreateList[marchUuid] == nil then
      do
        local request = ResourceManager:InstantiateAsync(UIAssets.WorldTroopHeadUI)
        self.isOnCreateList[marchUuid] = request
        request:completed("+", function()
          self.isOnCreateList[marchUuid] = nil
          if request.isError then
            return
          end
          if transform == nil then
            request:Destroy()
            return
          end
          request.gameObject:SetActive(true)
          request.gameObject.transform:SetParent(transform)
          request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local tileUI = TroopHeadUI.New()
          tileUI:OnCreate(request)
          self.marchHeadTopUIList[marchUuid] = tileUI
          self.marchHeadTopUIList[marchUuid]:ShowCityTroopInfo()
        end)
      end
    end
  end
end

local function HideCityTroopHeadUI(self)
  local marchUuid = 1
  if self.marchHeadTopUIList[marchUuid] ~= nil then
    local headUI = self.marchHeadTopUIList[marchUuid]
    local request = headUI.request
    headUI:ComponentDestroy()
    if request ~= nil then
      request:Destroy()
    end
    self.marchHeadTopUIList[marchUuid] = nil
  end
end

local function HasHeadUI(self, marchUuid)
  if self.isOnCreateList[marchUuid] ~= nil or self.marchHeadTopUIList[marchUuid] ~= nil then
    return true
  end
  return false
end

TroopHeadUIManager.__init = __init
TroopHeadUIManager.__delete = __delete
TroopHeadUIManager.AddListener = AddListener
TroopHeadUIManager.RemoveListener = RemoveListener
TroopHeadUIManager.ShowTroopHeadInBattle = ShowTroopHeadInBattle
TroopHeadUIManager.ShowTroopHeadOutBattle = ShowTroopHeadOutBattle
TroopHeadUIManager.HideTroopHead = HideTroopHead
TroopHeadUIManager.ShowTroopBattleSignal = ShowTroopBattleSignal
TroopHeadUIManager.ShowHeadUI = ShowHeadUI
TroopHeadUIManager.HideHeadUI = HideHeadUI
TroopHeadUIManager.UpdateBattleHeadUI = UpdateBattleHeadUI
TroopHeadUIManager.OnUpdateMarchSignal = OnUpdateMarchSignal
TroopHeadUIManager.UpdateMarch = UpdateMarch
TroopHeadUIManager.ShowExploreHeadInBattle = ShowExploreHeadInBattle
TroopHeadUIManager.ShowExploreBattleSignal = ShowExploreBattleSignal
TroopHeadUIManager.HideExploreHead = HideExploreHead
TroopHeadUIManager.HideExploreHeadUI = HideExploreHeadUI
TroopHeadUIManager.UpdateExploreHeadUI = UpdateExploreHeadUI
TroopHeadUIManager.ShowExploreHeadUI = ShowExploreHeadUI
TroopHeadUIManager.ShowBattleGuideLine = ShowBattleGuideLine
TroopHeadUIManager.ShowTroopHeroShowUI = ShowTroopHeroShowUI
TroopHeadUIManager.ShowHeroShowUI = ShowHeroShowUI
TroopHeadUIManager.OnShowHitEffect = OnShowHitEffect
TroopHeadUIManager.ShowHitEffect = ShowHitEffect
TroopHeadUIManager.ShowCityTroopHeadUI = ShowCityTroopHeadUI
TroopHeadUIManager.HideCityTroopHeadUI = HideCityTroopHeadUI
TroopHeadUIManager.ShowCityTroopHeadUISignal = ShowCityTroopHeadUISignal
TroopHeadUIManager.HideCityTroopHeadUISignal = HideCityTroopHeadUISignal
TroopHeadUIManager.ShowSelectCircle = ShowSelectCircle
TroopHeadUIManager.HideSelectCircle = HideSelectCircle
TroopHeadUIManager.ShowMonsterBlood = ShowMonsterBlood
TroopHeadUIManager.ShowBattleRedNameSignal = ShowBattleRedNameSignal
TroopHeadUIManager.ShowBattleRedName = ShowBattleRedName
TroopHeadUIManager.HasHeadUI = HasHeadUI
TroopHeadUIManager.ChangeCameraLodSignal = ChangeCameraLodSignal
TroopHeadUIManager.UpdateLod = UpdateLod
TroopHeadUIManager.CreateCacheBattleHeadList = CreateCacheBattleHeadList
TroopHeadUIManager.UpdateDisplayMode = UpdateDisplayMode
TroopHeadUIManager.OnUpdateDisplayMode = OnUpdateDisplayMode
return TroopHeadUIManager
