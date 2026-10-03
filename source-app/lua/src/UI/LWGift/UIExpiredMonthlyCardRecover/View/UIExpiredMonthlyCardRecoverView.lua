local UIExpiredMonthlyCardRecoverView = BaseClass("UIExpiredMonthlyCardRecoverView", UIBaseView)
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIExpiredMonthlyCardRecoverView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIExpiredMonthlyCardRecoverView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIExpiredMonthlyCardRecoverView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textDescTop = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textDescBottom = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textOrder = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTxtChooseSkillChipSet = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compHeroContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.textBtnCancelName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textBtnRecoverName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnCancel = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnCancel:SetOnClick(function()
    self:OnBtnCancelClick()
  end)
  self.btnRecover = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnRecover:SetOnClick(function()
    self:OnBtnRecoverClick()
  end)
  self.compUIHeroCellSmall = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compLockIcon = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.compSkillChipIcon = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
end

function UIExpiredMonthlyCardRecoverView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textDescTop = nil
  self.textDescBottom = nil
  self.textOrder = nil
  self.textName = nil
  self.textTxtChooseSkillChipSet = nil
  self.compHeroContent = nil
  self.textBtnCancelName = nil
  self.textBtnRecoverName = nil
  self.btnCancel = nil
  self.btnRecover = nil
  self.compUIHeroCellSmall = nil
  self.btnPanel = nil
  self.compLockIcon = nil
  self.compSkillChipIcon = nil
end

function UIExpiredMonthlyCardRecoverView:DataDefine()
  self.formationData_No4 = self:GetUserData()
  self.compUIHeroCellSmall.gameObject:GameObjectCreatePool()
  self.heroCells = {}
end

function UIExpiredMonthlyCardRecoverView:DataDestroy()
  self.formationData_No4 = nil
  self.compUIHeroCellSmall.gameObject:GameObjectRecycleAll()
  self.compHeroContent:RemoveComponents(UIHeroCell)
  self.heroCells = {}
end

function UIExpiredMonthlyCardRecoverView:OnAddListener()
  base.OnAddListener(self)
end

function UIExpiredMonthlyCardRecoverView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIExpiredMonthlyCardRecoverView:RefreshView()
  self.textTitle:SetLocalText("weekcard_squad_save_title_1")
  self.textDescTop:SetLocalText("weekcard_squad_save_desc_1")
  self.textDescBottom:SetLocalText("weekcard_squad_save_desc_2")
  self.textBtnCancelName:SetLocalText("weekcard_squad_save_button_1")
  self.textBtnRecoverName:SetLocalText("weekcard_squad_save_button_2")
  self.textOrder:SetText("4")
  self.textName:SetLocalText("800354")
  self:RefreshTWSkillChipBtn()
  self:RefreshHeroList()
end

function UIExpiredMonthlyCardRecoverView:RefreshTWSkillChipBtn()
  local functionUnlock = DataCenter.TWSkillChipManager:IsFunctionUnlock()
  if functionUnlock then
    local localChipSetId = self.formationData_No4.chipIndex or 0
    local setUnlock = DataCenter.TacticalChipManager:IsPlanUnlock(self.formationData_No4.chipIndex)
    local isShowChipIcon = setUnlock and 0 < localChipSetId
    self.compSkillChipIcon:SetActive(isShowChipIcon)
    self.compLockIcon:SetActive(not isShowChipIcon)
    if localChipSetId and 0 < localChipSetId then
      self.textTxtChooseSkillChipSet:SetLocalText("800323", localChipSetId)
    else
      self.textTxtChooseSkillChipSet:SetText("")
    end
  end
end

function UIExpiredMonthlyCardRecoverView:RefreshHeroList()
  local prefab = self.compUIHeroCellSmall.gameObject
  if table.count(self.heroCells) > 0 then
    for k, v in pairs(self.heroCells) do
      prefab.GameObjectRecycle(v.gameObject)
    end
    self.compHeroContent:RemoveComponents(UIHeroCell)
    self.heroCells = {}
  end
  local heroes = {}
  for k, v in pairs(self.formationData_No4.heroPosition or {}) do
    heroes[tonumber(k)] = v
  end
  local dominatorUuid = heroes[6]
  if dominatorUuid and 0 < dominatorUuid then
    local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
    if dominatorInfo then
      local item = prefab:GameObjectSpawn(self.compHeroContent.transform)
      item.name = "item6"
      local obj = self.compHeroContent:AddComponent(UIHeroCell, item.name)
      obj:SetActive(true)
      obj:InitWithConfigId(dominatorInfo.dominatorId, nil, nil, dominatorInfo:GetCurRankLv())
      self.heroCells[6] = obj
    end
  end
  for i = 1, 5 do
    local item = prefab:GameObjectSpawn(self.compHeroContent.transform)
    item.name = "item" .. i
    local obj = self.compHeroContent:AddComponent(UIHeroCell, item.name)
    obj:SetActive(true)
    obj:SetData(heroes[i])
    self.heroCells[i] = obj
  end
end

function UIExpiredMonthlyCardRecoverView:OnBtnCloseClick()
  self.ctrl.CloseSelf()
end

function UIExpiredMonthlyCardRecoverView:OnBtnPanelClick()
  self.ctrl.CloseSelf()
end

function UIExpiredMonthlyCardRecoverView:OnBtnCancelClick()
  SFSNetwork.SendMessage(MsgDefines.AbandonFormationBackups, 4)
end

function UIExpiredMonthlyCardRecoverView:OnBtnRecoverClick()
  SFSNetwork.SendMessage(MsgDefines.RecoverFormationBackups, 4)
end

return UIExpiredMonthlyCardRecoverView
