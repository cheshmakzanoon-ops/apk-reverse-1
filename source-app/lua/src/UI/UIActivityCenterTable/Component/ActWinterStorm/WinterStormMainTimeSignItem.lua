local WinterStormMainTimeSignItem = BaseClass("WinterStormMainTimeSignItem", UIBaseContainer)
local base = UIBaseContainer
local cur_sign_path = "sign"
local img_time_path = "lrb_dongjifengbao_shijianzhou03"
local img_cur_path = "lrb_dongjifengbao_shijianzhou04"

function WinterStormMainTimeSignItem:OnCreate()
  base.OnCreate(self)
  self.state = 0
  self.cur_sign = self:AddComponent(UIImage, cur_sign_path)
  self.cur_sign:SetActive(false)
end

function WinterStormMainTimeSignItem:OnDestroy()
  self.state = 0
  self.cur_sign = nil
  base.OnDestroy(self)
end

function WinterStormMainTimeSignItem:SetStatus(state)
  self.state = state
  local sFlag = state == 1 or state == 2
  self.cur_sign:SetActive(sFlag)
  if sFlag == true then
    self.cur_sign:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldWinterPath, state == 1 and img_time_path or img_cur_path))
  end
end

return WinterStormMainTimeSignItem
