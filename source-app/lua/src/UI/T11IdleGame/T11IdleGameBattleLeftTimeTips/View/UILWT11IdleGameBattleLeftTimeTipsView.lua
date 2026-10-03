local base = UIBaseView
local UILWT11IdleGameBattleLeftTimeTipsView = BaseClass("UILWT11IdleGameBattleLeftTimeTipsView", UIBaseView)
local Localization = CS.GameEntry.Localization

function UILWT11IdleGameBattleLeftTimeTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.param = self:GetUserData()
  self:OnOpen()
end

function UILWT11IdleGameBattleLeftTimeTipsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameBattleLeftTimeTipsView:DataDefine()
end

function UILWT11IdleGameBattleLeftTimeTipsView:DataDestroy()
end

function UILWT11IdleGameBattleLeftTimeTipsView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, "Panel")
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.root = self:AddComponent(UIBaseComponent, "Root/ImgBg")
  self.text1 = self:AddComponent(UIText, "Root/ImgBg/Text1")
  self.text2 = self:AddComponent(UIText, "Root/ImgBg/Text2")
end

function UILWT11IdleGameBattleLeftTimeTipsView:ComponentDestroy()
  self.close_btn = nil
  self.text1 = nil
  self.text2 = nil
  self.root = nil
end

function UILWT11IdleGameBattleLeftTimeTipsView:OnOpen()
  local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
  if mainData == nil then
    return
  end
  local leftTime = mainData:GetStartGameLeftTime()
  local addPerDay = DataCenter.T11IdleGameDataManager:GetStartGameAddTimePerDay()
  local addLimit = DataCenter.T11IdleGameDataManager:GetStartGameLeftTimeLimit()
  self.text1:SetLocalText("t11_idle_game_desc_87", leftTime)
  self.text2:SetLocalText("t11_idle_game_desc_88", addPerDay, addLimit)
  self.root.transform:Set_position(self.param.target.transform.position.x, self.param.target.transform.position.y, self.param.target.transform.position.z)
end

return UILWT11IdleGameBattleLeftTimeTipsView
