local base = UIBaseView
local UIDecorationMainView = BaseClass("UIDecorationMainView", base)
local UIDecorationTypes = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationTypes")
local UIDecorationIcons = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationIcons")
local UIDecorationMainCity = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCity")
local UIDecorationStickersNew = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationStickersNew")
local UIDecorationStickersContent = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.Comp.UIDecorationStickersContent")
local UIDecorationHeadFrame = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationHeadFrame")
local UIDecorationMultiKill = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMultiKill")
local UIDecorationChatBubble = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationChatBubble")
local EffectDesc = require("UI.UIDecoration.UIDecorationMain.Component.DecorationViewEffectDesc")
local SeasonCallbackInfo = require("UI.LWSeason.LWSeasonMain.Component.SeasonCallback.SeasonCallbackInfo")
local ShowTypeContent = require("UI.UIDecoration.UIDecorationMain.Component.ShowTypeContent")
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "ImgBg/BottomInfo/BtnClose",
    name = "_close_btn",
    type = UIButton,
    onClick = function(self)
      self:CloseSelf()
    end
  },
  {
    path = "ImgBg/EffectRight/Button",
    name = "introBtn",
    type = UIButton,
    onClick = function(self)
      self:OnClickIntro()
    end
  },
  {
    path = "ImgBg/TopBar/ScrollViewTypes",
    name = "types",
    type = UIDecorationTypes
  },
  {
    path = "ImgBg/TypeDecorations",
    name = "iconDecorations",
    type = UIDecorationIcons
  },
  {
    path = "ImgBg/Frame",
    name = "headFrame",
    type = UIDecorationHeadFrame
  },
  {
    path = "ImgBg/MultiKill",
    name = "multiKill",
    type = UIDecorationMultiKill
  },
  {
    path = "ImgBg/ChatBubble",
    name = "chatBubble",
    type = UIDecorationChatBubble
  },
  {
    path = "ImgBg/MainCity",
    name = "mainCity",
    type = UIDecorationMainCity
  },
  {
    path = "ImgBg/StickersContent",
    name = "stickersContent",
    type = UIDecorationStickersContent
  },
  {
    path = "ImgBg/EffectLeft",
    name = "effect_desc",
    type = EffectDesc
  },
  {
    path = "ImgBg/EffectRight",
    name = "effect_right",
    type = UIBaseContainer
  },
  {
    path = "ImgBg/EffectRight/EffectBtn",
    name = "effect_bth",
    type = UIButton,
    onClick = function(self)
      self:OnClickEffect()
    end
  },
  {
    path = "ImgBg/TypeDecorations/TowColScrollView",
    name = "towColScrollView",
    type = UIBaseContainer
  },
  {
    path = "ImgBg/TypeDecorations/OneColScrollView",
    name = "oneColScrollView",
    type = UIBaseContainer
  },
  {
    path = "ImgBg/SkinSkillBtn",
    name = "skin_skill_btn",
    type = UIButton,
    onClick = function(self)
      self:OnClickSkinSkillBtn()
    end
  },
  {
    path = "ImgBg/vipExtendBtn",
    name = "vipExtendBtn",
    type = UIButton,
    onClick = function(self)
      self:OnVipExtendBtnClick()
    end
  },
  {
    path = "ImgBg/vipExtendBtn/vipExtendBtnText",
    name = "vipExtendBtnText",
    type = UITextMeshProUGUIEx
  },
  {
    path = "ImgBg/skinDescVip18",
    name = "skinDescVip18",
    type = UITextMeshProUGUIEx
  },
  {
    path = "ImgBg/UISeasonCallbackInfo",
    name = "seasonCallbackInfo",
    type = SeasonCallbackInfo
  },
  {
    path = "ImgBg/seasonSkinDesc",
    name = "seasonSkinDesc",
    type = UITextMeshProUGUIEx
  },
  {
    path = "ImgBg/ShowTypeContent",
    name = "showTypeContent",
    type = ShowTypeContent
  },
  {
    path = "ImgBg/GoToShopBtn",
    name = "gotoShopBtn",
    type = UIButton,
    onClick = function(self)
      self:OnClickGoToShopBtn()
    end
  },
  {
    path = "ImgBg/GoToShopBtn/GoToShopBtnText",
    name = "gotoShopBtnText",
    type = UITextMeshProUGUIEx
  }
}
local MainCityShowMode = {MainCityShowMode_City = 1, MainCityShowMode_World = 2}

function UIDecorationMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReadUserData()
  self:InitTypes()
end

function UIDecorationMainView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationMainView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.skinDescVip18:SetLocalText("vip_base_skin_desc1")
  self.vipExtendBtnText:SetLocalText("vip_base_skin_button1")
  self.seasonSkinDesc:SetLocalText("season_mastery_s2_UI_24")
  self.showTypeContent:ReInit(function()
    self:OnShowTypeContentChangeType()
  end, function(skillId)
    self:OnShowTypeContentSkillPlay(skillId)
  end)
end

function UIDecorationMainView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIDecorationMainView:ReadUserData()
  local currentSelectType, currentSelectDecoration, backToActivity, isNotWordJump = self:GetUserData()
  self.currentSelectType, self.currentSelectDecoration, self.allTypes, self.allDecorations = self.ctrl:GetPanelData(currentSelectType, currentSelectDecoration)
  self.isNotWordJump = isNotWordJump
  self.backToActivity = backToActivity
  self.mainCityModel = CS.SceneManager.IsInCity() and MainCityShowMode.MainCityShowMode_City or MainCityShowMode.MainCityShowMode_World
  self.isWorldWhenOpen = CS.SceneManager:IsInWorld()
end

function UIDecorationMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
  self:AddUIListener(EventId.DecorationIconSelect, self.OnSelectEvent)
  self:AddUIListener(EventId.RefreshItems, self.OnUserSkinUpdate)
  self:AddUIListener(EventId.VipExtendCityPrivilegeConvert, self.OnVipExtendCityPrivilegeConvert)
end

function UIDecorationMainView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
  self:RemoveUIListener(EventId.DecorationIconSelect, self.OnSelectEvent)
  self:RemoveUIListener(EventId.RefreshItems, self.OnUserSkinUpdate)
  self:RemoveUIListener(EventId.VipExtendCityPrivilegeConvert, self.OnVipExtendCityPrivilegeConvert)
end

function UIDecorationMainView:CloseSelf()
  if self.currentSelectType == DecorationType.DecorationType_Emoji then
    local userdata = {isUse = false}
    EventManager:GetInstance():Broadcast(EventId.DecorationStickerAutoStickerTryClose, userdata)
    if userdata.isUse then
      return
    end
  end
  if self.isWorldWhenOpen then
    if CS.SceneManager:IsInWorld() then
      local isDragonWorld = BattleFieldUtil.InBattleField()
      if not isDragonWorld and not self.isNotWordJump then
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World), nil, 0)
      end
    else
      SceneUtils.ChangeToWorld()
      return
    end
  elseif CS.SceneManager.World then
    CS.SceneManager.World:AutoZoom(CS.SceneManager.World.InitZoom, 0)
  end
  self.ctrl:CloseSelf(self.backToActivity)
end

function UIDecorationMainView:InitTypes()
  self.types:SetData(self.allTypes, self.currentSelectType)
  self:RefreshTypeDecorationsByCurType(self.currentSelectType)
end

function UIDecorationMainView:RefreshTypeDecorationsByCurType(curType)
  if curType == nil then
    curType = DecorationType.DecorationType_Head_Frame
  end
  self:RefreshIconDecorations(curType)
  self:ShowCurrentDecoration()
end

function UIDecorationMainView:RefreshIconDecorations(curType)
  if curType ~= DecorationType.DecorationType_Emoji then
    self.iconDecorations:SetActive(true)
    self.stickersContent:SetActive(false)
    self.iconDecorations:SetData(self.allDecorations, self.currentSelectDecoration, curType)
  end
end

function UIDecorationMainView:SetCurrentType(type)
  self.currentSelectType, self.currentSelectDecoration, self.allTypes, self.allDecorations = self.ctrl:GetPanelData(type, nil)
  self.types:SetSelected(type)
  self:RefreshTypeDecorationsByCurType(type)
