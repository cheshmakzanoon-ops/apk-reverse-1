local UIMysteryTreasureChestInfoView = BaseClass("UIMysteryTreasureChestInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIMysteryTreasureChestInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIMysteryTreasureChestInfoView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMysteryTreasureChestInfoView:ComponentDestroy()
  self.name_text = nil
  self.des_text = nil
  self.obstacleIcon_img = nil
  self.panelBtn_btn = nil
  self.AutoAdjustScreenPos = nil
  self.goBtnYellow = nil
  self.goBtnBlue = nil
  self:SetAllCellDestroy()
end

function UIMysteryTreasureChestInfoView:DataDestroy()
  self.data = nil
end

function UIMysteryTreasureChestInfoView:ComponentDefine()
  self.obstacleIcon_img = self:AddComponent(UIImage, "panel/GameObject/Image/icon/bossIcon")
  self.bg_2_img = self:AddComponent(UIImage, "panel/GameObject/Image/bg_2")
  self.name_text = self:AddComponent(UIText, "panel/GameObject/Image/bg_2/texts/name")
  self.des_text = self:AddComponent(UIText, "panel/GameObject/Image/bg_2/texts/des")
  self.panelBtn_btn = self:AddComponent(UIButton, "PanelBtn")
  self.scroll = self:AddComponent(UIScrollRect, "panel/GameObject/Image/bg_2/Scroll")
  self.content = self:AddComponent(UIBaseContainer, "panel/GameObject/Image/bg_2/Scroll/Viewport/Content")
  self.AutoAdjustScreenPos = self.transform:Find("panel/GameObject"):GetComponent(typeof(CS.AutoAdjustScreenPos))
  self.panelBtn_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.goBtnYellow = self:AddComponent(UIButton, "panel/GameObject/Image/go/ChallengeYellow")
  self.goBtnYellow:SetOnClick(function()
    self:OnGotoBattle()
  end)
  self.goBtnBlue = self:AddComponent(UIButton, "panel/GameObject/Image/go/ChallengeBlue")
  self.goBtnBlue:SetOnClick(function()
    self:OnUnlockBtnClick()
  end)
  self.lockIcon = self:AddComponent(UIBaseContainer, "panel/GameObject/Image/icon/bossIcon/lockIcon")
  self.lockIcon:SetActive(false)
  self.unlockTip = self:AddComponent(UITextMeshProUGUIEx, "panel/GameObject/Image/bg_2/unlockTip")
  self.unlockTip:SetActive(false)
  self.goBtnYellow:SetActive(true)
  self.goBtnBlue:SetActive(false)
  self.name_text:SetLocalText("newbies_fuben_title")
  self.des_text:SetLocalText("newbies_fuben_award_desc")
end

function UIMysteryTreasureChestInfoView:ReInit()
  local param = self:GetUserData()
  if type(param) == "table" then
    self.unlockData = param
    self:ShowUnlockState()
    return
  end
  self.uuid = param
  if self.uuid == nil then
    return
  end
  self.lockIcon:SetActive(false)
  self.goBtnBlue:SetActive(false)
  self.goBtnYellow:SetActive(true)
  self.unlockTip:SetActive(false)
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.uuid)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildingData.itemId)
  local worldPointPos = BuildingUtils.GetBuildModelCenterVec(buildingData.pointId, template.tileX, template.tileY)
  self.data = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(tonumber(buildingData.specialStageId))
  self.des_text:SetActive(true)
  self.AutoAdjustScreenPos:Init(worldPointPos)
  self.obstacleIcon_img:LoadSprite(self.data.image)
  self.obstacleIcon_img:SetNativeSize()
  self:InitReward()
end

function UIMysteryTreasureChestInfoView:InitReward()
  self:SetAllCellDestroy()
  local rewardStr = self.data.reward_show
  if string.IsNullOrEmpty(rewardStr) then
    self.bg_2_img:SetSizeDelta(Vector2(421, 150))
    self.scroll:SetActive(false)
    return
  end
  local rewardStrVec = string.split_ss_array(rewardStr, "|")
  local rewardList = {}
  table.walk(rewardStrVec, function(k, v)
    local str = v
    local item = DataCenter.RewardManager:ParseOneRewardStr(str)
    if item then
      table.insert(rewardList, item)
    end
  end)
  if 0 < #rewardList then
    self.bg_2_img:SetSizeDelta(Vector2(421, 250))
    self.scroll:SetActive(true)
    self:AddRewardToContainer(rewardList, self.content)
  else
    self.bg_2_img:SetSizeDelta(Vector2(421, 150))
    self.scroll:SetActive(false)
  end
end

function UIMysteryTreasureChestInfoView:SetAllCellDestroy()
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function UIMysteryTreasureChestInfoView:AddRewardToContainer(list, container)
  if list ~= nil and container then
    local num = 0
    for i = 1, table.length(list) do
      num = num + 1
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(0.7, 0.7, 0.7)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = container:AddComponent(UICommonResItem, nameStr)
        cell:ReInit(list[i], self.view.ctrl.type)
      end)
    end
  end
end

function UIMysteryTreasureChestInfoView:DataDefine()
  self.data = nil
end

function UIMysteryTreasureChestInfoView:OnGotoBattle()
  DataCenter.StageFeatureBuildingManager:OnEnterBattle(self.uuid)
end

function UIMysteryTreasureChestInfoView:OnUnlockBtnClick()
  GoToUtil.GotoCurrMonopolyCell(true)
  self.ctrl:CloseSelf()
end

function UIMysteryTreasureChestInfoView:ShowUnlockState()
  local featureBuildingId = self.unlockData.featureBuildingId
  local worldPos = self.unlockData.worldPos
  local needMonopolyId = self.unlockData.needMonopolyId
  self.data = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(featureBuildingId)
  if self.data then
    self.obstacleIcon_img:LoadSprite(self.data.image)
    self.obstacleIcon_img:SetNativeSize()
  end
  self.lockIcon:SetActive(true)
  self.des_text:SetActive(false)
  self.bg_2_img:SetSizeDelta(Vector2(421, 150))
  self.scroll:SetActive(false)
  self:SetAllCellDestroy()
  self.goBtnYellow:SetActive(false)
  self.goBtnBlue:SetActive(true)
  self.AutoAdjustScreenPos:Init(worldPos)
  self.unlockTip:SetActive(true)
  self.unlockTip:SetText(Localization:GetString("newbies_fuben_unlock_desc", needMonopolyId))
end

return UIMysteryTreasureChestInfoView
