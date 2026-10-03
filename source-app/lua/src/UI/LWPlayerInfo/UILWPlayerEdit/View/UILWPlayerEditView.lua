local UILWPlayerEditView = BaseClass("UILWPlayerEditView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWPlayerEditItem = require("UI.LWPlayerInfo.UILWPlayerEdit.Component.UILWPlayerEditItem")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local PlayerEditItemPrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/PlayerEditItem.prefab"
local InBirthdayImgPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_shengrixitong_dangao_icon.png"
local NotInBirthdayImgPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_shengrixitong_dangao_icon2.png"
local diamondIcon = "Common_icon_gold"
local changeNameCardIcon = "item006"
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local ui_player_head_path = "PopUpTitle/bg/UIPlayerHead"
local user_id_path = "PopUpTitle/bg/UserId"
local btn_copy_id_path = "PopUpTitle/bg/UserId/BtnCopyId"
local user_id_anony_path = "PopUpTitle/bg/UserIdAnonymity"
local btn_copy_id_anony_path = "PopUpTitle/bg/UserIdAnonymity/BtnCopyId1"
local btn_avatar_frame_edit_path = "PopUpTitle/BtnList/BtnAvatarFrameEdit"
local btn_ok_path = "PopUpTitle/BtnList/BtnOK"
local input_field_path = "PopUpTitle/Content/NameNode/InputField"
local warn_text_path = "PopUpTitle/Content/NameNode/warnText"
local num_text_path = "PopUpTitle/Content/NameNode/numText"
local btn_name_edit_path = "PopUpTitle/Content/NameNode/BtnNameEdit"
local btn_name_edit_txt_path = "PopUpTitle/Content/NameNode/BtnNameEdit/BtnNameEditTxt"
local btn_name_edit_layout_path = "PopUpTitle/Content/NameNode/BtnNameEdit/BtnNameEditLayout"
local btn_name_edit_num_path = "PopUpTitle/Content/NameNode/BtnNameEdit/BtnNameEditLayout/BtnNameEditNum"
local btn_name_edit_icon_path = "PopUpTitle/Content/NameNode/BtnNameEdit/BtnNameEditLayout/BtnNameEditIcon"
local btn_name_holder_path = "PopUpTitle/Content/NameNode/InputField/viewport/holder"
local female_select_path = "PopUpTitle/Content/GenderNode/FemaleItem/FemaleSelect"
local male_select_path = "PopUpTitle/Content/GenderNode/MaleItem/MaleSelect"
local empty_select_path = "PopUpTitle/Content/GenderNode/EmptyItem/EmptySelect"
local btn_sex_edit_path = "PopUpTitle/Content/GenderNode/BtnSexEdit"
local hint_icon_path = "PopUpTitle/Content/ImageNode/nameText/HintIcon"
local image_list_path = "PopUpTitle/Content/ImageNode/ImageList"
local birthday_node_content_path = "PopUpTitle/Content/BirthdayNodeContent"
local btn_birthday_edit_path = "PopUpTitle/Content/BirthdayNodeContent/BirthdayNode/BtnBirthdayEdit"
local content_path = "PopUpTitle/Content"
local birthday_icon_path = "PopUpTitle/Content/BirthdayNodeContent/BirthdayNode/infoContent/birthdayIcon"
local birthday_text_path = "PopUpTitle/Content/BirthdayNodeContent/BirthdayNode/infoContent/birthdayText"
local birthday_set_btn_red_dot_path = "PopUpTitle/Content/BirthdayNodeContent/BirthdayNode/BtnBirthdayEdit/BirthdaySetBtnRedDot"
local NormalTypeContentH = 865
local BirthdayItemH = 128

function UILWPlayerEditView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self.checkState = CheckNameType.MinNameChar
  self:ComponentDefine()
end

function UILWPlayerEditView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWPlayerEditView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.NickNameChackEvent, self.OnCheckNameBack)
  self:AddUIListener(EventId.NickNameChangeEvent, self.OnNickNameChanged)
  self:AddUIListener(EventId.GenderChangeEvent, self.OnGenderChanged)
  self:AddUIListener(EventId.UpdatePlayerHeadIcon, self.OnUpdatePlayerHeadIcon)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnUpdatePlayerHeadIcon)
  self:AddUIListener(EventId.UpdateHeadImg, self.OnUpdatePlayerHeadIcon)
  self:AddUIListener(EventId.BirthdaySetDataSuccess, self.OnBirthdaySetDataSuccess)
  self:AddUIListener(EventId.BirthdaySetRewardGet, self.OnBirthdaySetRewardGet)
