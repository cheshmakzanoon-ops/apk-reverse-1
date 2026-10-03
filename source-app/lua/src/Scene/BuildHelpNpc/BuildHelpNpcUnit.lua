local base = require("Scene.LWCityPerformNpc.PerformNpcUnit.PerformUnit")
local WorldPlayerHead = require("Scene.WorldPlayer.WorldPlayerHead")
local Localization = CS.GameEntry.Localization
local BuildHelpNpcUnit = BaseClass("BuildHelpNpcUnit", base)

local function __init(self)
end

local function __delete(self)
  self.playerHeadObj = nil
  self.worldPlayerHead = nil
end

local function OnCreate(self)
  if self.transform then
    if self.transform then
      self.playerHeadObj = self.transform:Find("WorldPlayerHead").gameObject
      self.playerHeadObj:SetActive(false)
    end
    self:ShowPlot()
  end
end

local function ShowPlot(self)
  if not self.data.helperSysName then
    local plotId, time = DataCenter.BuildHelpNpcManager:GetRandomPlotId()
    if plotId then
      self.showHeadTime = time + 0.5
      local bubbleParams = {}
      bubbleParams.plotId = plotId
      bubbleParams.anchor = Vector3.New(0, 3, 0)
      bubbleParams.mode = "3DFollow"
      bubbleParams.followTarget = self.transform
      local plotData = LocalController:instance():getLine("lw_plot", plotId)
      local content = Localization:GetString(plotData.content, self.data.helpName)
      bubbleParams.fakePlotMeta = {duration = time, contentString = content}
      EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
    else
      self:ShowHead()
    end
  else
    self:ShowHead()
  end
end

function BuildHelpNpcUnit:ShowName()
  if not self.worldPlayerHead then
    return
  end
  local data = UIUtil.GetPlayerInfoShowByUid(LuaEntry.Player.uid, true)
  self.worldPlayerHead:SetName({
    name = self.data.helpName,
    abbr = data.alAbbr
  })
end

local function ShowHead(self)
  local needShow = false
  if self.data.playerHead and self.data.playerHead.picVer > 0 then
    needShow = true
  end
  if needShow and self.playerHeadObj then
    self.playerHeadObj:SetActive(true)
    if self.worldPlayerHead == nil then
      self.worldPlayerHead = WorldPlayerHead.New()
      self.worldPlayerHead:OnCreate(self.playerHeadObj)
    end
    self.worldPlayerHead:SetHeadData(self.data.playerHead)
  end
end

local function OnUpdate(self)
  if self.showHeadTime then
    self.showHeadTime = self.showHeadTime - Time.deltaTime
    if self.showHeadTime < 0 then
      self.showHeadTime = nil
      self:ShowHead()
    end
  end
end

BuildHelpNpcUnit.__init = __init
BuildHelpNpcUnit.__delete = __delete
BuildHelpNpcUnit.OnCreate = OnCreate
BuildHelpNpcUnit.ShowPlot = ShowPlot
BuildHelpNpcUnit.ShowHead = ShowHead
BuildHelpNpcUnit.OnUpdate = OnUpdate
return BuildHelpNpcUnit
