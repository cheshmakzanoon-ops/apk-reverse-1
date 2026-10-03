local UILWPlayerDetailMiddle = BaseClass("UILWPlayerDetailMiddle", UIBaseContainer)
local base = UIBaseContainer
local UILWPlayerDetailItem = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Middle.UILWPlayerDetailItem")
local UILWPlayerDetailBattleInfoItem = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Middle.UILWPlayerDeatilBattleInfoItem")
local UILWPlayerDetailServerInfoItem = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Middle.UILWPlayerDeatilServerInfoItem")
local UILWPlayerBirthdayDataShowContent = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Middle.UILWPlayerBirthdayDataShowContent")
local UILWPlayerDetailStatus = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Middle.UILWPlayerDetailStatus")
local UITitleShowList = require("UI.LWTitle.Component.UITitleShowList")
local birthday_data_show_content_title_path = "pic/titleRoot/titleStatus/birthdayDataShowContentTitle"
local birthday_data_show_content_path = "pic/status/birthdayDataShowContent"
local BattleInfoConfig = {
  {
    name = "power",
    icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_zhujiemian_tubiao_zhanli.png",
    type = PlayerBattleInfoType.Power
  },
  {
    name = "kill",
    icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_jisha.png",
    type = PlayerBattleInfoType.Kill
  },
  {
    name = "career",
    icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_yingxiong_zhujiemian_tubiao_zhanli.png",
    type = PlayerBattleInfoType.Career
  },
  {
    name = "gift",
    icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_moments_gift_icon.png",
    type = PlayerBattleInfoType.Gift
  }
}
local NormalTypeH = 317.941
local OneItemH = 82

function UILWPlayerDetailMiddle:OnCreate()
  base.OnCreate(self)
  self.firstShow = false
  self:ComponentDefine()
  self:ReInit()
end

function UILWPlayerDetailMiddle:ComponentDestroy()
  self.battleInfoCom:RemoveComponents(UILWPlayerDetailBattleInfoItem)
  self.battleInfoItem:GameObjectRecycleAll()
  self.picCom = nil
  self.battleInfoItem = nil
  self.alliance = nil
end

function UILWPlayerDetailMiddle:OnDestroy()
  self:UnloadLightsweepEffect()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPlayerDetailMiddle:DataDestroy()
  self.data = nil
end

function UILWPlayerDetailMiddle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BirthdaySetDataSuccess, self.OnBirthdaySetDataSuccessMsg)
end

function UILWPlayerDetailMiddle:OnRemoveListener()
  self:RemoveUIListener(EventId.BirthdaySetDataSuccess, self.OnBirthdaySetDataSuccessMsg)
  base.OnRemoveListener(self)
end

function UILWPlayerDetailMiddle:ComponentDefine()
  self.picCom = self:AddComponent(UILWPlayerDetailItem, "pic/PlayerPicLoopList")
  self.battleInfoItem = self.transform:Find("battleInfo/battleInfoItem").gameObject
  self.alliance = self:AddComponent(UILWPlayerDetailServerInfoItem, "serverInfo/alliance")
  self.server = self:AddComponent(UILWPlayerDetailServerInfoItem, "serverInfo/server")
  self.battleInfoCom = self:AddComponent(UIBaseContainer, "battleInfo")
  self.battleInfoItem:GameObjectCreatePool()
  self.detailStatus = self:AddComponent(UILWPlayerDetailStatus, "pic/status")
  self.detailStatusTitle = self:AddComponent(UILWPlayerDetailStatus, "pic/titleRoot/titleStatus")
  self.titleRoot = self:AddComponent(UIBaseContainer, "pic/titleRoot")
  self.titleContent = self:AddComponent(UITitleShowList, "pic/titleRoot/titleContent")
  self.layoutElement = self:AddComponent(UILayoutElement, "")
  self.birthdayIcon = self:AddComponent(UIImage, "pic/birthdayIcon")
  self.birthday_data_show_content_title = self:AddComponent(UILWPlayerBirthdayDataShowContent, birthday_data_show_content_title_path)
  self.birthday_data_show_content = self:AddComponent(UILWPlayerBirthdayDataShowContent, birthday_data_show_content_path)
end