end

function UILWPlayerEditView:OnRemoveListener()
  self:RemoveUIListener(EventId.NickNameChackEvent, self.OnCheckNameBack)
  self:RemoveUIListener(EventId.NickNameChangeEvent, self.OnNickNameChanged)
  self:RemoveUIListener(EventId.GenderChangeEvent, self.OnGenderChanged)
  self:RemoveUIListener(EventId.UpdatePlayerHeadIcon, self.OnUpdatePlayerHeadIcon)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnUpdatePlayerHeadIcon)
  self:RemoveUIListener(EventId.UpdateHeadImg, self.OnUpdatePlayerHeadIcon)
  self:RemoveUIListener(EventId.BirthdaySetDataSuccess, self.OnBirthdaySetDataSuccess)
  self:RemoveUIListener(EventId.BirthdaySetRewardGet, self.OnBirthdaySetRewardGet)
  base.OnRemoveListener(self)
end

function UILWPlayerEditView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetText(LuaEntry.Player.name)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.birthday_node_content = self:AddComponent(UIBaseContainer, birthday_node_content_path)
  self.btn_birthday_edit = self:AddComponent(UIButton, btn_birthday_edit_path)
  self.content = self:AddComponent(UILayoutElement, content_path)
  self.btn_birthday_edit:SetOnClick(function()
    self:OnBirthdayEditClick()
  end)
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.user_id = self:AddComponent(UITextMeshProUGUIEx, user_id_path)
  self.btn_copy_id = self:AddComponent(UIButton, btn_copy_id_path)
  self.user_id_anony = self:AddComponent(UITextMeshProUGUIEx, user_id_anony_path)
  self.btn_copy_id_anony = self:AddComponent(UIButton, btn_copy_id_anony_path)
  self.btn_avatar_frame_edit = self:AddComponent(UIButton, btn_avatar_frame_edit_path)
  self.btn_ok = self:AddComponent(UIButton, btn_ok_path)
  self.image_list = self:AddComponent(UIBaseContainer, image_list_path)
  self.user_id:SetText(Localization:GetString("208187") .. LuaEntry.Player:GetUid())
  self.btn_copy_id:SetOnClick(function()
    CommonUtil.CopyTextToClipboard(LuaEntry.Player:GetUid())
    UIUtil.ShowTipsId(128031)
  end)
  self.btn_copy_id_anony:SetOnClick(function()
    CommonUtil.CopyTextToClipboard(LuaEntry.Player:GetUid())
    UIUtil.ShowTipsId(128031)
  end)
  local isAnonymity = Setting:GetPrivateBool("AccountSettingAnonymity", true)
  self.user_id:SetActive(not isAnonymity)
  self.user_id_anony:SetActive(isAnonymity)
  self.btn_avatar_frame_edit:SetOnClick(function()
    EventManager:GetInstance():Broadcast(EventId.UIDecorationMainViewOpen)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true}, DecorationType.DecorationType_Head_Frame)
  end)
  self.btn_ok:SetOnClick(function()
    if self.select_slot == nil or self.select_slot == 0 then
      if not string.IsNullOrEmpty(self.select_pic) then
        UIUtil.ShowMessage(Localization:GetString("128134"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          SFSNetwork.SendMessage(MsgDefines.UserChangePic, self.select_pic)
          if self.btn_ok then
            UIGray.SetGray(self.btn_ok.transform, true, false)
          end
        end)
      end
    elseif self.select_slot and self.select_picVer ~= nil and self.select_picVer ~= 0 then
      UIUtil.ShowMessage(Localization:GetString("128134"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.SetHeadPicFromPhotoAlbum, self.select_slot)
        if self.btn_ok then
          UIGray.SetGray(self.btn_ok.transform, true, false)
        end
      end)
    else
      UIUtil.ShowTipsId(120018)
    end
  end)
  UIGray.SetGray(self.btn_ok.transform, true, false)
  self.warn = self:AddComponent(UITextMeshProUGUIEx, warn_text_path)
  self.numTxt = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
  self.btn_name_edit = self:AddComponent(UIButton, btn_name_edit_path)
  self.btn_name_edit_layout = self:AddComponent(UIBaseContainer, btn_name_edit_layout_path)
  self.btn_name_edit_txt = self:AddComponent(UITextMeshProUGUIEx, btn_name_edit_txt_path)
  self.btn_name_edit_num = self:AddComponent(UITextMeshProUGUIEx, btn_name_edit_num_path)
  self.btn_name_edit_icon = self:AddComponent(UIImage, btn_name_edit_icon_path)
  self.btn_name_edit_holder = self:AddComponent(UITextMeshProUGUIEx, btn_name_holder_path)
  self.btn_name_edit:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChangeNameClick()
  end)
  self.input_field = self:AddComponent(UIInput, input_field_path)
  self.input_field:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.input_field:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self:InitButtonState()
  self.female_select = self:AddComponent(UIToggle, female_select_path)
  self.male_select = self:AddComponent(UIToggle, male_select_path)
  self.empty_select = self:AddComponent(UIToggle, empty_select_path)
  self.btn_sex_edit = self:AddComponent(UIButton, btn_sex_edit_path)
  self.female_select:SetOnValueChanged(function(tf)
    if tf then
      self:OnGenderClick(2)
    elseif self.btn_sex_edit and self.male_select:GetIsOn() ~= true then
      UIGray.SetGray(self.btn_sex_edit.transform, true, false)
    end
  end)
  self.male_select:SetOnValueChanged(function(tf)
    if tf then
      self:OnGenderClick(1)
    elseif self.btn_sex_edit and self.female_select:GetIsOn() ~= true then
      UIGray.SetGray(self.btn_sex_edit.transform, true, false)
    end
  end)
  self.empty_select:SetOnValueChanged(function(tf)
    if tf then
      self:OnGenderClick(3)
    elseif self.btn_sex_edit and self.empty_select:GetIsOn() ~= true then
      UIGray.SetGray(self.btn_sex_edit.transform, true, false)
    end
  end)
  self.btn_sex_edit:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnGenderConfirmClick()
  end)
  self.hint_icon = self:AddComponent(UIButton, hint_icon_path)
  self.hint_icon:SetOnClick(function()
    self:OnHintBtnClick()
  end)
  self.birthday_icon = self:AddComponent(UIImage, birthday_icon_path)
  self.birthday_text = self:AddComponent(UITextMeshProUGUIEx, birthday_text_path)
  self.birthday_set_btn_red_dot = self:AddComponent(UIImage, birthday_set_btn_red_dot_path)
  self:OnInitGenderRefresh()
  self:RefreshPicItem()
  self.player_head:SetAsMyself()
