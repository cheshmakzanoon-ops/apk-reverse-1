local UIFishingResultView = BaseClass("UIFishingResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local l_w_btn_info_path = "Content/SubPanelRoot/Desc/LW_Btn_Info"

function UIFishingResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
  DataCenter.LWSoundManager:PlaySound(6100019, false)
end

function UIFishingResultView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFishingResultView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnCloseBg = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnCloseBg:SetOnClick(function()
    self:OnBtnCloseBgClick()
  end)
  self.compNet = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.rawImgFish = self.viewSkin:AddComponent(self, UIRawImage, 3)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compNew = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textWeight = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textRankNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textButton = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.compNewRecord = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.textButton:SetLocalText(393108)
  self.textTitle:SetLocalText("s6_fish_activity_title_5")
  self.textDesc:SetLocalText("s6_fish_limit_6")
  self.l_w_btn_info = self:AddComponent(UIButton, l_w_btn_info_path)
  self.l_w_btn_info:SetOnClick(function()
    local desc = Localization:GetString("s6_fish_confiscation_rule")
    UIUtil.ShowBubbleTipsAuto(desc, self.l_w_btn_info.transform.position, 25, -30, 100)
  end)
end

function UIFishingResultView:ComponentDestroy()
  self.viewSkin = nil
  self.btnCloseBg = nil
  self.compNet = nil
  self.rawImgFish = nil
  self.textTitle = nil
  self.textDesc = nil
  self.compNew = nil
  self.textName = nil
  self.textWeight = nil
  self.textRank = nil
  self.textRankNum = nil
  self.btnConfirm = nil
  self.textButton = nil
  self.compNewRecord = nil
end

function UIFishingResultView:DataDefine()
  self.resultServerData = self:GetUserData()
end

function UIFishingResultView:DataDestroy()
  self.resultServerData = nil
end

function UIFishingResultView:OnBtnCloseBgClick()
  self.ctrl:CloseSelf()
end

function UIFishingResultView:OnBtnConfirmClick()
  self.ctrl:CloseSelf()
end

function UIFishingResultView:Init()
  local meta = DataCenter.FishMetaManager:GetMeta(self.resultServerData.fishId)
  if not meta then
    Logger.LogError("fish meta is nil, fishId = " .. self.resultServerData.fishId)
    return
  end
  if self.resultServerData.result == 1 then
    self.textDesc:SetActive(true)
    self.compNet:SetActive(true)
  else
    self.textDesc:SetActive(false)
    self.compNet:SetActive(false)
  end
  self.textName:SetLocalText(meta.name)
  if self.resultServerData.weight then
    local weightUnit = meta.weight_type == 1 and "%.2fg" or "%.2fkg"
    self.textWeight:SetText(string.format(weightUnit, self.resultServerData.weight))
  else
    self.textWeight:SetText("")
  end
  if self.resultServerData.firstUnlock then
    self.textTitle:SetActive(true)
    self.compNew:SetActive(true)
  else
    self.textTitle:SetActive(false)
    self.compNew:SetActive(false)
  end
  if self.resultServerData.updateWeight then
    self.compNewRecord:SetActive(true)
    if self.resultServerData.rank then
      self.textRank:SetActive(true)
      self.textRank:SetLocalText("s6_fish_settlement_rank", Localization:GetString(meta.name))
      self.textRankNum:SetText(self.resultServerData.rank)
    else
      self.textRank:SetActive(false)
    end
  else
    self.textRank:SetActive(false)
    self.compNewRecord:SetActive(false)
  end
  self.rawImgFish:LoadSpriteAsyncWithCallback(meta.pic, function()
    if self.rawImgFish then
      self.rawImgFish:SetNativeSize()
    end
  end)
end

return UIFishingResultView