function UILWPlayerDetailMiddle:ReInit(data)
  if not data then
    return
  end
  self.data = data
  self:RefreshBattleInfo(data)
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ALLIANCE_CENTER)
  if mainBuild then
    self.alliance:SetActive(true)
    self.server:SetActive(true)
    self.alliance:ReInit(data, PlayerServerInfoType.Alliance)
    self.server:ReInit(data, PlayerServerInfoType.Server)
  else
    self.alliance:SetActive(false)
    self.server:SetActive(false)
  end
  self.picCom:SetHeadInfo(data)
  self:RefreshTitleAndStatus(data)
  local isShowBirthdayItem = false
  local isBirthdayFuncOpne = DataCenter.BirthdayDataManager:GetIsSelfBirthdayFuncOpen()
  if isBirthdayFuncOpne and self.data then
    if self.data.uid == LuaEntry.Player.uid then
      if DataCenter.BirthdayDataManager:CheckDisplayTypeNotOnlySelf() or string.IsNullOrEmpty(self.data.birthday) then
        isShowBirthdayItem = true
      end
    elseif not string.IsNullOrEmpty(self.data.birthday) and DataCenter.BirthdayDataManager:CheckIsPassSetShowArea(self.data.uid, self.data.allianceId, self.data.birthdayDisplay) then
      isShowBirthdayItem = true
    end
  end
  if isShowBirthdayItem then
    self.birthday_data_show_content_title:SetActive(true)
    self.birthday_data_show_content:SetActive(true)
    self.birthday_data_show_content_title:ReInit(data)
    self.birthday_data_show_content:ReInit(data)
  else
    self.birthday_data_show_content_title:SetActive(false)
    self.birthday_data_show_content:SetActive(false)
  end
  local middleContentH = NormalTypeH
  self.layoutElement:SetMinHeight(middleContentH)
  self.layoutElement:SetPreferredHeight(middleContentH)
  self:SetSizeDeltaY(middleContentH)
  self:RefreshBirthdayIcon()
end

function UILWPlayerDetailMiddle:RefreshBirthdayIcon()
  local isInBirthday = false
  if self.data == nil then
    self.birthdayIcon:SetActive(isInBirthday)
    return
  end
  local isHaveSet = false
  local zodType = BirthdayZodType.Hide
  local birthdayStr
  if self.data.uid == LuaEntry.Player.uid then
    if not string.IsNullOrEmpty(self.data.birthday) then
      isHaveSet = true
      birthdayStr = self.data.birthday
    end
    local setData = DataCenter.BirthdayDataManager:GetSetData()
    if setData and setData.zodType then
      zodType = setData.zodType
    end
  elseif not string.IsNullOrEmpty(self.data.birthday) then
    if DataCenter.BirthdayDataManager:CheckIsPassSetShowArea(self.data.uid, self.data.allianceId, self.data.birthdayDisplay) then
      isHaveSet = true
    end
    zodType = self.data.zodDisplay
    birthdayStr = self.data.birthday
  end
  if isHaveSet then
    isInBirthday = DataCenter.BirthdayDataManager:CheckIsSameTime(self.data.birthday)
  end
  if isHaveSet then
    if isInBirthday then
      local InBirthdayImgPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_shengrixitong_huizhang.png"
      self.birthdayIcon:SetActive(true)
      self.birthdayIcon:LoadSprite(InBirthdayImgPath)
      self:LoadLightsweepEffect()
    else
      self.birthdayIcon:SetActive(false)
    end
  else
    self.birthdayIcon:SetActive(false)
  end
end

function UILWPlayerDetailMiddle:RefreshTitleAndStatus(data)
  if table.IsNullOrEmpty(data.titleWall) then
    self.detailStatus:InitLike(data, self.firstShow)
    self.titleRoot:SetActive(false)
    self.detailStatus:SetActive(true)
    self.firstShow = false
    return
  end
  self.titleContent:Refresh(data.titleWall, self.data.uid, 0.25)
  self.detailStatusTitle:InitLike(data, self.firstShow)
  self.titleRoot:SetActive(true)
  self.detailStatus:SetActive(false)
  self.firstShow = false
end

function UILWPlayerDetailMiddle:RefreshBattleInfo(data)
  if data then
    self.battleInfoCom:RemoveComponents(UILWPlayerDetailBattleInfoItem)
    self.battleInfoItem:GameObjectRecycleAll()
    local battleInfoItem
    for i = 1, #BattleInfoConfig do
      battleInfoItem = self.battleInfoItem:GameObjectSpawn(self.battleInfoCom.transform)
      battleInfoItem.name = BattleInfoConfig[i].name .. i
      battleInfoItem:SetActive(true)
      battleInfoItem = self.battleInfoCom:AddComponent(UILWPlayerDetailBattleInfoItem, battleInfoItem.name)
      battleInfoItem:ReInit(data, BattleInfoConfig[i])
    end
  end
end

function UILWPlayerDetailMiddle:OnBirthdaySetDataSuccessMsg()
  self:ReInit(self.data)
end

local lightsweepEffectPath = "Assets/Main/Prefabs/UI/LWMainUI/Birthday/Eff_ui_lightsweep.prefab"

function UILWPlayerDetailMiddle:LoadLightsweepEffect()
  if self.lightsweepEffectReq == nil then
    self.lightsweepEffectReq = self:GameObjectInstantiateAsync(lightsweepEffectPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.birthdayIcon.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(0, 0, 0)
    end)
  end
end

function UILWPlayerDetailMiddle:UnloadLightsweepEffect()
  if self.lightsweepEffectReq ~= nil then
    self:GameObjectDestroy(self.lightsweepEffectReq)
    self.lightsweepEffectReq = nil
  end
end

return UILWPlayerDetailMiddle