end

local NameCount = 0

function UILWPlayerEditView:RefreshPicItem()
  self:SetPicItemCellDestroy()
  local picMaxNum = LuaEntry.DataConfig:TryGetNum("avatar_setting", "k1", 1)
  local headList = self:GetHeadList()
  local index = 1
  self.slotList = {}
  self.picItem = {}
  for i = 1, picMaxNum + #headList do
    self.picItem[i] = self:GameObjectInstantiateAsync(PlayerEditItemPrefabPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.image_list.transform)
      go.transform:Set_localScale(1, 1, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.image_list:AddComponent(UILWPlayerEditItem, nameStr)
      self.slotList[index] = cell
      local name
      if index > picMaxNum then
        name = headList[index - picMaxNum]
      end
      cell:ReInit(0, nil, 0)
      cell:SetIsOn(false)
      if index == picMaxNum + #headList then
        self:OnUpdatePlayerHeadIcon()
      end
      index = index + 1
    end)
  end
end

function UILWPlayerEditView:SetPicItemCellDestroy()
  self.image_list:RemoveComponents(PlayerEditItemPrefabPath)
  if self.picItem ~= nil then
    for k, v in pairs(self.picItem) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.picItem = {}
end

function UILWPlayerEditView:ComponentDestroy()
  self:SetPicItemCellDestroy()
  self.btn_back = nil
  self.hint_icon = nil
  self.birthday_node_content = nil
  self.btn_birthday_edit = nil
  self.content = nil
  self.birthday_icon = nil
  self.birthday_text = nil
  self.birthday_set_btn_red_dot = nil
