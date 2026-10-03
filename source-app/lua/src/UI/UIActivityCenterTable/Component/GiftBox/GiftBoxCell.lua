local GiftBoxCell = BaseClass("GiftBoxCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function GiftBoxCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GiftBoxCell:OnDestroy()
  self._first_show_effect:SetActive(false)
  self:DataDestroy()
  base.OnDestroy(self)
end

function GiftBoxCell:ComponentDefine()
  self._this_btn = self:AddComponent(UIButton, "Content/OpenBtn")
  self._del_btn = self:AddComponent(UIButton, "Content/DelBtn")
  self._content = self:AddComponent(UIBaseContainer, "Content")
  self._empty_content = self:AddComponent(UIBaseContainer, "EmptyContent")
  self._this_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickOpen()
  end)
  self._del_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickDel()
  end)
  self._boxKeyNum_txt = self:AddComponent(UIText, "Content/NumText")
  self._time_txt = self:AddComponent(UIText, "Content/TimeContent/TimeText")
  self._empty_txt = self:AddComponent(UIText, "EmptyContent/EmptyText")
  self._empty_txt:SetLocalText(2800016)
  self._giftBox_img = self:AddComponent(UIImage, "Content/BoxImg")
  self._quality_img = self:AddComponent(UIImage, "Content")
  self._timeBg_img = self:AddComponent(UIImage, "Content/TimeContent")
  self._key_img = self:AddComponent(UIImage, "Content/KeyImg")
  self._animator = self:AddComponent(UIAnimator, "")
  self._first_show_effect = self:AddComponent(UIBaseContainer, "Content/ShowEffect")
  self._open_btn_txt = self:AddComponent(UIText, "Content/OpenBtn/OpenBtnText")
  self._open_btn_txt:SetLocalText(390097)
  self._desc_txt = self:AddComponent(UIText, "Content/Desc")
  self._ui_common_res_item = self:AddComponent(UICommonResItem, "Content/UICommonResItem")
  self.percent_bg = self:AddComponent(UIImage, "Content/PercentBg")
  self.percent_txt = self:AddComponent(UITextMeshProUGUIEx, "Content/PercentBg/PercentText")
end

function GiftBoxCell:DataDefine()
  self.param = nil
end

function GiftBoxCell:DataDestroy()
  self.param = nil
end

function GiftBoxCell:ReInit(param, activityId, keyID, index, isShowEffect)
  self.activityId = activityId
  self._boxKeyNum_txt:SetText("")
  self._time_txt:SetText("")
  if param then
    if not self.param and isShowEffect then
      self._first_show_effect:SetActive(false)
      self._first_show_effect:SetActive(true)
      TimerManager:GetInstance():DelayInvoke(function()
        if not IsNull(self._content) then
          self._content:SetActive(true)
          self._empty_content:SetActive(false)
        end
      end, 0.3)
      self._animator:Play("Eff_ui_binfenlihe_huoqubaoxiang", 0, 0)
    else
      self._content:SetActive(true)
      self._empty_content:SetActive(false)
    end
    self.param = param
    self.template = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(param.itemId)
    self._giftBox_img:LoadSprite(string.format(LoadPath.UImystery, self.template.reward_icon))
    self:SetQualityImg()
    self:SetPercent()
    if keyID then
      self.keyId = keyID
      local count = DataCenter.ItemData:GetItemCount(keyID)
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(keyID)
      local countText = tostring(count)
      if count < tonumber(self.template.unlock_cost) then
        countText = "<color=#EF0000>" .. tostring(count) .. "</color>"
      else
        countText = "<color=#00FF00>" .. tostring(count) .. "</color>"
      end
      self._boxKeyNum_txt:SetLocalText(150033, countText, self.template.unlock_cost)
      self._key_img:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
    end
    local rewardParam = DataCenter.ActGiftBoxData:GetActGiftRewardByBoxId(self.activityId, param.itemId)
    self._ui_common_res_item:ReInit(rewardParam)
    self._desc_txt:SetText(DataCenter.ItemTemplateManager:GetName(rewardParam.itemId))
  else
    if self.param then
      self._animator:Play("Eff_ui_binfenlihe_baoxiangxiaoshi", 0, 0)
      TimerManager:GetInstance():DelayInvoke(function()
        if not IsNull(self._content) then
          self._content:SetActive(false)
          self._empty_content:SetActive(true)
        end
      end, 0.3)
    else
      self._content:SetActive(false)
      self._empty_content:SetActive(true)
    end
    self.param = nil
  end
end

function GiftBoxCell:SetQualityImg()
  if self.template.display_color == 1 then
    self._quality_img:LoadSprite(string.format(LoadPath.UImystery, "zyf_kongtouzhaohuan_lvsediban"))
  elseif self.template.display_color == 2 then
    self._quality_img:LoadSprite(string.format(LoadPath.UImystery, "zyf_kongtouzhaohuan_lansediban"))
  elseif self.template.display_color == 3 then
    self._quality_img:LoadSprite(string.format(LoadPath.UImystery, "zyf_kongtouzhaohuan_zisediban"))
  elseif self.template.display_color == 4 then
    self._quality_img:LoadSprite(string.format(LoadPath.UImystery, "zyf_kongtouzhaohuan_huangsediban"))
  elseif self.template.display_color == 5 then
    self._quality_img:LoadSprite(string.format(LoadPath.UImystery, "zyf_kongtouzhaohuan_hongsediban"))
  end
end

function GiftBoxCell:SetPercent()
  if not self.template then
    self.percent_bg:SetActive(false)
    return
  end
  if self.template.display_multiplier_type <= 0 then
    self.percent_bg:SetActive(false)
    return
  else
    self.percent_bg:SetActive(true)
    self.percent_bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivityGiftBox/zyf_kongtouzhaohuan_tip_%d.png", self.template.display_multiplier_type))
    self.percent_txt:SetText(string.format("%s%%", self.template.display_multiplier))
  end
end

function GiftBoxCell:OnClickOpen()
  if self.param then
    local needShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.GiftBoxOpenTip)
    if needShow then
      DataCenter.ActGiftBoxData:SetParam(self.param)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActGiftBoxOpen, self.activityId)
      return
    end
    local haveCount = DataCenter.ItemData:GetItemCount(self.keyId)
    if haveCount < tonumber(self.template.unlock_cost) then
      local canGotoPackShop = DataCenter.ActGiftBoxData:CanGotoPackShop(tonumber(self.activityId))
      if canGotoPackShop then
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, DataCenter.ActGiftBoxData:GetKeyGiftPackId(tonumber(self.activityId)), DataCenter.ActGiftBoxData:GetActKeyById(tonumber(self.activityId)))
      else
        UIUtil.ShowTipsId(320346)
      end
      return
    end
    SFSNetwork.SendMessage(MsgDefines.OpenActivityGiftBox, self.activityId, self.param.uuid)
  end
end

function GiftBoxCell:OnClickDel()
  if self.param then
    UIUtil.ShowMessage(Localization:GetString(2800074), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.ActivityGiftBoxDel, self.activityId, self.param.uuid)
    end)
  end
end

return GiftBoxCell
