local UIHSRRobView = BaseClass("UIHSRRobView", UIBaseView)
local VictimRowComponent = require("UI.UIHSR.UIHSRRob.VictimRowComponent")
local resource_num_path = "Root/TitleBar/ResBar/resourceNum"
local toggle_path = "Root/Bottom/Toggle"
local toggle_text_path = "Root/Bottom/Toggle/toggleText"
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIHSRRobView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UIHSRRobView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHSRRobView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.compVictims = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.textSpoils = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textCost = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnRandom = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnRandom:SetOnClick(function()
    self:OnBtnRandomClick()
  end)
  self.btnRandom:SetSafeClickMode(true)
  self.btnRandom:SetSafeClickModeTime(3)
  self.textRemain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.resource_num = self:AddComponent(UITextMeshProUGUIEx, resource_num_path)
  self.toggle = self:AddComponent(UIToggle, toggle_path)
  self.toggle:SetOnValueChanged(function(bool)
    DataCenter.HSRDataManager:SetFilterOn(bool)
  end)
  self.toggle_text = self:AddComponent(UITextMeshProUGUIEx, toggle_text_path)
  self.toggle_text:SetLocalText("server_train_snatch_limit_6")
  self.jiutong = self:AddComponent(UIImage, "Root/Top/jiutong")
  self.jiutong:LoadSpriteAsync("Assets/Main/Sprites/ItemIcons/LXY_s5_jiutong_icon.png")
  self.l_w_btn_info = self:AddComponent(UIButton, "Root/Top/LW_Btn_Info")
  self.l_w_btn_info:SetOnClick(function()
    local param = {
      activityRulesStr = Localization:GetString("activity_snatch_server_train_rule")
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.textFree = self:AddComponent(UITextMeshProUGUIEx, "Root/Bottom/bubble/Free")
  self.cost_img = self:AddComponent(UIImage, "Root/Bottom/bubble/CostImg")
  self.textTitle:SetLocalText("activity_1200044_tips69")
  self.victimRows = {}
  self.victimRows[1] = self:AddComponent(VictimRowComponent, "Root/Bottom/Victims/Victim1")
  self.victimRows[2] = self:AddComponent(VictimRowComponent, "Root/Bottom/Victims/Victim2")
  self.victimRows[3] = self:AddComponent(VictimRowComponent, "Root/Bottom/Victims/Victim3")
  self.anim = self:AddComponent(UISimpleAnimation, "")
  if CommonUtil.ArabicAutoMirrorFactor() > 0 then
    self.anim:Play("Default")
  else
    self.anim:Play("DefaultFlip")
  end
  self.soundId2 = DataCenter.LWSoundManager:PlaySound(5100007, false, true)
end

function UIHSRRobView:ComponentDestroy()
  self.viewSkin = nil
  self.btnBack = nil
  self.compVictims = nil
  self.textSpoils = nil
  self.textTitle = nil
  self.textCost = nil
  self.btnRandom = nil
  self.textRemain = nil
  if self.soundId then
    DataCenter.LWSoundManager:FadeOutAndPlayMusic(self.soundId, 1)
  end
  if self.soundId2 then
    DataCenter.LWSoundManager:FadeOutAndPlayMusic(self.soundId2, 1)
  end
end

function UIHSRRobView:DataDefine()
  DataCenter.HSRDataManager:FetchVictimList()
end

function UIHSRRobView:DataDestroy()
end

function UIHSRRobView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HSRRobVictimRefresh, self.Refresh)
  self:AddUIListener(EventId.HSRRobFilterRefresh, self.RefreshFilter)
end

function UIHSRRobView:OnRemoveListener()
  self:RemoveUIListener(EventId.HSRRobVictimRefresh, self.Refresh)
  self:RemoveUIListener(EventId.HSRRobFilterRefresh, self.RefreshFilter)
  base.OnRemoveListener(self)
end

function UIHSRRobView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIHSRRobView:OnBtnRandomClick()
  local freeTimes = DataCenter.HSRDataManager:GetRemainFreeRefreshTimes()
  if freeTimes <= 0 then
    local cost = DataCenter.HSRDataManager:GetChangeItemPrice()
    local itemId = DataCenter.HSRDataManager:GetChangeItemId()
    local have = DataCenter.ItemData:GetItemCount(itemId)
    if cost > have then
      UIUtil.ShowTipsId(120021)
      return
    end
  end
  if 0 < CommonUtil.ArabicAutoMirrorFactor() then
    self.anim:Rewind("Change")
    self.anim:Play("Change")
  else
    self.anim:Rewind("ChangeFlip")
    self.anim:Play("ChangeFlip")
  end
  DataCenter.HSRDataManager:FetchNewVictimList()
  self.soundId = DataCenter.LWSoundManager:PlaySound(5100006, false, true)
  self.soundId2 = DataCenter.LWSoundManager:PlaySound(5100007, false, true)
end

function UIHSRRobView:RefreshFilter()
  self.toggle:SetIsOn(DataCenter.HSRDataManager:IsFilterOn())
end

function UIHSRRobView:Refresh()
  local activityData = DataCenter.HSRDataManager:GetActivityData()
  if activityData then
    self.textRemain:SetLocalText("activity_1200044_tips70", activityData.lootTimes or 0)
  end
  local dataList = DataCenter.HSRDataManager:GetVictimList()
  for i = 1, 3 do
    if dataList[i] then
      self.victimRows[i]:SetData(dataList[i])
      self.victimRows[i]:SetActive(true)
    else
      self.victimRows[i]:SetActive(false)
    end
  end
  local freeTimes = DataCenter.HSRDataManager:GetRemainFreeRefreshTimes()
  if 0 < freeTimes then
    self.textCost:SetText("")
    self.textFree:SetLocalText("110134", freeTimes)
    self.cost_img:SetActive(false)
  else
    self.textCost:SetText(DataCenter.HSRDataManager:GetChangeItemPrice())
    self.textFree:SetText("")
    self.cost_img:SetActive(true)
  end
  self.textSpoils:SetLocalText("activity_1200044_tips98", DataCenter.HSRDataManager:GetDailyLootNum())
  self:RefreshFilter()
  local itemId = DataCenter.HSRDataManager:GetChangeItemId()
  local have = DataCenter.ItemData:GetItemCount(itemId)
  self.resource_num:SetText(string.GetFormattedSeparatorNum(have))
end

return UIHSRRobView
