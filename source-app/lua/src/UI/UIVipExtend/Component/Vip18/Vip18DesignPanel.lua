local Vip18DesignPanel = BaseClass("Vip18DesignPanel", UIBaseContainer)
local base = UIBaseContainer
local Vip18DesignBinder = require("UI.UIVipExtend.Component.Vip18.Auto.Vip18DesignBinder")
local Localization = CS.GameEntry.Localization
local UIDecorationMainCity = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCity")

function Vip18DesignPanel:OnCreate()
  base.OnCreate(self)
  self.binder = Vip18DesignBinder.New()
  self.binder:bind(self)
  self.imgIdx = 1
  self.panelShow = false
  self.con_gro_btnleftarrow:SetOnClick(function()
    self:OnLeftArrowBtnClick()
  end)
  self.con_gro_btnrightarrow:SetOnClick(function()
    self:OnRightArrowBtnClick()
  end)
  self.con_gro_btnanonymity:SetOnClick(function()
    self:OnBtnAnonymityClick()
  end)
  self.bgb_ghi_btnprocess:SetOnClick(function()
    self:OnBtnProcessClick()
  end)
  self.btn_com_new:SetOnClick(function()
    self:OnBtnComNewClick()
  end)
  self.dis_inf_infoiconbtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVipExtendCitySkinProductDesc)
  end)
  SFSNetwork.SendMessage(MsgDefines.Vip18ProductionView)
end

function Vip18DesignPanel:OnEnable()
  base.OnEnable(self)
  self.panelShow = true
  self:UpdateView()
end

function Vip18DesignPanel:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.VipExtendDesignRefresh, self.UpdateView)
  self:AddUIListener(EventId.VipExtendCitySkinListUpdate, self.UpdateView)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:AddUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function Vip18DesignPanel:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.VipExtendDesignRefresh, self.UpdateView)
  self:RemoveUIListener(EventId.VipExtendCitySkinListUpdate, self.UpdateView)
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function Vip18DesignPanel:OnDestroy()
  base.OnDestroy(self)
  self.binder:unbind(self)
  self.binder = nil
  self.panelShow = nil
end

function Vip18DesignPanel:OnBtnAnonymityClick()
  local data = DataCenter.VipExtendManager:GetVipExtendDesignData()
  if data.anonymity == 0 then
    PostEventLog.Track(PostEventLog.Defines.Vip18AnonToggle, {status = "on"})
    SFSNetwork.SendMessage(MsgDefines.Vip18ProductionSetAnonymity, 1)
  else
    UIUtil.ShowConfirmNew({
      contentText = Localization:GetString("vip18_extend_anonymity_warning"),
      btnNum = 2,
      showToggle = false,
      confirmBtnParam = {
        action = function()
          PostEventLog.Track(PostEventLog.Defines.Vip18AnonToggle, {status = "off"})
          SFSNetwork.SendMessage(MsgDefines.Vip18ProductionSetAnonymity, 0)
        end
      }
    })
  end
end

function Vip18DesignPanel:OnBtnProcessClick()
  if DataCenter.VipExtendManager:IsRed() then
    local currentStageStr = DataCenter.VipExtendManager:GetCurrentStageStr()
    local isInRedK1List = DataCenter.VipExtendManager:IsInRedK1List(currentStageStr)
    if isInRedK1List then
      DataCenter.VipExtendManager:ClearRedPoint()
    end
  end
  self:UpdateRedPoint()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip18History, {anim = true})
end

function Vip18DesignPanel:OnBtnComNewClick()
  local data = DataCenter.VipExtendManager:GetVipExtendDesignData()
  if data.stage == 0 then
    self:HandleOperateClick_Step1Idea(data)
  elseif data.stage == 1 then
    self:HandleOperateClick_Step2Design(data)
  elseif data.stage == 2 then
    self:HandleOperateClick_Step3Animation(data)
  elseif data.stage == 3 then
    self:HandleOperateClick_Step4Effect(data)
  elseif data.stage == 4 then
    self:HandleOperateClick_Step5Complete(data)
  end
  if DataCenter.VipExtendManager:IsRed() then
    local currentStageStr = DataCenter.VipExtendManager:GetCurrentStageStr()
    local isInRedK2List = DataCenter.VipExtendManager:IsInRedK2List(currentStageStr)
    if isInRedK2List then
      DataCenter.VipExtendManager:ClearRedPoint()
    end
  end
  self:UpdateRedPoint()
