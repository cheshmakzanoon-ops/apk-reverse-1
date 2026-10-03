local LWWelcomeBackManager = BaseClass("LWWelcomeBackManager", CEventable)
local Setting = CS.GameEntry.Setting
local ResourceManager = CS.GameEntry.Resource
local bubbleAnchor = Vector3.New(0, 3, 0)
local resPath = "Assets/Main/Prefabs/LWOpeningStage/jingli_timeline.prefab"
local WelcomeBackLastShowTime = "WelcomeBackLastShowTime"

function LWWelcomeBackManager:__init()
  self:RegisterEvent(EventId.BeforeReleaseCity, self.OnBeforeReleaseCity)
  self:RegisterEvent(EventId.OnPopWindowFirstFinish, self.TryShow)
  self.showed = false
end

function LWWelcomeBackManager:__delete()
  self.plotList = nil
  self.emojiList = nil
  self.showed = false
  self:UnLoad()
end

function LWWelcomeBackManager:InitData()
  if self.plotList == nil then
    self.plotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("welcome_home", "k1")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        local plot = tonumber(v) or 0
        if 0 < plot then
          table.insert(self.plotList, plot)
        end
      end
    end
    self.plotCount = #self.plotList
  end
  if self.emojiList == nil then
    self.emojiList = {}
    local str = LuaEntry.DataConfig:TryGetStr("welcome_home", "k2")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        local emoji = tonumber(v) or 0
        if 0 < emoji then
          table.insert(self.emojiList, emoji)
        end
      end
    end
    self.emojiCount = #self.emojiList
  end
end

function LWWelcomeBackManager:TryShow()
  local mainLevel = DataCenter.BuildManager:GetMainLevel()
  local cfgLevel = LuaEntry.DataConfig:TryGetNum("welcome_home", "k3")
  if mainLevel < cfgLevel then
    return
  end
  if not DataCenter.UIPopWindowManager:IsQueueEmpty() then
    return
  end
  local inCity = SceneUtils.GetIsInCity()
  if not inCity then
    return
  end
  if self.showed then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local lastTime = Setting:GetPrivateString(WelcomeBackLastShowTime, "")
  if string.IsNullOrEmpty(lastTime) then
    Setting:SetPrivateString(WelcomeBackLastShowTime, tostring(curTime))
  else
    local sameDay = UITimeManager:GetInstance():IsSameDayForServer(tonumber(lastTime), curTime)
    if sameDay then
      return
    end
    Setting:SetPrivateString(WelcomeBackLastShowTime, tostring(curTime))
  end
  self:Load()
end

function LWWelcomeBackManager:Load()
  if self.plotList == nil then
    self:InitData()
  end
  if self.req then
    return
  end
  self.showed = true
  if self.directorStopped == nil then
    function self.directorStopped(director)
      self:UnLoad()
    end
  end
  self.soldierList = {}
  self.req = ResourceManager:InstantiateAsync(resPath)
  self.req:completed("+", function(handle)
    if handle.isError then
      return
    end
    self.timelineGo = handle.gameObject
    self.timelineTransform = self.timelineGo.transform
    self.timelineTransform:SetParent(nil)
    self.timelineTransform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.timelineTransform:Set_localPosition(98, 0, DataCenter.LWCivilizationSparkExtend:LWWelcomeBackManager_getTimelinePosZ())
    self.director = self.timelineGo:GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    if IsNull(self.director) then
      self:UnLoad()
      return
    end
    local soldierRoot = self.timelineTransform:Find("weizhi")
    if IsNull(soldierRoot) then
      self:UnLoad()
      return
    end
    local childCount = soldierRoot.childCount
    if 0 < childCount then
      for i = 0, childCount - 1 do
        local child = soldierRoot:GetChild(i)
        if not IsNull(child) then
          table.insert(self.soldierList, child)
        end
      end
    end
    self.director:stopped("+", self.directorStopped)
    self.director:Play()
    self:PlayPlot()
    self:PlaySound()
  end)
end

function LWWelcomeBackManager:UnLoad()
  if self.director and self.directorStopped then
    self.director:stopped("-", self.directorStopped)
  end
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.timelineGo = nil
  self.timelineTransform = nil
  self.director = nil
  self.directorStopped = nil
  self.soldierList = nil
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
    self.soundId = nil
  end
end

function LWWelcomeBackManager:GetPlotId()
  if self.plotCount > 0 then
    local random = math.random(1, self.plotCount)
    return self.plotList[random]
  end
  return 0
end

function LWWelcomeBackManager:GetEmojiId()
  if self.emojiCount > 0 then
    local random = math.random(1, self.emojiCount)
    return self.emojiList[random]
  end
  return 0
end

function LWWelcomeBackManager:PlaySound()
  self.soundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_welcome_back, false)
end

function LWWelcomeBackManager:PlayPlot()
  local count = 4
  local plotTransform
  local plotIndex = 8
  local soldierCount = #self.soldierList
  for i = soldierCount, 1, -1 do
    if count <= 0 then
      break
    end
    if plotIndex ~= i then
      if i > count then
        local random = math.random()
        if random < 0.3 then
          count = count - 1
          self:PLayTransformEmoji(self.soldierList[i])
        end
      else
        count = count - 1
        self:PLayTransformEmoji(self.soldierList[i])
      end
    end
  end
  plotTransform = self.soldierList[plotIndex]
  if plotTransform then
    self:PlayTransformPlot(plotTransform)
  end
end

function LWWelcomeBackManager:PlayTransformPlot(trans)
  local plotId = self:GetPlotId()
  if 0 < plotId then
    local bubbleParams = {}
    bubbleParams.plotId = plotId
    bubbleParams.anchor = bubbleAnchor
    bubbleParams.mode = "3DFollow"
    bubbleParams.followTarget = trans
    EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
  end
end

function LWWelcomeBackManager:PLayTransformEmoji(trans)
  local emojiId = self:GetEmojiId()
  if 0 < emojiId then
    local emojiBubbleParams = {}
    emojiBubbleParams.emojiId = emojiId
    emojiBubbleParams.anchor = bubbleAnchor
    emojiBubbleParams.mode = "3DFollow"
    emojiBubbleParams.followTarget = trans
    EventManager:GetInstance():Broadcast(EventId.PlayEmojiBubble, emojiBubbleParams)
  end
end

function LWWelcomeBackManager:OnBeforeReleaseCity()
  self.showed = true
  self:UnLoad()
end

return LWWelcomeBackManager