end

function UIDecorationMainView:SetCurrentDecoration(decorationId)
  if self.currentSelectType == DecorationType.DecorationType_Emoji then
    self:ShowCurrentDecoration(decorationId)
    return
  end
  self.currentSelectDecoration = decorationId
  self:ShowCurrentDecoration()
end

function UIDecorationMainView:OnClickIntro()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
  UIUtil.ShowIntro(Localization:GetString("2000466"), "", Localization:GetString("2000467"))
end

function UIDecorationMainView:OnSelectEvent(decorationId)
  self:SetCurrentDecoration(decorationId)
end

function UIDecorationMainView:ShowDecorationHeadFrame()
  self.headFrame:SetActive(true)
  self.headFrame:ReInit(self.ctrl:GetHeadFrameData(self.currentSelectDecoration))
end

function UIDecorationMainView:ShowDecorationMultiKill()
  self.multiKill:SetActive(true)
  self.multiKill:ReInit(self.currentSelectDecoration)
end

function UIDecorationMainView:ShowDecorationChatBubble()
  self.chatBubble:SetActive(true)
  self.chatBubble:ReInit(self.ctrl:GetChatBubbleData(self.currentSelectDecoration))
end

function UIDecorationMainView:RemoveCity()
  if self.cityRequest ~= nil then
    self.cityRequest:Destroy()
  end
  self.cityRequest = nil
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainBuild == nil then
    return
  end
  local pointId = mainBuild.pointId
  local build = CS.SceneManager.World:GetObjectByPointId(pointId)
  if build ~= nil then
    build:SetIsVisible(true)
  end
end

function UIDecorationMainView:ShowDecorationMainCity()
  self.mainCity:SetActive(true)
  local para = self.ctrl:GetMainCityData(self.currentSelectDecoration)
  para.zoneType = self.showTypeContent.zoneType
  self.mainCity:SetRtFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
  self.mainCity:ReInit(para)
  if self.seasonCallbackInfo then
    return self.seasonCallbackInfo:TrySetItemById(SeasonCallbackType.Base, self.currentSelectDecoration)
  end
end

function UIDecorationMainView:ShowDecorationTittleName()
  self.mainCity:SetActive(true)
  self.mainCity:ReInit(self.ctrl:GetMainCityData(self.currentSelectDecoration))
end

function UIDecorationMainView:ShowDecorationMainEffct()
  self.mainCity:SetActive(true)
  self.mainCity:ReInit(self.ctrl:GetMainCityData(self.currentSelectDecoration))
end

function UIDecorationMainView:ShowCurrentDecoration(custom)
  if self.mainCity then
    self.mainCity:SetActive(false)
  end
  if self.headFrame ~= nil then
    self.headFrame:SetActive(false)
  end
  if self.multiKill ~= nil then
    self.multiKill:SetActive(false)
  end
  if self.chatBubble ~= nil then
    self.chatBubble:SetActive(false)
  end
  self:RefreshShowTypeContent()
  local hasCallback = false
  if self.currentSelectType == DecorationType.DecorationType_Head_Frame then
    self:ShowDecorationHeadFrame()
  elseif self.currentSelectType == DecorationType.DecorationType_Main_City then
    hasCallback = self:ShowDecorationMainCity()
  elseif self.currentSelectType == DecorationType.DecorationType_TittleName then
    self:ShowDecorationTittleName()
  elseif self.currentSelectType == DecorationType.DecorationType_Main_Effect then
    self:ShowDecorationMainEffct()
  elseif self.currentSelectType == DecorationType.DecorationType_Emoji then
    self:ShowDecorationMapStickers(custom)
  elseif self.currentSelectType == DecorationType.DecorationType_Chat_Bubble then
    self:ShowDecorationChatBubble()
  elseif self.currentSelectType == DecorationType.DecorationType_MultiKill then
    self:ShowDecorationMultiKill()
  end
  if not hasCallback and self.seasonCallbackInfo then
    self.seasonCallbackInfo:SetActive(false)
  end
  self:RefreshEffect()
  self:RefreshSkinSkillBtn()
  self:RefreshVipExtendContent()
  self:RefreshSeasonContent()