end

function Vip18DesignPanel:InitPanel()
end

function Vip18DesignPanel:ShowPanel()
  self.panelShow = true
  self:UpdateView()
end

function Vip18DesignPanel:HidePanel()
  self.panelShow = false
  if self.city_render_texture ~= nil then
    self:RemoveComponent(self.city_render_texture.gameObject.name, UIDecorationMainCity)
    self.city_render_texture = nil
  end
end

function Vip18DesignPanel:GenRemainingWeek(data)
  local isMinWeekEmpty = data.minWeek == nil
  local isMaxWeekEmpty = data.maxWeek == nil
  if isMinWeekEmpty and isMaxWeekEmpty then
    return 0
  elseif isMinWeekEmpty and not isMaxWeekEmpty then
    return data.maxWeek
  elseif not isMinWeekEmpty and isMaxWeekEmpty then
    return data.minWeek
  else
    return data.minWeek .. "-" .. data.maxWeek
  end
end

function Vip18DesignPanel:UpdateView()
  if DataCenter.VipExtendManager:IsVip18SkinDoneAndReceived() then
    self:UpdateView_SkinDone()
  else
    self:UpdateView_Design()
  end
  local data = DataCenter.VipExtendManager:GetVipExtendDesignData()
  self:UpdateAnonymity(data.anonymity)
  self:UpdateRedPoint()
end

function Vip18DesignPanel:UpdateView_Design()
  local data = DataCenter.VipExtendManager:GetVipExtendDesignData()
  self.display_panel:SetActive(true)
  self.skin_done_panel:SetActive(false)
  self.can_con_grouptopboxgift:SetActive(false)
  self.can_con_grouptopmaliao:SetActive(false)
  self.can_con_grouptopskin:SetActive(false)
  self.can_con_grouptopreward:SetActive(false)
  self.group_hua_cao_tu:SetActive(false)
  self.can_con_tmpdavidskinname:SetLocalText("vip18_extend_skin_name", LuaEntry.Player.name)
  self.con_bgb_textkeywords:SetActive(false)
  self:UpdateTimeline(data.stage + 1)
  if data.stage == 0 then
    self:UpdateView_Step1Idea(data)
  elseif data.stage == 1 then
    self:UpdateView_Step2Design(data)
  elseif data.stage == 2 then
    self:UpdateView_Step3Animation(data)
  elseif data.stage == 3 then
    self:UpdateView_Step4Effect(data)
  elseif data.stage == 4 then
    self:UpdateView_Step5Complete(data)
  end
end

function Vip18DesignPanel:UpdateView_Step1Idea(data)
  self.can_con_grouptopboxgift:SetActive(true)
  self.btn_com_new:SetActive(true)
  self.con_bgb_textbasicskin:SetLocalText("vip18_extend_step1_idea")
  if data.subStage == 0 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design11_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design11_operate")
    self.btn_com_btntext:SetLocalText("vip18_extend_design11_button")
  elseif data.subStage == 1 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design12_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design12_operate")
    self.btn_com_btntext:SetLocalText("vip18_extend_design12_button")
  elseif data.subStage == 2 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design13_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design12_operate")
    self.btn_com_btntext:SetLocalText("vip18_extend_design12_button")
  elseif data.subStage == 3 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design14_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design14_operate")
    self.btn_com_btntext:SetLocalText("vip18_extend_design14_button")
  end
end

function Vip18DesignPanel:HandleOperateClick_Step1Idea(data)
  if data.subStage == 0 then
    self:ContactUsByLanguage()
  elseif data.subStage == 1 then
    self:ContactUsByLanguage()
  elseif data.subStage == 2 then
    self:ContactUsByLanguage()
  elseif data.subStage == 3 then
    SFSNetwork.SendMessage(MsgDefines.Vip18ProductionFinish, data.stage)
  end
