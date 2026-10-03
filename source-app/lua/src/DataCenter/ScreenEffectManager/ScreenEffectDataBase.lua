local base = CEventable
local ScreenEffectDataBase = BaseClass("ScreenEffectDataBase", base)
local ResourceManager = CS.GameEntry.Resource

function ScreenEffectDataBase:__init()
  self.prefabPath = nil
  self.active = false
  self.showSceneFilter = ScreenEffectSceneFilter.None
  self.curScene = ScreenEffectSceneFilter.None
  self.effectObj = nil
  self.request = nil
  self.parentType = ScreenEffectParentType.Camera
  self.lifeTime = 0
  self.changeScale = true
  self.lodMin = -1
  self.lodMax = -1
  self.lodShowFlag = true
end

function ScreenEffectDataBase:__delete()
  self:RelaseEffect()
  self.prefabPath = nil
  self.active = nil
  self.showSceneFilter = nil
  self.curScene = nil
  self.effectObj = nil
  self.request = nil
end

function ScreenEffectDataBase:LoadEffect()
  self:RelaseEffect()
  if not string.IsNullOrEmpty(self.prefabPath) then
    self.request = ResourceManager:InstantiateAsync(self.prefabPath)
    self.request:completed("+", function()
      if self.request.isError or CS.SceneManager.World == nil then
        return
      end
      self.request.gameObject:SetActive(true)
      local trans = self.request.gameObject.transform
      if self.parentType == ScreenEffectParentType.Camera then
        trans:SetParent(CS.UnityEngine.Camera.main.transform)
        trans:Set_rotation(Quaternion.Euler(0, 0, 0))
        trans:Set_localPosition(0, 0, 0)
        self.effectObj = self.request.gameObject
        self.effectObj:SetActive(self.active)
        if self.changeScale then
          local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
          mainUIView = mainUIView and mainUIView.View
          local ScreenSize = mainUIView and mainUIView.rectTransform.rect
          if ScreenSize then
            trans:Set_localScale(ScreenSize.width / DefaultScreenWidth, ScreenSize.height / DefaultScreenHeight, 1)
          else
            ScreenSize = CS.UnityEngine.Screen
            trans:Set_localScale(ScreenSize.width / DefaultScreenWidth, ScreenSize.height / DefaultScreenHeight, 1)
          end
        else
          trans:Set_localScale(1, 1, 1)
        end
      elseif self.parentType == ScreenEffectParentType.WorldCameraPoint then
        if self.active then
          if SceneUtils.GetIsInWorld() then
            trans:SetParent(CS.SceneManager.World.DynamicObjNode)
            trans:Set_localScale(1, 1, 1)
            trans:Set_rotation(Quaternion.Euler(0, 0, 0))
            local pos = CS.SceneManager.World.CurTarget
            trans:Set_position(pos.x, pos.y, pos.z)
            self.effectObj = self.request.gameObject
            self.effectObj:SetActive(true)
          else
            self:RelaseEffect()
          end
        else
          self:RelaseEffect()
        end
      end
      self:LoadEffectFinish()
    end)
  end
end

function ScreenEffectDataBase:RelaseEffect()
  if self.request then
    self.request:Destroy()
    self.request = nil
    self.effectObj = nil
  end
  if self.timerLife then
    self.timerLife:Stop()
    self.timerLife = nil
  end
end

function ScreenEffectDataBase:OnLifeTimeOver()
  self:RelaseEffect()
  if self.OnLifeTimeOverCallBack then
    self:OnLifeTimeOverCallBack()
  end
end

function ScreenEffectDataBase:OnSceneChange(filter)
  self.curScene = filter
  self.active = self:CheckShowFlag()
  if self.parentType == ScreenEffectParentType.Camera then
    if self.effectObj then
      self.effectObj:SetActive(self.active)
    elseif self.active and self.request == nil then
      self:LoadEffect()
    end
  elseif self.parentType == ScreenEffectParentType.WorldCameraPoint then
    if self.active then
      if self.effectObj then
        self.effectObj:SetActive(true)
      elseif self.active and self.request == nil then
        self:LoadEffect()
      end
    else
      self:RelaseEffect()
    end
  end
end

function ScreenEffectDataBase:GetCurScene()
  if CS.SceneManager.CurrSceneID == SceneManagerSceneID.City then
    return ScreenEffectSceneFilter.City
  elseif CS.SceneManager.CurrSceneID == SceneManagerSceneID.World then
    if not BattleFieldUtil.InBattleField() then
      return ScreenEffectSceneFilter.World
    end
    return ScreenEffectSceneFilter.None
  else
    return ScreenEffectSceneFilter.None
  end
end

function ScreenEffectDataBase:OnLodChanged(lodLevel)
  if self.lodMin < 0 and 0 > self.lodMax then
    return
  end
  if 0 <= lodLevel and self.lodMin >= 0 and lodLevel < self.lodMin or 0 <= self.lodMax and lodLevel > self.lodMax then
    self.lodShowFlag = false
  else
    self.lodShowFlag = true
  end
end

function ScreenEffectDataBase:CheckShowFlag()
  return self.showSceneFilter & self.curScene > 0 and self.lodShowFlag
end

function ScreenEffectDataBase:LoadEffectFinish()
  if self.lifeTime and self.lifeTime > 0 then
    if self.timerLife == nil then
      self.timerLife = TimerManager:GetInstance():GetTimer(self.lifeTime, self.OnLifeTimeOver, self, true, false, false)
    end
    self.timerLife:Start()
  end
end

return ScreenEffectDataBase
