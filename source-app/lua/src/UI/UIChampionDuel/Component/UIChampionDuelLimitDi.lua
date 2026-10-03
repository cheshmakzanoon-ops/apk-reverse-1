local UIChampionDuelLimitDi = BaseClass("UIChampionDuelLimitDi", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_path = "root/Btn"
local sign_path = "root/Sign"
local text_tip_path = "root/TipText"

function UIChampionDuelLimitDi:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnBtnClick))
  self.text_tip = self:AddComponent(UIText, text_tip_path)
  self.sign = self:AddComponent(UIImage, sign_path)
end

function UIChampionDuelLimitDi:OnDestroy()
  self.btn = nil
  self.text_tip = nil
  self.sign = nil
  base.OnDestroy(self)
end

function UIChampionDuelLimitDi:OnBtnClick()
  local strTip = Localization:GetString(self.tipsStr)
  UIUtil.ShowBubbleTips(strTip, self.btn.transform.position, 0, 70, 0, nil, nil, {reversal = true})
end

function UIChampionDuelLimitDi:ReInit(index)
  self.index = index
  local textStr = ""
  local imgStr = ""
  if index == 1 or index == 4 then
    imgStr = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunzhengduo_saicheng_tiaojian01.png"
    textStr = "champion_duel_rules_short1001"
    self.tipsStr = "champion_duel_rules_detail1001"
  elseif index == 2 then
    imgStr = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunzhengduo_saicheng_tiaojian02.png"
    textStr = "champion_duel_rules_short1002"
    self.tipsStr = "champion_duel_rules_detail1002"
  elseif index == 3 then
    imgStr = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunzhengduo_saicheng_tiaojian03.png"
    textStr = "champion_duel_rules_short1003"
    self.tipsStr = "champion_duel_rules_detail1003"
  elseif index == 5 then
    imgStr = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunduijue_jingcai_tiaojian01.png"
    textStr = "champion_duel_tips1099"
    self.tipsStr = "champion_duel_tips1100"
  elseif index == 6 then
    imgStr = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunduijue_jingcai_tiaojian02.png"
    textStr = "champion_duel_tips1101"
    self.tipsStr = "champion_duel_tips1102"
  end
  self.text_tip:SetLocalText(textStr)
  self.sign:LoadSpriteAsyncWithCallback(imgStr, function()
    if self.sign then
      self.sign:SetNativeSize()
    end
  end)
end

return UIChampionDuelLimitDi