end

function Vip18DesignPanel:UpdateView_Step2Design(data)
  self.btn_com_new:SetActive(false)
  self.con_bgb_textbasicskin:SetLocalText("vip18_extend_step2_draw")
  if data.subStage == 0 then
    self.group_hua_cao_tu:SetActive(true)
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design21_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design21_operate")
  elseif data.subStage == 1 then
    self.group_hua_cao_tu:SetActive(true)
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design22_bubble", self:GenRemainingWeek(data))
    self.con_bgb_textoption:SetLocalText("vip18_extend_design22_operate")
  elseif data.subStage == 2 then
    self.can_con_grouptopskin:SetActive(true)
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design23_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design23_operate")
    self:UpdateView_Step2Design_Photo(data)
    self.btn_com_new:SetActive(true)
    self.btn_com_btntext:SetLocalText("vip18_extend_design11_button")
  elseif data.subStage == 3 then
    self.can_con_grouptopskin:SetActive(true)
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design24_bubble", self:GenRemainingWeek(data))
    self.con_bgb_textoption:SetLocalText("vip18_extend_design24_operate")
    self:UpdateView_Step2Design_Photo(data)
  elseif data.subStage == 4 then
    self.can_con_grouptopskin:SetActive(true)
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design25_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design23_operate")
    self.btn_com_new:SetActive(true)
    self.btn_com_btntext:SetLocalText("vip18_extend_design11_button")
    self:UpdateView_Step2Design_Photo(data)
  elseif data.subStage == 5 then
    self.can_con_grouptopskin:SetActive(true)
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design26_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design26_operate")
    self:UpdateView_Step2Design_Photo(data)
    self.btn_com_new:SetActive(true)
    self.btn_com_btntext:SetLocalText("vip18_extend_design14_button")
  end
end

function Vip18DesignPanel:OnLeftArrowBtnClick()
  self.imgIdx = self.imgIdx - 1
  if self.imgIdx < 1 then
    self.imgIdx = 1
  end
  local data = DataCenter.VipExtendManager:GetVipExtendDesignData()
  self:UpdateView_Step2Design_Photo(data)
  self:UpdatePhotoArrowState(data)
end

function Vip18DesignPanel:OnRightArrowBtnClick()
  local data = DataCenter.VipExtendManager:GetVipExtendDesignData()
  if data.picVerList == nil or #data.picVerList < 1 then
    return
  end
  self.imgIdx = self.imgIdx + 1
  if self.imgIdx > #data.picVerList then
    self.imgIdx = #data.picVerList
  end
  self:UpdateView_Step2Design_Photo(data)
  self:UpdatePhotoArrowState(data)
end

function Vip18DesignPanel:UpdatePhotoArrowState(data)
  if data.picVerList == nil or #data.picVerList < 1 then
    self.con_gro_btnleftarrow:SetActive(false)
    self.con_gro_btnrightarrow:SetActive(false)
    return
  end
  local length = #data.picVerList
  if self.imgIdx == length then
    self.con_gro_btnrightarrow:SetActive(false)
  else
    self.con_gro_btnrightarrow:SetActive(true)
  end
  if self.imgIdx == 1 then
    self.con_gro_btnleftarrow:SetActive(false)
  else
    self.con_gro_btnleftarrow:SetActive(true)
  end
  self.gro_cao_textnumber:SetText(self.imgIdx .. "/" .. length)
end

function Vip18DesignPanel:GenAssetKey(uid, picVer, useBig)
  local md5 = CS.AESHelper.GetMd5Hash(uid .. "_" .. picVer)
  local tempStr = uid
  if string.len(tempStr) > 6 then
    tempStr = string.sub(tempStr, string.len(tempStr) - 5)
  end
  local suffix = ""
  if useBig then
    suffix = "_big"
  end
  return string.format("%s/%s%s.jpg", tempStr, md5, suffix)
end

