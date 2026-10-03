local base = UIAsyncContainer
local UIBubbleTipS0AllianceBossItem = BaseClass("UIBubbleTipS0AllianceBossItem", UIAsyncContainer)

function UIBubbleTipS0AllianceBossItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIBubbleTipS0AllianceBossItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBubbleTipS0AllianceBossItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBossShow = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textBattleTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textBossInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnBubble = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnBubble:SetOnClick(function()
    self:OnBtnBubbleClick()
  end)
end

function UIBubbleTipS0AllianceBossItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBossShow = nil
  self.textBattleTip = nil
  self.textBossInfo = nil
  self.btnBubble = nil
end

function UIBubbleTipS0AllianceBossItem:OnEnable()
  base.OnEnable(self)
end

function UIBubbleTipS0AllianceBossItem:OnDisable()
  base.OnDisable(self)
end

function UIBubbleTipS0AllianceBossItem:DataDefine()
end

function UIBubbleTipS0AllianceBossItem:DataDestroy()
end

function UIBubbleTipS0AllianceBossItem:InitView()
  local mgr = DataCenter.S0AllianceBossDataManager
  local endTime
  if mgr.actStatus == AllianceBossS0ActStatus.InCombat then
    if mgr.bossData then
      local difficulty = mgr.bossData.difficultyLevel
      endTime = mgr.bossData.battleEndTime
      local bossIds = DataCenter.AllianceBossS0TemplateManager:GetBossDifficultyIds()
      if bossIds then
        local bossId = bossIds[difficulty]
        if bossId then
          local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(bossId)
          if bossTemp then
            local monsterId = bossTemp.monsterId
            if monsterId then
              local monsterTemp = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
              if monsterTemp then
                self.imgBossShow:LoadSpriteAuto(monsterTemp:GetSmallIcon())
              end
            end
          end
        end
      end
    end
    self.textBattleTip:SetLocalText("s0_alliance_boss_event_open")
  end
  self.endTime = endTime
end

function UIBubbleTipS0AllianceBossItem:OnBtnBubbleClick()
  if self.pointId == nil then
    local bossData = DataCenter.S0AllianceBossDataManager.bossData
    if bossData then
      self.pointId = bossData.bossPointId
      self.serverId = bossData.bossServerId
    end
  end
  if self.pointId then
    DataCenter.S0AllianceBossDataManager:GotoWorldPointOpen(self.pointId, self.serverId)
  end
  DataCenter.S0AllianceBossDataManager:SetBattleBubbleHide()
end

return UIBubbleTipS0AllianceBossItem