end

function UILWPlayerEditView:DataDestroy()
  self.hintParam = nil
end

function UILWPlayerEditView:GetHeadList()
  local randomHead = LuaEntry.DataConfig:TryGetStr("random_default_head", "k2", "")
  if string.IsNullOrEmpty(randomHead) then
    return {
      "player_head_1",
      "player_head_3"
    }
  end
  local headList = string.split(randomHead, ",")
  if table.IsNullOrEmpty(headList) then
    return {
      "player_head_1",
      "player_head_3"
    }
  end
  return headList
end

function UILWPlayerEditView:OnUpdatePlayerHeadIcon()
  local userData = UIUtil.GetPlayerInfoShowByUid(LuaEntry.Player.uid)
  local picMaxNum = LuaEntry.DataConfig:TryGetNum("avatar_setting", "k1", 1)
  local headList = self:GetHeadList()
  local hasSlotInfo = userData and userData.slotInfo ~= nil
  for index, slot in ipairs(self.slotList) do
    local slotIndex = index > picMaxNum and 0 or index
    if index <= picMaxNum then
      local slotInfo = hasSlotInfo and userData.slotInfo[index] or 0
      slot:ReInit(slotIndex, nil, slotInfo)
    else
      local name = headList[index - picMaxNum]
      slot:ReInit(slotIndex, name, 0)
    end
    slot:SetIsOn(false)
  end
  self.player_head:SetAsMyself()
  UIGray.SetGray(self.btn_ok.transform, true, false)
end

function UILWPlayerEditView:OnInitGenderRefresh()
  self.female_select:SetIsOn(false)
  self.male_select:SetIsOn(false)
  self.empty_select:SetIsOn(true)
  self:OnGenderRefresh()
  self:OnGenderButtonRefresh()
  self:OnBirthdayRefresh()
  self:OnContentHeightRefresh()
end

function UILWPlayerEditView:OnGenderRefresh()
  self.cur_gender = LuaEntry.Player:GetGender()
  self.cur_gender = self.cur_gender or 0
  self.male_select:SetIsOn(self.cur_gender == 1)
  self.female_select:SetIsOn(self.cur_gender == 2)
  self.empty_select:SetIsOn(self.cur_gender ~= 1 and self.cur_gender ~= 2)
end

function UILWPlayerEditView:OnGenderButtonRefresh()
  local now_gender = LuaEntry.Player:GetGender()
  local cur_gender = self.cur_gender
  if cur_gender == nil or cur_gender == 0 or now_gender == 0 and cur_gender == 3 then
    self.male_select:SetIsOn(false)
    self.female_select:SetIsOn(false)
    self.empty_select:SetIsOn(true)
    UIGray.SetGray(self.btn_sex_edit.transform, true, false)
    return
  end
  if cur_gender == now_gender then
    UIGray.SetGray(self.btn_sex_edit.transform, true, false)
  else
    UIGray.SetGray(self.btn_sex_edit.transform, false, true)
  end
end

function UILWPlayerEditView:OnBirthdaySetDataSuccess()
  self:OnBirthdayRefresh()
end