function Vip18DesignPanel:UpdateView_Step2Design_Photo(data)
  if data.picVerList == nil then
    return
  end
  if data.picVerList[self.imgIdx] == nil then
    return
  end
  self.UIChatSendPhoto = self.ChatSendPhotoNode.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  if self.UIChatSendPhoto == nil then
    Logger.LogError("\230\156\139\229\143\139\229\156\136\226\128\148\226\128\148\226\128\148\226\128\148\229\155\190\231\137\135Item\239\188\140\228\184\141\229\173\152\229\156\168UIChatSendPhoto\232\132\154\230\156\172")
    return
  end
  self.RootImgLoading:SetActive(false)
  self.RootImgLoadFail:SetActive(false)
  self.picVer = data.picVerList[self.imgIdx]
  self.assetKey = self:GenAssetKey(LuaEntry.Player.uid, self.picVer, false)
  self.UIChatSendPhoto:SetData(PhotoFuncType.MomentPickPhoto, LuaEntry.Player.uid, 0, self.assetKey, false)
  self:SetUILoadingShow(self.assetKey)
  self.UIChatSendPhoto:StartUpdateSmallPhoto()
  self:UpdatePhotoArrowState(data)
end

function Vip18DesignPanel:SetUILoadingShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self.RawImgChatPhoto:LoadSprite(ChatSendPhotoLoadingBgPath)
  self.BtnChatPhoto:SetOnClick(function()
  end)
  self.RootImgLoading:SetActive(true)
  self.RootImgLoadFail:SetActive(false)
end

function Vip18DesignPanel:SetUIReloadShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self.RawImgChatPhoto:LoadSprite(ChatSendPhotoReloadBgPath)
  self.BtnChatPhoto:SetOnClick(function()
    self:SetUILoadingShow(assetKey)
    self.UIChatSendPhoto:RequestTextureData(assetKey, false)
  end)
  self.RootImgLoading:SetActive(false)
  self.RootImgLoadFail:SetActive(true)
end

function Vip18DesignPanel:SetUILoadedSuccessShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self.UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self.RawImgChatPhoto:SetTexture(cacheItem.textureAsset)
  self.BtnChatPhoto:SetOnClick(function()
    local tmpChatData = {
      getSenderUid = function()
        return LuaEntry.Player.uid
      end,
      getExtra = function()
        local tmpData = {
          picVer = self.picVer,
          bigHeight = 800,
          bigWidth = 800
        }
        return tmpData
      end
    }
    local param = {}
    param.chatData = tmpChatData
    param.smallAssetKey = self.assetKey
    param.photoFuncType = PhotoFuncType.MomentPickPhoto
    param.bigAssetKey = self:GenAssetKey(LuaEntry.Player.uid, self.picVer, true)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatViewBigPhotoView, {anim = true}, param)
  end)
  self.RootImgLoading:SetActive(false)
  self.RootImgLoadFail:SetActive(false)
end

function Vip18DesignPanel:HandleOperateClick_Step2Design(data)
  if data.subStage == 2 then
    self:ContactUsByLanguage()
  elseif data.subStage == 4 then
    self:ContactUsByLanguage()
  elseif data.subStage == 5 then
    SFSNetwork.SendMessage(MsgDefines.Vip18ProductionFinish, data.stage)
  end
end

function Vip18DesignPanel:UpdateView_Step3Animation(data)
  self.can_con_grouptopskin:SetActive(true)
  self.btn_com_new:SetActive(false)
  self.con_bgb_textbasicskin:SetLocalText("vip18_extend_step3_animation")
  if data.subStage == 0 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design31_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design31_operate")
  elseif data.subStage == 1 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design32_bubble", self:GenRemainingWeek(data))
    self.con_bgb_textoption:SetLocalText("vip18_extend_design31_operate")
  elseif data.subStage == 2 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design33_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design23_operate")
    self.btn_com_new:SetActive(true)
    self.btn_com_btntext:SetLocalText("vip18_extend_design11_button")
  elseif data.subStage == 3 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design34_bubble", self:GenRemainingWeek(data))
    self.con_bgb_textoption:SetLocalText("vip18_extend_design24_operate")
  elseif data.subStage == 4 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design25_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design23_operate")
    self.btn_com_new:SetActive(true)
    self.btn_com_btntext:SetLocalText("vip18_extend_design11_button")
  elseif data.subStage == 5 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design36_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design36_operate")
    self.btn_com_new:SetActive(true)
    self.btn_com_btntext:SetLocalText("vip18_extend_design14_button")
  end
  self:UpdateView_Step2Design_Photo(data)
