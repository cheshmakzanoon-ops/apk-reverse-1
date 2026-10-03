local LWUIMigrationSettingView = BaseClass("LWUIMigrationSettingView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local GroupCell = require("UI.LWUIMigration.Setting.Component.LWUIMigrationView_GroupCell")
local ZoneItem = require("UI.LWUIMigration.Component.LWUIMigrationView_ZoneItem")
local close_btn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local title_path = "Common_bg_orange/Common_img_title/titleText"
local group_path = "Group"
local group_content_path = "Group/GroupContent"
local group_cell_path = "Group/GroupCell"
local btn_set_path = "Common_bg_orange/SetBtn"
local ll_arr_path = "Common_bg_orange/Common_bg_orange2/Limit/LL/LL_Arr"
local ll_num_path = "Common_bg_orange/Common_bg_orange2/Limit/LL/LL_Num"
local ll_btn_path = "Common_bg_orange/Common_bg_orange2/Limit/LL/LL_Btn"
local lp_arr_path = "Common_bg_orange/Common_bg_orange2/Limit/LP/LP_Arr"
local lp_num_path = "Common_bg_orange/Common_bg_orange2/Limit/LP/LP_Num"
local lp_btn_path = "Common_bg_orange/Common_bg_orange2/Limit/LP/LP_Btn"
local btn_info_path = "Common_bg_orange/Common_bg_orange2/Auto/Title/TitleText/BtnInfo"
local green_path = "Common_bg_orange/Common_bg_orange2/Auto/Title/TitleText/slider/green"
local handle_path = "Common_bg_orange/Common_bg_orange2/Auto/Title/TitleText/slider/handle"
local interact_path = "Common_bg_orange/Common_bg_orange2/Auto/Title/TitleText/slider/interact"
local a_l_path = "Common_bg_orange/Common_bg_orange2/Auto/AL"
local a_p_path = "Common_bg_orange/Common_bg_orange2/Auto/AP"
local close_auto_text_path = "Common_bg_orange/Common_bg_orange2/Auto/CloseAutoText"
local desc_text_path = "Common_bg_orange/Common_bg_orange2/Auto/DescText"
local al_arr_path = "Common_bg_orange/Common_bg_orange2/Auto/AL/AL_Arr"
local al_num_path = "Common_bg_orange/Common_bg_orange2/Auto/AL/AL_Num"
local al_btn_path = "Common_bg_orange/Common_bg_orange2/Auto/AL/AL_Btn"
local ap_arr_path = "Common_bg_orange/Common_bg_orange2/Auto/AP/AP_Arr"
local ap_num_path = "Common_bg_orange/Common_bg_orange2/Auto/AP/AP_Num"
local ap_btn_path = "Common_bg_orange/Common_bg_orange2/Auto/AP/AP_Btn"
local text_lang1_path = "Common_bg_orange/Common_bg_orange2/Lang/Lang1/LangText1"
local text_lang2_path = "Common_bg_orange/Common_bg_orange2/Lang/Lang2/LangText2"
local btn_lang_path = "Common_bg_orange/Common_bg_orange2/Lang/LangBtn"
local zone_item_path = "Common_bg_orange/Common_bg_orange2/Msg/ZoneItem"
local text_msg_path = "Common_bg_orange/Common_bg_orange2/Msg/WordBg/WordText"
local btn_edit_path = "Common_bg_orange/Common_bg_orange2/Msg/WordBg/EditBtn"
local IMG_UP_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png"
local IMG_DOWN_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png"
local WORD_MAX = MAX_AL_NAME_CHAR * 2

function LWUIMigrationSettingView:OnCreate()
  base.OnCreate(self)
  self.groupSelCB = BindCallback(self, self.SetGroupSel)
  self.sInfo = DataCenter.ActMigrationManager:GetMyServerInfo()
  self.setInfo = self.sInfo ~= nil and self.sInfo:CloneSetting() or {}
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("migration_activity_interface_10097")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.group = self:AddComponent(UIButton, group_path)
  self.group:SetOnClick(BindCallback(self, self.HideGroup))
  self.group:SetActive(false)
  self.group_content = self:AddComponent(UIBaseContainer, group_content_path)
  self.group_cell = self.transform:Find(group_cell_path).gameObject
  self.group_cell:GameObjectCreatePool()
  self.cells = {}
  self.btn_set = self:AddComponent(UIButton, btn_set_path)
  self.btn_set:SetOnClick(BindCallback(self, self.OnBtnSetClick))
  self.img_arrows = {}
  self.text_nums = {}
  self.btn_arrows = {}
  local ll_arr = self:AddComponent(UIImage, ll_arr_path)
  self.img_arrows[1] = ll_arr
  local ll_num = self:AddComponent(UIText, ll_num_path)
  self.text_nums[1] = ll_num
  local ll_btn = self:AddComponent(UIButton, ll_btn_path)
  self.btn_arrows[1] = ll_btn
  ll_btn:SetOnClick(BindCallback(self, self.OnBtnLLClick))
  local lp_arr = self:AddComponent(UIImage, lp_arr_path)
  self.img_arrows[2] = lp_arr
  local lp_num = self:AddComponent(UIText, lp_num_path)
  self.text_nums[2] = lp_num
  local lp_btn = self:AddComponent(UIButton, lp_btn_path)
  self.btn_arrows[2] = lp_btn
  lp_btn:SetOnClick(BindCallback(self, self.OnBtnLPClick))
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnBtnInfoClick))
  self.green = self:AddComponent(UIImage, green_path)
  self.handle = self:AddComponent(UIImage, handle_path)
  self.interact = self:AddComponent(UIButton, interact_path)
  self.interact:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if not DataCenter.ActMigrationManager:CheckCanSetting(true) then
      return
    end
    self:Switch(not self.isOn)
  end)
  self.a_l = self:AddComponent(UIImage, a_l_path)
  self.a_p = self:AddComponent(UIImage, a_p_path)
  self.close_auto_text = self:AddComponent(UITextMeshProUGUIEx, close_auto_text_path)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  local al_arr = self:AddComponent(UIImage, al_arr_path)
  self.img_arrows[3] = al_arr
  local al_num = self:AddComponent(UIText, al_num_path)
  self.text_nums[3] = al_num
  local al_btn = self:AddComponent(UIButton, al_btn_path)
  self.btn_arrows[3] = al_btn
  al_btn:SetOnClick(BindCallback(self, self.OnBtnALClick))
  local ap_arr = self:AddComponent(UIImage, ap_arr_path)
  self.img_arrows[4] = ap_arr
  local ap_num = self:AddComponent(UIText, ap_num_path)
  self.text_nums[4] = ap_num
  local ap_btn = self:AddComponent(UIButton, ap_btn_path)
  self.btn_arrows[4] = ap_btn
  ap_btn:SetOnClick(BindCallback(self, self.OnBtnAPClick))
  self.text_lang1 = self:AddComponent(UIText, text_lang1_path)
  self.text_lang2 = self:AddComponent(UIText, text_lang2_path)
  self.btn_lang = self:AddComponent(UIButton, btn_lang_path)
  self.btn_lang:SetOnClick(BindCallback(self, self.OnBtnLangClick))
  self.zone_item = self:AddComponent(ZoneItem, zone_item_path)
  self.zone_item:EnableClick(false)
  self.text_msg = self:AddComponent(UIText, text_msg_path)
  self.btn_edit = self:AddComponent(UIButton, btn_edit_path)
  self.btn_edit:SetOnClick(BindCallback(self, self.OnBtnEditClick))
  self:RefreshUI()
