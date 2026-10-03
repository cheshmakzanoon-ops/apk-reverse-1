local FreeBuildingUpgradeFinishMessage = BaseClass("FreeBuildingUpgradeFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  DataCenter.BuildManager:SetCurStamina()
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.heros then
    for i, info in pairs(message.heros) do
      DataCenter.HeroDataManager:UpdateOneHero(info)
    end
  end
  DataCenter.BuildManager:FreeBuildingUpgradeFinishHandle(message)
end

FreeBuildingUpgradeFinishMessage.OnCreate = OnCreate
FreeBuildingUpgradeFinishMessage.HandleMessage = HandleMessage
return FreeBuildingUpgradeFinishMessage