end

function UIDecorationMainView:ShowDecorationMapStickers(custom, subType)
  self.iconDecorations:SetActive(false)
  self.stickersContent:SetActive(true)
  local data = {}
  data.AllDecorations = self.allDecorations
  data.DefaultStickerIndex = custom or self.currentSelectDecoration
  data.DefaultSubTab = Mathf.Clamp(checknumber(subType), 1, 3)
  self.stickersContent:ReInit(data)
end

function UIDecorationMainView:RefreshEffect()
  local decorationId = self.currentSelectDecoration
  if self.currentSelectType == DecorationType.DecorationType_Emoji then
    self.effect_desc:SetActive(false)
    return
  else
    self.effect_desc:SetActive(true)
  end
  local effectData = DecorationUtil.GetEffectDesc(decorationId)
  if table.IsNullOrEmpty(effectData) then
    return
  end
  effectData.decorationId = decorationId
  self.effect_right:SetActive(true)
  self.effect_desc:ReInit(effectData)
  local vipPreviewSkinId = LuaEntry.DataConfig:TryGetNum("vip_base_skin_model_config", "k1")
  if self.currentSelectDecoration == vipPreviewSkinId then
    self.effect_right:SetActive(false)
    self.effect_desc:HideEffectNode()
  end
end

function UIDecorationMainView:RefreshVipExtendContent()
  local vipPreviewSkinId = LuaEntry.DataConfig:TryGetNum("vip_base_skin_model_config", "k1")
  local isVipPreviewSkinId = self.currentSelectDecoration == vipPreviewSkinId
  if isVipPreviewSkinId then
    self.vipExtendBtnText:SetLocalText("vip_base_skin_button1")
  end
  local envelopSkinId = LuaEntry.DataConfig:TryGetNum("vip_letter", "k4")
  local canConvertVip18TempSkin = DataCenter.VipExtendManager:CanConvertVip18TempSkin()
  local canShowVip18ConvertBtn = self.currentSelectDecoration == envelopSkinId and canConvertVip18TempSkin
  if canShowVip18ConvertBtn then
    self.vipExtendBtnText:SetLocalText("110029")
  end
  self.vipExtendBtn.gameObject:SetActive(isVipPreviewSkinId or canShowVip18ConvertBtn)
  self.skinDescVip18.gameObject:SetActive(isVipPreviewSkinId)
end

function UIDecorationMainView:RefreshSeasonContent()
  local isSeasonSkinId = DataCenter.DecorationTemplateManager:IsSeasonSkin(self.currentSelectDecoration)
  self.seasonSkinDesc:SetActive(isSeasonSkinId)
end

function UIDecorationMainView:RefreshSkinSkillBtn()
  if self.currentSelectType == DecorationType.DecorationType_Emoji then
    self.skin_skill_btn:SetActive(false)
    return
  end
  local showJumpToDecorationShop = DataCenter.DecorationDataManager:GetIfShowJumpToDecorationShop(self.currentSelectDecoration, self.currentSelectType)
  self.gotoShopBtn:SetActive(showJumpToDecorationShop)
  if showJumpToDecorationShop then
    self.gotoShopBtnText:SetLocalText("2000630")
  end
  local skillList = DataCenter.DecorationDataManager:GetDecorationSkillIdList(self.currentSelectDecoration)
  self.skin_skill_btn:SetActive(0 < #skillList and not showJumpToDecorationShop)
end

function UIDecorationMainView:OnClickEffect()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationEffect)
end