end

function LWUIMigrationSettingView:OnDestroy()
  self.langCb = nil
  self.wordCb = nil
  self.setInfo = nil
  self:ClearGroup()
  self.img_arrows = {}
  self.text_nums = {}
  self.btn_arrows = {}
  base.OnDestroy(self)
end

function LWUIMigrationSettingView:OnBtnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIUtil.ShowIntro(Localization:GetString("migration_activity_interface_10131"), nil, Localization:GetString("migration_activity_interface_10130"))
end

function LWUIMigrationSettingView:Switch(isOn)
  self.isOn = isOn
  self.setInfo.applyAutoSwitch = isOn and 1 or 0
  self.green:SetActive(isOn)
  self.handle.transform.anchoredPosition = Vector2.New(isOn and 25 or -25, 0)
  self.a_l:SetActive(isOn)
  self.a_p:SetActive(isOn)
  self.desc_text:SetActive(isOn)
  self.close_auto_text:SetActive(not isOn)
end

function LWUIMigrationSettingView:OnBtnSetClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if not DataCenter.ActMigrationManager:CheckCanSetting(true) then
    return
  end
  if not self:CheckChanged() then
    self.ctrl:CloseSelf()
  else
    UIUtil.ShowSecondMessage("", Localization:GetString("migration_activity_tips_20002"), 2, "migration_activity_tips_20003", "migration_activity_tips_20004", function()
      DataCenter.ActMigrationManager:ReqSetting(self.setInfo)
    end, nil, nil, nil, nil, nil, nil, nil, nil, false)
  end
