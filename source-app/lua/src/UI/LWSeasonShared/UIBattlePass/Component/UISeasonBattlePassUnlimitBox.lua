local base = UIBaseContainer
local UISeasonBattlePassUnlimitBox = BaseClass("UISeasonBattlePassUnlimitBox", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UISeasonBattlePassUnlimitBox:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UISeasonBattlePassUnlimitBox:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonBattlePassUnlimitBox:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.boxImg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.boxImgBtn = self.viewSkin:AddComponent(self, UIButton, 2)
  self.boxImgBtn:SetOnClick(function()
    self:OnBoxImgBtnClick()
  end)
  self.boxName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.boxNameTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.progressBackground = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.progressAmount = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.progressNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.lockContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.notEnoughContent = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.enoughContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.unGetBtn = self.viewSkin:AddComponent(self, UIButton, 11)
  self.unGetBtn:SetOnClick(function()
    self:OnUnGetBtnClick()
  end)
  self.unGetBtnTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.getBtn = self.viewSkin:AddComponent(self, UIButton, 13)
  self.getBtn:SetOnClick(function()
    self:OnGetBtnClick()
  end)
  self.getBtnTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.boxNumContent = self.viewSkin:AddComponent(self, UIBaseContainer, 15)
  self.boxNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.boxName:SetLocalText(320555)
end

function UISeasonBattlePassUnlimitBox:ComponentDestroy()
  self.viewSkin = nil
  self.boxImg = nil
  self.boxImgBtn = nil
  self.boxName = nil
  self.boxNameTip = nil
  self.progressBackground = nil
  self.progressAmount = nil
  self.progressNum = nil
  self.lockContent = nil
  self.notEnoughContent = nil
  self.enoughContent = nil
  self.unGetBtn = nil
  self.unGetBtnTxt = nil
  self.getBtn = nil
  self.getBtnTxt = nil
  self.boxNumContent = nil
  self.boxNum = nil
end

function UISeasonBattlePassUnlimitBox:DataDefine()
  self.activityId = nil
  self.actData = nil
end

function UISeasonBattlePassUnlimitBox:DataDestroy()
  self.activityId = nil
  self.actData = nil
end

function UISeasonBattlePassUnlimitBox:OnAddListener()
  base.OnAddListener(self)
end

function UISeasonBattlePassUnlimitBox:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISeasonBattlePassUnlimitBox:OnBoxImgBtnClick()
  if self.activityId == nil or self.actData == nil then
    return
  end
  local isHave = self.actData:IsHaveExtraReward()
  if not isHave then
    return
  end
  local openParam = {
    title = Localization:GetString("390334"),
    rewardTitle = Localization:GetString("320556"),
    listReward = self.actData.extraReward
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardShow, {anim = true}, openParam)
end

function UISeasonBattlePassUnlimitBox:OnUnGetBtnClick()
  if self.activityId == nil or self.actData == nil then
    return
  end
  local isHave = self.actData:IsHaveExtraReward()
  if not isHave then
    return
  end
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local actname = ""
  if actListData then
    actname = Localization:GetString(actListData.name)
  end
  UIUtil.ShowTips(Localization:GetString("320558", actname))
end

function UISeasonBattlePassUnlimitBox:OnGetBtnClick()
  if self.activityId == nil or self.actData == nil then
    return
  end
  local isHave = self.actData:IsHaveExtraReward()
  if not isHave then
    return
  end
  if self.actData.type == EnumActivity.BattlePass_new.Type then
    SFSNetwork.SendMessage(MsgDefines.NewReceiveBPExtraReward, toInt(self.activityId))
  else
    SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassExtraReward, toInt(self.activityId))
  end
end

function UISeasonBattlePassUnlimitBox:ReInit(activityId)
  self.activityId = activityId
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  if self.actData == nil then
    return
  end
  local isHave = self.actData:IsHaveExtraReward()
  if not isHave then
    return
  end
  local tabData = LocalController:instance():getLine(TableName.Activity, self.activityId)
  if tabData ~= nil then
    local boxImgName = tabData.para_4
    if not string.IsNullOrEmpty(boxImgName) then
      local imgPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath("Assets/Main/Sprites/UI/UIBattlePass/%s.png", boxImgName)
      self.boxImg:LoadSprite(imgPath)
    end
  end
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.boxImg.transform:Set_localPosition(308.3, 73, 0)
  end
  local maxLv, para
  if self.actData.type == EnumActivity.BattlePass_new.Type then
    para = LocalController:instance():getValue(TableName.Activity, self.activityId, "tableInfoType")
  else
    para = toInt(self.activityId)
  end
  local maxLv = DataCenter.ActBattlePassTemplateManager:GetActMaxLv(para, self.actData.type) - 1
  local curLevel = self.actData.battlePass.level
  self.progressBackground:SetActive(false)
  self.boxNumContent:SetActive(false)
  self.lockContent:SetActive(false)
  self.notEnoughContent:SetActive(false)
  self.enoughContent:SetActive(false)
  if maxLv > curLevel then
    self.lockContent:SetActive(true)
    local maxExp = DataCenter.ActBattlePassTemplateManager:GetMaxExp(toInt(self.activityId), self.actData.type)
    self.boxNameTip:SetLocalText(320560, maxExp)
  else
    local curExp = self.actData.battlePass.exp
    local oneBoxExp = self.actData.extraExp
    if self.actData.type == EnumActivity.BattlePass_new.Type then
      local exp = oneBoxExp * self.actData.infiniteNum
      curExp = curExp - exp
    end
    if oneBoxExp > curExp then
      self.progressBackground:SetActive(true)
      self.notEnoughContent:SetActive(true)
      self.boxNameTip:SetLocalText(320557)
      local max = oneBoxExp
      local current = curExp
      local text = current .. "/" .. max
      local progressNum = current / max
      local fillSize = self.progressBackground:GetSizeDelta()
      self.progressAmount:SetSizeDelta(Vector2(progressNum * fillSize.x, fillSize.y))
      self.progressNum:SetText(text)
    else
      self.progressBackground:SetActive(true)
      self.boxNumContent:SetActive(true)
      self.enoughContent:SetActive(true)
      self.boxNameTip:SetLocalText(320557)
      local max = oneBoxExp
      local current = curExp % oneBoxExp
      local boxNum = math.floor(curExp / oneBoxExp)
      local text = current .. "/" .. max
      local progressNum = current / max
      local fillSize = self.progressBackground:GetSizeDelta()
      self.progressAmount:SetSizeDelta(Vector2(progressNum * fillSize.x, fillSize.y))
      self.progressNum:SetText(text)
      self.boxNum:SetText(boxNum)
    end
  end
end

return UISeasonBattlePassUnlimitBox