function UILWPlayerEditView:OnBirthdaySetRewardGet()
  self:RefreshEditBtnRed()
end

function UILWPlayerEditView:OnBirthdayRefresh()
  local isBirthdayFuncOpne = DataCenter.BirthdayDataManager:GetIsSelfBirthdayFuncOpen()
  self.birthday_node_content:SetActive(isBirthdayFuncOpne)
  self.birthday_text:SetLocalText("birthday_7_limit_6")
  self:RefreshEditBtnRed()
end

function UILWPlayerEditView:OnContentHeightRefresh()
  local contentH = NormalTypeContentH
  local isBirthdayFuncOpne = DataCenter.BirthdayDataManager:GetIsSelfBirthdayFuncOpen()
  if isBirthdayFuncOpne then
    contentH = contentH + BirthdayItemH
  end
  self.content:SetMinHeight(contentH)
  self.content:SetPreferredHeight(contentH)
end

function UILWPlayerEditView:OnBirthdayEditClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.BirthdayDataSetPanel, {anim = true})
end

function UILWPlayerEditView:OnGenderClick(new_gender)
  if new_gender == self.cur_gender then
    return
  end
  self.cur_gender = new_gender
  self:OnGenderButtonRefresh()
end

function UILWPlayerEditView:OnGenderConfirmClick()
  SFSNetwork.SendMessage(MsgDefines.GenderChange, self.cur_gender or 3)
end

function UILWPlayerEditView:OnHintBtnClick()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  if self.hintParam == nil then
    self.hintParam = UIHeroTipView.Param.New()
  end
  local param = self.hintParam
  param.dir = UIHeroTipView.Direction.RIGHT
  param.defWidth = 200
  param.pivot = 0.5
  param.position = self.hint_icon.transform.position + Vector3.New(50 * CommonUtil.ArabicAutoMirrorFactor(), 0, 0) * scaleFactor
  param.content = Localization:GetString("avatar_unlock_tips")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function UILWPlayerEditView:OnNickNameChanged()
  self.dialog_title_text:SetText(LuaEntry.Player.name)
  self:InitButtonState()
end

function UILWPlayerEditView:OnGenderChanged()
  self:OnInitGenderRefresh()
end

function UILWPlayerEditView:InitButtonState()
  self.warn:SetText("")
  self.numTxt:SetText("")
  self.input_field:SetText("")
  self.inputValue = ""
  self.canChange = false
  self.haveChangeName = self.ctrl:CheckHaveEnoughItem()
  self.diamondNum = DataCenter.ItemTemplateManager:GetItemPrice(SpecialItemId.CHANGE_NAME)
  if LuaEntry.Player.renameTime < 1 then
    self.btn_name_edit_icon:SetActive(false)
    self.btn_name_edit_num:SetText("(" .. Localization:GetString("130126") .. ")")
  else
    self.btn_name_edit_icon:SetActive(true)
    if self.haveChangeName == true then
      self.diamondNum = 1
      self.btn_name_edit_num:SetText(self.diamondNum)
      self.btn_name_edit_icon:LoadSprite(string.format(LoadPath.ItemPath, changeNameCardIcon))
    else
      self.btn_name_edit_num:SetText(self.diamondNum)
      self.btn_name_edit_icon:LoadSprite(string.format(LoadPath.LWCommonPath, diamondIcon))
    end
  end
  UIGray.SetGray(self.btn_name_edit.transform, true, false)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.btn_name_edit_layout.rectTransform)
end

function UILWPlayerEditView:CanBuy()
  local num = CommonUtil.GetResOrItemCount(ResourceType.Gold)
  if self.haveChangeName == true then
    return true
  end
  if num - self.diamondNum < 0 then
    return false
  end
  return true
end

function UILWPlayerEditView:IptOnValueChange(value)
  self.inputValue = value
  local state = self.ctrl:CheckName(self.inputValue)
  if state == CheckNameType.None then
    self.ctrl:SendCheckNameMessage(self.inputValue)
  else
    self:CheckNameChangeState(state)
  end
  if value ~= nil and value ~= "" then
    self.btn_name_edit_holder:SetActive(false)
  else
    self.btn_name_edit_holder:SetActive(true)
  end
