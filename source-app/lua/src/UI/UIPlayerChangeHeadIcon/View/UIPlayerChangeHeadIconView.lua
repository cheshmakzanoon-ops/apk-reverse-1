local UIPlayerInfoView = BaseClass("UIPlayerChangeHeadIcon", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local PlayerIconItem = require("UI.UIPlayerChangeHeadIcon.Component.PlayerIconItem")
local txt_title_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local close_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local return_btn_path = "Panel"
local headicon_path = "Root/Content/Up/UIPlayerHead"
local img_up_loading_path = "Root/Content/Up/ImgUploading"
local text_up_loading_path = "Root/Content/Up/ImgUploading/TextUploading"
local player_name_path = "Root/Content/Up/name_txt"
local use_btn_path = "Root/Content/Down/BtnUse"
local use_btn_txt_path = "Root/Content/Down/BtnUse/Text"
local btn_goto_path = "Root/Content/Down/BtnGoto"
local scroll_path = "Root/Content/Mid/ScrollView"
local canUseTxt_path = "Root/Content/CanUseTxt"
local picName = ""

local function OnCreate(self)
  base.OnCreate(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(110084)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.head_icon = self:AddComponent(UICommonHead, headicon_path)
  self.imgUploading = self:AddComponent(UIImage, img_up_loading_path)
  self.textUploading = self:AddComponent(UIText, text_up_loading_path)
  self.textUploading:SetLocalText(280181)
  self.name = self:AddComponent(UIText, player_name_path)
  self.use_btn_txt = self:AddComponent(UIText, use_btn_txt_path)
  self.use_btn_txt:SetLocalText(110046)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:OnUseClick(picName)
  end)
  self.use_btn:SetActive(false)
  self.btn_goto = self:AddComponent(UIButton, btn_goto_path)
  self.btn_goto:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    EventManager:GetInstance():Broadcast(EventId.UIDecorationMainViewOpen)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true}, DecorationType.DecorationType_Head_Frame)
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.apply_list = {}
  self:OnRefreshPlayerIcon()
end

local function OnDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.head_icon = nil
  self.imgUploading = nil
  self.textUploading = nil
  self.name = nil
  self.use_btn_txt = nil
  self.use_btn = nil
  self.canUseTxt = nil
  self.ScrollView = nil
  self.apply_list = nil
  base.OnDestroy(self)
end

local function OnSelect(self, pic)
  picName = pic
  local canShowUseBtn = pic ~= nil and pic ~= LuaEntry.Player:GetPic()
  self.use_btn:SetActive(canShowUseBtn)
  local uid = LuaEntry.Player:GetUid()
  local picVer = LuaEntry.Player.picVer
  local framePath = DataCenter.DecorationDataManager:GetSelfHeadFrame()
  self.head_icon:SetData(uid, pic, picVer, nil, framePath)
end

local function OnRefreshPlayerIcon(self)
  local uid = LuaEntry.Player:GetUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player.picVer
  local name = LuaEntry.Player:GetName()
  if pic == "" then
    self.textUploading:SetLocalText(280182)
    self.imgUploading:SetActive(true)
    self.head_icon:SetCustomLoadCallback(function()
      self.imgUploading:SetActive(false)
      self.head_icon:SetCustomLoadCallback(nil)
    end)
  end
  local framePath = DataCenter.DecorationDataManager:GetSelfHeadFrame()
  self.head_icon:SetData(uid, pic, picVer, nil, framePath)
  self.name:SetText(name)
  self:OnSelect(pic)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.ChangeNameIcon_Select, self.OnSelect)
  self:AddUIListener(EventId.UpdatePlayerHeadIcon, self.OnRefreshPlayerIcon)
  self:AddUIListener(EventId.UploadHead_Start, self.OnUploadHeadStart)
  self:AddUIListener(EventId.UploadHead_End, self.OnUploadHeadEnd)
  self:AddUIListener(EventId.UserSkinUpdate, self.OnRefreshPlayerIcon)
  base.OnAddListener(self)
end

local function RefreshApplyList(self)
  self:ClearScroll(self)
  self.apply_list = self.ctrl:GetAllHeadIconInfo()
  if #self.apply_list > 0 then
    self.ScrollView:SetTotalCount(#self.apply_list)
    self.ScrollView:RefillCells()
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshApplyList()
  local isUploading = LuaEntry.Player:IsPicUploading()
  self.imgUploading:SetActive(isUploading)
end

local function OnDisable(self)
  self:ClearScroll(self)
  base.OnDisable(self)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(PlayerIconItem, itemObj)
  cellItem:SetItemShow(self.apply_list[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, PlayerIconItem)
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(PlayerIconItem)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChangeNameIcon_Select, self.OnSelect)
  self:RemoveUIListener(EventId.UpdatePlayerHeadIcon, self.OnRefreshPlayerIcon)
  self:RemoveUIListener(EventId.UploadHead_Start, self.OnUploadHeadStart)
  self:RemoveUIListener(EventId.UploadHead_End, self.OnUploadHeadEnd)
  self:RemoveUIListener(EventId.UserSkinUpdate, self.OnRefreshPlayerIcon)
end

local function OnUploadHeadStart(self)
  self.textUploading:SetLocalText(280181)
  self.imgUploading:SetActive(true)
end

local function OnUploadHeadEnd(self)
  self.imgUploading:SetActive(false)
end

UIPlayerInfoView.OnCreate = OnCreate
UIPlayerInfoView.OnDestroy = OnDestroy
UIPlayerInfoView.OnEnable = OnEnable
UIPlayerInfoView.OnDisable = OnDisable
UIPlayerInfoView.RefreshApplyList = RefreshApplyList
UIPlayerInfoView.OnItemMoveIn = OnItemMoveIn
UIPlayerInfoView.OnItemMoveOut = OnItemMoveOut
UIPlayerInfoView.ClearScroll = ClearScroll
UIPlayerInfoView.OnSelect = OnSelect
UIPlayerInfoView.OnAddListener = OnAddListener
UIPlayerInfoView.OnRemoveListener = OnRemoveListener
UIPlayerInfoView.OnRefreshPlayerIcon = OnRefreshPlayerIcon
UIPlayerInfoView.OnUploadHeadStart = OnUploadHeadStart
UIPlayerInfoView.OnUploadHeadEnd = OnUploadHeadEnd
return UIPlayerInfoView