end

function Vip18DesignPanel:HandleOperateClick_Step3Animation(data)
  if data.subStage == 2 then
    self:ContactUsByLanguage()
  elseif data.subStage == 4 then
    self:ContactUsByLanguage()
  else
    SFSNetwork.SendMessage(MsgDefines.Vip18ProductionFinish, data.stage)
  end
end

function Vip18DesignPanel:UpdateView_Step4Effect(data)
  self.can_con_grouptopskin:SetActive(true)
  self.btn_com_new:SetActive(false)
  self.con_bgb_textbasicskin:SetLocalText("vip18_extend_step4_effect")
  if data.subStage == 0 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design41_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design41_operate")
  elseif data.subStage == 1 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design42_bubble", self:GenRemainingWeek(data))
    self.con_bgb_textoption:SetLocalText("vip18_extend_design41_operate")
  elseif data.subStage == 2 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design43_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design23_operate")
    self.btn_com_new:SetActive(true)
    self.btn_com_btntext:SetLocalText("vip18_extend_design11_button")
  elseif data.subStage == 3 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design34_bubble", self:GenRemainingWeek(data))
    self.con_bgb_textoption:SetLocalText("vip18_extend_design24_operate")
  elseif data.subStage == 4 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design25_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design23_operate")
    self.btn_com_new:SetActive(true)
    self.btn_com_btntext:SetLocalText("vip18_extend_design11_button")
  elseif data.subStage == 5 then
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design46_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design46_operate")
    self.btn_com_new:SetActive(true)
    self.btn_com_btntext:SetLocalText("vip18_extend_design14_button")
  end
  self:UpdateView_Step2Design_Photo(data)
end

function Vip18DesignPanel:HandleOperateClick_Step4Effect(data)
  if data.subStage == 2 then
    self:ContactUsByLanguage()
  elseif data.subStage == 4 then
    self:ContactUsByLanguage()
  else
    SFSNetwork.SendMessage(MsgDefines.Vip18ProductionFinish, data.stage)
  end
end

function Vip18DesignPanel:UpdateView_Step5Complete(data)
  self.btn_com_new:SetActive(false)
  if data.subStage == 0 then
    self.can_con_grouptopmaliao:SetActive(true)
    self.con_bgb_textbasicskin:SetLocalText("vip18_extend_step5_wait")
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design51_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design51_operate")
  elseif data.subStage == 1 then
    self.can_con_grouptopmaliao:SetActive(true)
    self.con_bgb_textbasicskin:SetLocalText("vip18_extend_step5_wait")
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design52_bubble", self:GenRemainingWeek(data))
    self.con_bgb_textoption:SetLocalText("vip18_extend_design52_operate")
  elseif data.subStage == 2 then
    self.can_con_grouptopreward:SetActive(true)
    self.con_bgb_textbasicskin:SetLocalText("vip18_extend_step5_finish")
    self.con_bgb_textcontent:SetLocalText("vip18_extend_design53_bubble")
    self.con_bgb_textoption:SetLocalText("vip18_extend_design53_operate")
    self.btn_com_new:SetActive(true)
    self.btn_com_btntext:SetLocalText("vip18_extend_design53_button")
  end
end

function Vip18DesignPanel:HandleOperateClick_Step5Complete(data)
  local rewardItemId = LuaEntry.DataConfig:TryGetNum("vip_letter", "k3")
  local item = DataCenter.ItemData:GetItemById(rewardItemId)
  if item ~= nil then
    GoToUtil.GotoOpenView(UIWindowNames.UILWBagMain)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true}, DecorationType_Main_City, 16000)
end

