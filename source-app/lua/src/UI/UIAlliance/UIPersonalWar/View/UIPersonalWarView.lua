local UIPersonalWarning = require("UI.UIAlliance.UIAllianceWarMainTable.Component.UIPersonalWarning")
local UIPersonalWarPlayerItem = require("UI.UIAlliance.UIPersonalWar.Component.UIPersonalWarPlayerItem")
local UIPersonalWarView = BaseClass("UIPersonalWarView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local content_path = "ImgBg/ScrollView/Viewport/Content"
local return_btn_path = "UICommonPopUpTitle/panel"
local war_item_obj_path = "ImgBg/UIPersonalWarning"
local SoliderInfoBg = "ImgBg/SoliderInfoBg"
local soldierNum_txt_path = "ImgBg/Info_Rect/soldierNum_Txt"
local hero_content_path = "ImgBg/Info_Rect/HeroContent"
local solider_content_path = "ImgBg/Info_Rect/SoliderContent"

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:SetSelfData(self:GetUserData())
  self.title = self:AddComponent(UIText, txt_title_path)
  self.title:SetLocalText(141023)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickPanel()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickPanel()
  end)
  self.war_item_obj = self:AddComponent(UIPersonalWarning, war_item_obj_path)
  self.war_item_obj:SetData(self.ctrl:GetSelfData())
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

local function OnDestroy(self)
  self.title = nil
  self:SetAllCellDestroy()
  self.content = nil
  self.return_btn = nil
  self.close_btn = nil
  self.war_item_obj = nil
  self._soldierNum_txt = nil
  self.Center_heroContent = nil
  self.Center_soliderContent = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:OnRefresh()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnRefresh(self)
  self:SetAllCellDestroy()
  self.war_item_obj:RefreshData()
  self.war_item_obj:SetBtnSeeState(false)
  local info = self.war_item_obj:GetSelfData()
  if info then
    self.model = {}
    if info.isAlliance then
      local list = self.ctrl:GetPlayerIdList()
      if list ~= nil then
        for i = 1, table.length(list) do
          self.model[list[i]] = self:GameObjectInstantiateAsync(UIAssets.UIPersonalWarPlayerItem, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.content:AddComponent(UIPersonalWarPlayerItem, nameStr)
            cell:SetUuid(list[i])
            cell:RefreshData()
          end)
        end
      end
    else
      self.model[info.ownerFormationUuid] = self:GameObjectInstantiateAsync(UIAssets.UIPersonalWarPlayerItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.content:AddComponent(UIPersonalWarPlayerItem, nameStr)
        cell:ShowHeroAndSolider(info.data)
      end)
    end
  else
    self:OnDelete()
  end
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(UIPersonalWarPlayerItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function ClickBg(self)
end

local function ClickPanel(self)
  self:ClickBg()
  self.ctrl:OnCloseClick()
end

local function CloseMainTable(self)
  self.ctrl:CloseMainTable()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceWarUpdate, self.OnRefresh)
  self:AddUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnDelete)
  self:AddUIListener(EventId.MarchItemTargetMeUpdate, self.OnRefresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceWarUpdate, self.OnRefresh)
  self:RemoveUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnDelete)
  self:RemoveUIListener(EventId.MarchItemTargetMeUpdate, self.OnRefresh)
end

local function OnDelete(self, uuid)
  self.ctrl:OnCloseClick()
end

UIPersonalWarView.OnCreate = OnCreate
UIPersonalWarView.OnDestroy = OnDestroy
UIPersonalWarView.OnRefresh = OnRefresh
UIPersonalWarView.OnEnable = OnEnable
UIPersonalWarView.OnDisable = OnDisable
UIPersonalWarView.OnAddListener = OnAddListener
UIPersonalWarView.OnRemoveListener = OnRemoveListener
UIPersonalWarView.OnDelete = OnDelete
UIPersonalWarView.SetAllCellDestroy = SetAllCellDestroy
UIPersonalWarView.ClickBg = ClickBg
UIPersonalWarView.ClickPanel = ClickPanel
UIPersonalWarView.CloseMainTable = CloseMainTable
UIPersonalWarView.ShowHeroAndSolider = ShowHeroAndSolider
return UIPersonalWarView
