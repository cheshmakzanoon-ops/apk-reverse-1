local MainZeroUpgradeScene = BaseClass("MainZeroUpgradeScene")
local dome_path = "building_dome_6"
local camera_path = "XS_jiancangqiong_timeline/Camera"
local BuildDomeTime = 3
local DomeTile = 3
local BuildBeforeDomeTime = 0

function MainZeroUpgradeScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function MainZeroUpgradeScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function MainZeroUpgradeScene:ComponentDefine()
  self.dome = self.transform:Find(dome_path):GetComponent(typeof(CS.BuildingGrowEffect))
  self.camera_go = self.transform:Find(camera_path)
  self.dome.gameObject:SetActive(false)
end

function MainZeroUpgradeScene:ComponentDestroy()
  self.dome = nil
  self.camera_go = nil
  self.gameObject = nil
  self.transform = nil
end

function MainZeroUpgradeScene:DataDefine()
  self.param = nil
end

function MainZeroUpgradeScene:DataDestroy()
  self.param = nil
end

function MainZeroUpgradeScene:ReInit(param)
  self.param = param
  self.transform.position = self.param.pos
end

function MainZeroUpgradeScene:GotoTime(time)
end

function MainZeroUpgradeScene:PlayDomedAnim()
  if self.dome ~= nil then
    self.dome.gameObject:SetActive(true)
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Dome_Scan, false)
    end, BuildBeforeDomeTime)
    self.dome:StartBuild(0, 0, curTime + BuildBeforeDomeTime, curTime + BuildDomeTime, DomeTile, LuaEntry.Player:GetUid(), true, false, true)
  end
end

function MainZeroUpgradeScene:GetCameraPos()
  return self.camera_go.transform.position
end

return MainZeroUpgradeScene