end

function LWUIMigrationSettingView:OnBtnLLClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if not DataCenter.ActMigrationManager:CheckCanSetting(true) then
    return
  end
  self:ShowGroup(1)
end

function LWUIMigrationSettingView:OnBtnLPClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if not DataCenter.ActMigrationManager:CheckCanSetting(true) then
    return
  end
  self:ShowGroup(2)
end

function LWUIMigrationSettingView:OnBtnALClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if not DataCenter.ActMigrationManager:CheckCanSetting(true) then
    return
  end
  self:ShowGroup(3)
end

function LWUIMigrationSettingView:OnBtnAPClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if not DataCenter.ActMigrationManager:CheckCanSetting(true) then
    return
  end
  self:ShowGroup(4)
end

function LWUIMigrationSettingView:OnBtnLangClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if not DataCenter.ActMigrationManager:CheckCanSetting(true) then
    return
  end
  if not self.langCb then
    self.langCb = BindCallback(self, self.OnLangChanged)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationSetLanguage, {anim = true}, self.setInfo, self.langCb)
end

function LWUIMigrationSettingView:OnBtnEditClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
  if not canChat then
    return
  end
  if not DataCenter.ActMigrationManager:CheckCanSetting(true) then
    return
  end
  if not self.wordCb then
    self.wordCb = BindCallback(self, self.OnWordChanged)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationChangeWord, {anim = true}, self.setInfo, WORD_MAX, self.wordCb)
end

function LWUIMigrationSettingView:RefreshUI()
  self.group:SetActive(false)
  self:SetGroupSel(1, self.setInfo.applyLevel)
  self:SetGroupSel(2, self.setInfo.applyPower)
  self:SetGroupSel(3, self.setInfo.applyAutoLevel)
  self:SetGroupSel(4, self.setInfo.applyAutoPower)
  self:Switch(self.setInfo.applyAutoSwitch == 1)
  self:UpdateLang()
  self.zone_item:SetData(self.sInfo)
  self.zone_item:ShowPlayer()
  self:UpdateWord()
end

function LWUIMigrationSettingView:OnLangChanged(lang1, lang2)
  local langList = {}
  if not string.IsNullOrEmpty(lang1) then
    table.insert(langList, lang1)
  end
  if not string.IsNullOrEmpty(lang2) then
    table.insert(langList, lang2)
  end
  self.setInfo.languageList = langList
  self:UpdateLang()
end

