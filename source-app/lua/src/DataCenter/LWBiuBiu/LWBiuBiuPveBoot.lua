local LWBiuBiuPveBoot = BaseClass("LWBiuBiuPveBoot")
local Stage_Path = "Assets/Main/MiniGameRes/BiuBiu/Map/%s.txt"

function LWBiuBiuPveBoot:__init()
  self.boot = nil
  self.gameView = nil
  self.uiCallback = nil
  self.startSyncEnd = nil
end

function LWBiuBiuPveBoot:__delete()
  self.boot = nil
  self.gameView = nil
  self.uiCallback = nil
  self.startSyncEnd = nil
end

function LWBiuBiuPveBoot:CreateHandle(view)
  self.boot = view.gameObject:GetComponent(typeof(CS.MiniGame.Biubiu.Client.UIBiuBiuBoot))
  self.gameView = view
  if IsNull(self.boot) then
    Logger.LogInfo("[LWBiuBiu] LWBiuBiuPveBoot CreateHandle Boot is Null")
  else
    Logger.LogInfo("[LWBiuBiu] LWBiuBiuPveBoot CreateHandle")
  end
end

function LWBiuBiuPveBoot:BindCallback(callback)
  Logger.LogInfo("[LWBiuBiu] LWBiuBiuPveBoot BindCallback")
  self.uiCallback = callback
  self.boot:BindCallback(self.uiCallback)
end

function LWBiuBiuPveBoot:GetCamera()
  if not IsNull(self.boot) and not IsNull(self.boot.LoaderEnv) then
    return self.boot.LoaderEnv.Camera
  end
end

function LWBiuBiuPveBoot:IsDone()
  if IsNull(self.boot) then
    return false
  end
  return self.boot:IsDone()
end

function LWBiuBiuPveBoot:Start(stageName, gameRoot)
  Logger.LogInfo("[LWBiuBiu] LWBiuBiuPveBoot StartGame LevelPath is " .. stageName)
  self.boot:StartGame(string.format(Stage_Path, stageName), gameRoot)
end

function LWBiuBiuPveBoot:Exit()
  self:Dispose()
  if self.gameView and self.gameView.ctrl ~= nil then
    self.gameView.ctrl:CloseSelf()
    self.gameView = nil
  end
end

function LWBiuBiuPveBoot:End()
  if self.uiCallback ~= nil then
    self.boot:UnBindCallback(self.uiCallback)
    self.uiCallback = nil
  end
  self.boot:EndGame()
end

function LWBiuBiuPveBoot:Next()
  self.startSyncEnd = false
  local curOpenCloudTime = Time.realtimeSinceStartup
  local toDoNext = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuCloud, {anim = true}, nil, function()
    Logger.LogInfo("[LWBiuBiu] UILWBiuBiuActivity UILWBiuBiuCloud Hold Func")
    if Time.realtimeSinceStartup - curOpenCloudTime >= 8 then
      UIUtil.ShowTipsId(129063)
      self:Dispose()
      return true
    else
      if not toDoNext then
        if not self.gameView:Next() then
          UIUtil.ShowTipsId(129063)
          self:Dispose()
          return true
        end
        toDoNext = true
      end
      if not self.startSyncEnd then
        return false
      end
      if self.gameView == nil then
        return false
      end
      if self.gameView:InitFinish() then
        return true
      end
      return false
    end
  end)
end

function LWBiuBiuPveBoot:Dispose()
  Logger.LogWarning("[LWBiuBiu] LWBiuBiuPveBoot Dispose")
  if self.uiCallback ~= nil then
    self.boot:UnBindCallback(self.uiCallback)
    self.uiCallback = nil
  end
  if self.boot ~= nil then
    self.boot:Dispose()
    self.boot = nil
  end
end

return LWBiuBiuPveBoot
