local LWGGGoPveBoot = BaseClass("LWGGGoPveBoot")
local Stage_Path = "Assets/Main/MiniGameRes/GGGo/Map/%s.txt"

function LWGGGoPveBoot:__init()
  self.boot = nil
  self.gameView = nil
  self.uiCallback = nil
  self.startSyncEnd = nil
end

function LWGGGoPveBoot:__delete()
  self.boot = nil
  self.gameView = nil
  self.uiCallback = nil
  self.startSyncEnd = nil
end

function LWGGGoPveBoot:CreateHandle(view)
  self.boot = view.gameObject:GetComponent(typeof(CS.MiniGame.GGGo.Client.UIGGGoMain))
  self.gameView = view
  if IsNull(self.boot) then
    Logger.LogInfo("[LWGGGo] LWGGGoPveBoot CreateHandle Boot is Null")
  else
    Logger.LogInfo("[LWGGGo] LWGGGoPveBoot CreateHandle")
  end
end

function LWGGGoPveBoot:BindCallback(callback)
  Logger.LogInfo("[LWGGGo] LWGGGoPveBoot BindCallback")
  self.uiCallback = callback
  self.boot:BindCallback(self.uiCallback)
end

function LWGGGoPveBoot:GetCamera()
  if not IsNull(self.boot) and not IsNull(self.boot.LoaderEnv) then
    return self.boot.LoaderEnv.Camera
  end
end

function LWGGGoPveBoot:IsDone()
  if IsNull(self.boot) then
    return false
  end
  return self.boot:IsDone()
end

function LWGGGoPveBoot:Start(stageName, gameRoot)
  Logger.LogInfo("[LWGGGo] LWGGGoPveBoot StartGame LevelPath is " .. stageName)
  self.boot:StartGame(string.format(Stage_Path, stageName), gameRoot)
end

function LWGGGoPveBoot:Exit()
  self:Dispose()
  if self.gameView and self.gameView.ctrl ~= nil then
    self.gameView.ctrl:CloseSelf()
    self.gameView = nil
  end
end

function LWGGGoPveBoot:End()
  if self.uiCallback ~= nil then
    self.boot:UnBindCallback(self.uiCallback)
    self.uiCallback = nil
  end
  self.boot:EndGame()
end

function LWGGGoPveBoot:Next()
  self.startSyncEnd = false
  local curOpenCloudTime = Time.realtimeSinceStartup
  local toDoNext = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGGGoCloud, {anim = true}, nil, function()
    Logger.LogInfo("[LWGGGo] UILWGGGoActivity UILWGGGoCloud Hold Func")
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

function LWGGGoPveBoot:Dispose()
  Logger.LogWarning("[LWGGGo] LWGGGoPveBoot Dispose")
  if self.uiCallback ~= nil then
    self.boot:UnBindCallback(self.uiCallback)
    self.uiCallback = nil
  end
  if self.boot ~= nil then
    self.boot:Dispose()
    self.boot = nil
  end
end

return LWGGGoPveBoot