function UIDecorationMainView:OnClickSkinSkillBtn()
  local skillList = DataCenter.DecorationDataManager:GetDecorationSkillIdList(self.currentSelectDecoration)
  local isShow = 0 < #skillList
  if not isShow then
    return
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.currentSelectDecoration)
  local data = DataCenter.DecorationDataManager:GetSkinDataById(self.currentSelectDecoration)
  local isUnlock = template:IsDefault() or data ~= nil and data:IsInExpireTime()
  if not isUnlock then
    local name = Localization:GetString(template.name)
    UIUtil.ShowTips(Localization:GetString("decoration_skill_desc3", name))
    return
  end
  local curScene = CS.SceneManager.CurrSceneID
  local isCanJumpWorld = false
  if curScene == SceneManagerSceneID.City then
    local unlock, lockTips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_WorldBtn)
    if not unlock then
      UIUtil.ShowTipsId(lockTips)
      return
    end
    isCanJumpWorld = true
  elseif curScene == SceneManagerSceneID.World then
    isCanJumpWorld = true
  end
  if not isCanJumpWorld then
    return
  end
  if BattleFieldUtil.InBattleField() then
    return
  end
  if 0 > LuaEntry.Player:GetMainWorldPos() then
    SFSNetwork.SendMessage(MsgDefines.MoveCityToWorld)
  end
  if curScene == SceneManagerSceneID.City or curScene == SceneManagerSceneID.World then
    if curScene == SceneManagerSceneID.World then
      if CrossServerUtil:GetIsCrossServer() then
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos()), nil, 0.02, function()
          SceneUtils.ChangeToCity(function()
          end)
        end, LuaEntry.Player:GetSelfServerId())
      elseif 0 < LuaEntry.Player:GetMainWorldPos() then
        GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos()), CS.SceneManager.World.InitZoom)
      end
    else
      SceneUtils.ChangeToWorld(function()
      end)
    end
    GoToUtil.CloseAllWindows()
    DataCenter.CitySkinSkillManager:SetWaitOpenView()
  end
end

function UIDecorationMainView:OnUserSkinUpdate(evt)
  local dType = checknumber(evt)
  if dType == 0 or dType == checknumber(self.currentSelectType) then
    self.currentSelectType, self.currentSelectDecoration, self.allTypes, self.allDecorations = self.ctrl:GetPanelData(self.currentSelectType, self.currentSelectDecoration)
    self.types:SetSelected(self.currentSelectType)
    self:RefreshTypeDecorationsByCurType(self.currentSelectType)
  end
end

function UIDecorationMainView:OnVipExtendCityPrivilegeConvert()
  self.currentSelectType, self.currentSelectDecoration, self.allTypes, self.allDecorations = self.ctrl:GetPanelData(self.currentSelectType)
  self.types:SetSelected(self.currentSelectType)
  self:RefreshTypeDecorationsByCurType(self.currentSelectType)
end

function UIDecorationMainView:OnVipExtendBtnClick()
  local vipPreviewSkinId = LuaEntry.DataConfig:TryGetNum("vip_base_skin_model_config", "k1")
  local isVipPreviewSkinId = self.currentSelectDecoration == vipPreviewSkinId
  if isVipPreviewSkinId then
    self:CloseSelf()
    PostEventLog.Track(PostEventLog.Defines.Vip18SkinPageEnter, {
      source = "decoration_tab"
    })
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVipExtend)
  end
  local envelopSkinId = LuaEntry.DataConfig:TryGetNum("vip_letter", "k4")
  local isVip18TempSkinId = self.currentSelectDecoration == envelopSkinId
  if isVip18TempSkinId and DataCenter.VipExtendManager:CanConvertVip18TempSkin() then
    SFSNetwork.SendMessage(MsgDefines.VipPrivilegeConvert)
  end
end

function UIDecorationMainView:RefreshShowTypeContent()
  self.showTypeContent:SetData(self.currentSelectType, self.currentSelectDecoration)
end

function UIDecorationMainView:OnShowTypeContentChangeType()
  self:ShowDecorationMainCity()
end

function UIDecorationMainView:OnShowTypeContentSkillPlay(skillId)
  self.mainCity:TryPlaySkillShow(skillId)
end

function UIDecorationMainView:OnClickGoToShopBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.DecorationShop)
  local decorationId = self.currentSelectDecoration ~= nil and self.currentSelectDecoration or 0
  PostEventLog.Track(PostEventLog.Defines.DecorationViewClickGoToBuy, {decorationId = decorationId})
end

return UIDecorationMainView