end

function UILWPlayerEditView:OnCheckNameBack(data)
  local state = data
  local len = #self.inputValue
  if len < MIN_AL_NAME_CHAR then
    state = CheckNameType.MinNameChar
  elseif len > MAX_AL_NAME_CHAR then
    state = CheckNameType.MaxNameChar
  end
  self:CheckNameChangeState(state)
end

function UILWPlayerEditView:CheckNameChangeState(type)
  if self.inputValue == "" then
    self.numTxt:SetText("")
  else
    local len = #self.inputValue
    self.numTxt:SetText(len .. "/" .. MAX_AL_NAME_CHAR)
  end
  self.canChange = false
  if self.inputValue == "" then
    self.warn:SetText("")
  else
    self.checkState = type
    if type == CheckNameType.None and self.ctrl:CheckHaveEnoughItem() then
      self.warn:SetText("")
      self.canChange = true
    elseif type == CheckNameType.MinNameChar or type == CheckNameType.MaxNameChar then
      self.warn:SetLocalText(120193)
    elseif type == CheckNameType.Exist then
      self.warn:SetLocalText(280038)
    elseif type == CheckNameType.IllegalChar then
      self.warn:SetLocalText(129082)
    elseif type == CheckNameType.SensitiveWords then
      self.warn:SetLocalText(280073)
    else
      self.canChange = true
      self.warn:SetText("")
    end
  end
  UIGray.SetGray(self.btn_name_edit.transform, not self.canChange, self.canChange)
end

function UILWPlayerEditView:OnChangeNameClick()
  local state = self.checkState
  if self.inputValue == "" then
    state = CheckNameType.MinNameChar
  end
  if state == CheckNameType.IllegalChar then
    UIUtil.ShowTipsId(129082)
    return
  elseif state == CheckNameType.MinNameChar or state == CheckNameType.MaxNameChar then
    UIUtil.ShowTipsId(120193)
    return
  elseif state == CheckNameType.Exist then
    UIUtil.ShowTipsId(280038)
    return
  elseif state == CheckNameType.SensitiveWords then
    UIUtil.ShowTipsId(280073)
    return
  end
  if LuaEntry.Player.renameTime < 1 then
    self.ctrl:SendChangeNameMessage(self.inputValue)
    self.ctrl:CloseSelf()
    return
  end
  local tips = "280028"
  if self.haveChangeName == true then
    tips = "280171"
  elseif self:CanBuy() == false then
    UIUtil.ShowTipsId("E100001")
    return
  end
  UIUtil.ShowMessage(Localization:GetString(tips, self.diamondNum), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
    if not canChat then
      return
    end
    self.ctrl:SendChangeNameMessage(self.inputValue)
  end)
end

function UILWPlayerEditView:SelectHeadIcon(slotId, pic, picVer)
  if pic ~= LuaEntry.Player.pic or picVer ~= LuaEntry.Player.picVer then
    UIGray.SetGray(self.btn_ok.transform, false, true)
  else
    UIGray.SetGray(self.btn_ok.transform, true, false)
  end
  self.select_slot = slotId
  self.select_pic = pic
  self.select_picVer = picVer
end

function UILWPlayerEditView:CheckSelectHeadIcon()
  for _, slot in ipairs(self.slotList) do
    if slot:GetIsOn() then
      return
    end
  end
  UIGray.SetGray(self.btn_ok.transform, true, false)
end

function UILWPlayerEditView:RefreshEditBtnRed()
  local isShow = false
  if DataCenter.BirthdayDataManager:FirstSetRewardHaveGetRedDot() and not DataCenter.BirthdayDataManager:CheckDisplayTypeNotOnlySelf() then
    isShow = true
  end
  self.birthday_set_btn_red_dot:SetActive(isShow)
end

return UILWPlayerEditView
