local ZMBuildingFlyawayState = BaseClass("ZMBuildingFlyawayState")
local a_build_jiluofu_feiting_03_path = "A_build_jiluofu_feiting_03_skin/To_unity/A_build_jiluofu_feiting_03"
local a_build_jiluofu_feiting_03_daodan1_path = "A_build_jiluofu_feiting_03_skin/To_unity/A_build_jiluofu_feiting_03_daodan1"

function ZMBuildingFlyawayState:__init(stateMgr)
  self.stateMgr = stateMgr
  self.modelNode = nil
end

function ZMBuildingFlyawayState:__delete()
  self:OnExit()
  self.modelNode = nil
  self.stateMgr = nil
end

function ZMBuildingFlyawayState:OnEnter(modelNode)
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayEffect(stateMgr.EffectFlag.Flyaway, 3)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_up, false)
  end
  self.modelNode = modelNode
end

function ZMBuildingFlyawayState:OnExit()
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.Flyaway)
  end
end

function ZMBuildingFlyawayState:OnUpdate()
  if self.modelNode then
    local node = self.modelNode.transform
    local subNode1 = node:Find(a_build_jiluofu_feiting_03_path)
    local subNode2 = node:Find(a_build_jiluofu_feiting_03_daodan1_path)
    if subNode1 then
      subNode1.gameObject:SetActive(false)
    end
    if subNode2 then
      subNode2.gameObject:SetActive(false)
    end
  end
end

return ZMBuildingFlyawayState