function Vip18DesignPanel:UpdateTimeline(stageIdx)
  for i = 1, 5 do
    if i < stageIdx then
      self.mul_bgb_gro_steps[i].gro_ste_gempty:SetActive(false)
      self.mul_bgb_gro_steps[i].gro_ste_gcurrent:SetActive(false)
      self.mul_bgb_gro_steps[i].gro_ste_gpass:SetActive(true)
    elseif i == stageIdx then
      self.mul_bgb_gro_steps[i].gro_ste_gempty:SetActive(false)
      self.mul_bgb_gro_steps[i].gro_ste_gcurrent:SetActive(true)
      self.mul_bgb_gro_steps[i].gro_ste_gpass:SetActive(false)
    else
      self.mul_bgb_gro_steps[i].gro_ste_gempty:SetActive(true)
      self.mul_bgb_gro_steps[i].gro_ste_gcurrent:SetActive(false)
      self.mul_bgb_gro_steps[i].gro_ste_gpass:SetActive(false)
    end
    if i <= 4 then
      if i < stageIdx then
        self.mul_bgb_gro_bgkong1[i]:SetActive(true)
      else
        self.mul_bgb_gro_bgkong1[i]:SetActive(false)
      end
    end
  end
end

function Vip18DesignPanel:UpdateAnonymity(anonymity)
  if anonymity == 1 then
    self.con_gro_imageduihao:SetActive(true)
  else
    self.con_gro_imageduihao:SetActive(false)
  end
end

function Vip18DesignPanel:UpdateRedPoint(data)
  self.historyRedPoint:SetActive(false)
  self.optionRedPoint:SetActive(false)
  self.optionLightFrame:SetActive(false)
  local currentStageStr = DataCenter.VipExtendManager:GetCurrentStageStr()
  if DataCenter.VipExtendManager:IsRed() then
    local isInRedK1List = DataCenter.VipExtendManager:IsInRedK1List(currentStageStr)
    if isInRedK1List then
      self.historyRedPoint:SetActive(true)
      return
    end
    local isInRedK2List = DataCenter.VipExtendManager:IsInRedK2List(currentStageStr)
    if isInRedK2List then
      self.optionRedPoint:SetActive(true)
      return
    end
  end
end

function Vip18DesignPanel:UpdateView_SkinDone()
  if self.panelShow == false then
    return
  end
  self.display_panel:SetActive(false)
  self.skin_done_panel:SetActive(true)
  local skinInfo = DataCenter.VipExtendManager:GetMyselfSkinInfo()
  self.compUIPlayerHead:SetAsMyself()
  local first_name_str = LuaEntry.Player.name
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data ~= nil then
    first_name_str = UIUtil.FormatServerAllianceName(nil, data.abbr, LuaEntry.Player.name, LuaEntry.Player.uid)
  end
  self.player_name:SetText(first_name_str)
  if string.IsNullOrEmpty(skinInfo.displayPara2) then
    return
  end
  self.making_root.gameObject:SetActive(skinInfo.displayType == 1)
  self.complete_root.gameObject:SetActive(skinInfo.displayType == 2 or skinInfo.displayType == 3)
  local skinId = tonumber(skinInfo.displayPara2)
  local skinData = DataCenter.DecorationDataManager:GetSkinDataById(skinId)
  local skinTemplate = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  if skinInfo.displayType == 2 or skinInfo.displayType == 3 then
    local rtData = {}
    rtData.decorationId = tonumber(skinInfo.displayPara2)
    if self.city_render_texture == nil then
      self.city_render_texture = self:AddComponent(UIDecorationMainCity, "skinDonePanel/completeRoot/cityRenderTexture")
      self.city_render_texture:SetRtFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
    end
    self.city_render_texture:ReInit(rtData)
  end
  if skinTemplate ~= nil and not string.IsNullOrEmpty(skinTemplate.name) then
    self.city_name:SetLocalText(skinTemplate.name)
  end
  if not string.IsNullOrEmpty(skinInfo.displayPara3) then
    self.desc:SetLocalText(skinInfo.displayPara3)
  end
end

function Vip18DesignPanel:ContactUsByLanguage()
  PostEventLog.Track(PostEventLog.Defines.Vip18ContactServiceClick, {
    contact_method = "contact_us_button"
  })
  DataCenter.VipExtendManager:ContactUsByLanguage()
end

return Vip18DesignPanel