function LWUIMigrationSettingView:UpdateLang()
  local langList = self.setInfo.languageList or {}
  local lang1 = langList[1]
  local flagLang = not string.IsNullOrEmpty(lang1)
  self.text_lang1.transform.parent.gameObject:SetActive(flagLang)
  if flagLang then
    self.text_lang1:SetLocalText(lang1)
  end
  local lang2 = langList[2]
  flagLang = not string.IsNullOrEmpty(lang2)
  self.text_lang2.transform.parent.gameObject:SetActive(flagLang)
  if flagLang then
    self.text_lang2:SetLocalText(lang2)
  end
end

function LWUIMigrationSettingView:OnWordChanged(str)
  self.setInfo.notice = str
  self:UpdateWord()
end

function LWUIMigrationSettingView:UpdateWord()
  local msg = self.setInfo.notice
  if string.IsNullOrEmpty(msg) then
    msg = Localization:GetString("migration_activity_tips_20038")
  end
  self.text_msg:SetText(msg)
end

function LWUIMigrationSettingView:SetGroupSel(type, num)
  self:HideGroup()
  local img_arr = self.img_arrows[type]
  if img_arr then
    img_arr:LoadSpriteAuto(IMG_DOWN_PATH)
  end
  local text_num = self.text_nums[type]
  if text_num then
    text_num:SetText(string.GetFormattedSeparatorNum(math.floor(num)))
  end
  if type == 1 then
    self.setInfo.applyLevel = num
  elseif type == 2 then
    self.setInfo.applyPower = num
  elseif type == 3 then
    self.setInfo.applyAutoLevel = num
  elseif type == 4 then
    self.setInfo.applyAutoPower = num
  end
end

function LWUIMigrationSettingView:CheckChanged()
  if self.setInfo.applyLevel ~= self.sInfo.applyLevel then
    return true
  end
  if self.setInfo.applyPower ~= self.sInfo.applyPower then
    return true
  end
  if self.setInfo.applyAutoLevel ~= self.sInfo.applyAutoLevel then
    return true
  end
  if self.setInfo.applyAutoPower ~= self.sInfo.applyAutoPower then
    return true
  end
  if self.setInfo.applyAutoSwitch ~= self.sInfo.applyAutoSwitch then
    return true
  end
  for i = 1, 2 do
    local lang1 = self.setInfo.languageList[i]
    local lang2 = self.sInfo.languageList[i]
    if lang1 ~= lang2 then
      return true
    end
  end
  if self.setInfo.notice ~= self.sInfo.notice then
    return true
  end
  return false
end

function LWUIMigrationSettingView:HideGroup()
  self.group:SetActive(false)
end

function LWUIMigrationSettingView:ShowGroup(type)
  local target = self.btn_arrows[type]
  if target == nil then
    return
  end
  self.group:SetActive(true)
  local img_arr = self.img_arrows[type]
  if img_arr then
    img_arr:LoadSpriteAuto(IMG_UP_PATH)
  end
  local x, y, z = target:GetPositionXYZ()
  self.group_content:SetPositionXYZ(x, y - 10, z)
  local config = DataCenter.ActMigrationManager:GetOpenConfig()
  local list
  if type == 1 or type == 3 then
    list = config ~= nil and config.baseLv or {}
  elseif type == 2 then
    list = config ~= nil and config.minPower or {}
  elseif type == 4 then
    list = config ~= nil and config.autoPower or {}
  end
  if table.IsNullOrEmpty(list) then
    self:ClearGroup()
    return
  end
  local max = math.max(#self.cells, #list)
  for i = 1, max do
    local num = list[i]
    local item = self.cells[i]
    if num then
      if item == nil then
        local obj = self.group_cell:GameObjectSpawn(self.group_content.transform)
        obj.name = i
        item = self.group_content:AddComponent(GroupCell, obj.name)
        self.cells[i] = item
      end
      item:SetActive(true)
      item:SetData(type, num, self.groupSelCB, i)
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
end

function LWUIMigrationSettingView:ClearGroup()
  self.group_content:RemoveComponents(GroupCell)
  for _, v in ipairs(self.cells) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.group_cell:GameObjectRecycleAll()
  self.cells = {}
end

return LWUIMigrationSettingView
