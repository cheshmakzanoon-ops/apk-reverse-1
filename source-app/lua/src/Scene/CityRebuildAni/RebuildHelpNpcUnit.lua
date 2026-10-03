local base = require("Scene.LWCityPerformNpc.PerformNpcUnit.PerformUnit")
local WorldPlayerHead = require("Scene.WorldPlayer.WorldPlayerHead")
local Localization = CS.GameEntry.Localization
local RebuildHelpNpcUnit = BaseClass("RebuildHelpNpcUnit", base)

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
    self:ShowHead()
  end
end

local function ShowHead(self)
  local needShow = false
  if self.data.playerHead then
    needShow = true
  end
  if needShow and self.playerHeadObj then
    self.playerHeadObj:SetActive(true)
    if self.worldPlayerHead == nil then
      self.worldPlayerHead = WorldPlayerHead.New()
      self.worldPlayerHead:OnCreate(self.playerHeadObj)
    end
    self.worldPlayerHead:SetHeadAndNameData(self.data.playerHead)
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

RebuildHelpNpcUnit.__init = __init
RebuildHelpNpcUnit.__delete = __delete
RebuildHelpNpcUnit.OnCreate = OnCreate
RebuildHelpNpcUnit.ShowHead = ShowHead
RebuildHelpNpcUnit.OnUpdate = OnUpdate
return RebuildHelpNpcUnit
