local Const = {}
Const.moveSpeed = 2
Const.animation = {
  Run = "runcarry",
  Idle = "idle",
  Walk = "walk",
  Walk2 = "walk2",
  Point = "point"
}
Const.VisitorType = {
  GEN_BY_TIME = 0,
  CYCLE_REWARD = 1,
  STAGE = 2,
  WORKER_LOTTERY = 4,
  OPEN_PANEL = 7,
  DOMINATOR = 5,
  ActivityVisitor = 11,
  AllianceInvite = 12,
  AllianceCongratulation = 6,
  SURVIVOR_PACK_GiFT = 19,
  S0_ALLIANCE_BOSS = 18,
  ProtectCoverVisitor = 20
}
Const.VisitorQueueType = {Queue1 = 1, Queue2 = 2}
Const.VisitorTypeToQueue = {
  [Const.VisitorType.GEN_BY_TIME] = Const.VisitorQueueType.Queue1,
  [Const.VisitorType.CYCLE_REWARD] = Const.VisitorQueueType.Queue1,
  [Const.VisitorType.STAGE] = Const.VisitorQueueType.Queue2,
  [Const.VisitorType.WORKER_LOTTERY] = Const.VisitorQueueType.Queue2,
  [Const.VisitorType.OPEN_PANEL] = Const.VisitorQueueType.Queue2,
  [Const.VisitorType.ActivityVisitor] = Const.VisitorQueueType.Queue2,
  [Const.VisitorType.DOMINATOR] = Const.VisitorQueueType.Queue1,
  [Const.VisitorType.AllianceInvite] = Const.VisitorQueueType.Queue1,
  [Const.VisitorType.AllianceCongratulation] = Const.VisitorQueueType.Queue1,
  [Const.VisitorType.SURVIVOR_PACK_GiFT] = Const.VisitorQueueType.Queue2,
  [Const.VisitorType.AllianceCongratulation] = Const.VisitorQueueType.Queue1,
  [Const.VisitorType.S0_ALLIANCE_BOSS] = Const.VisitorQueueType.Queue1,
  [Const.VisitorType.ProtectCoverVisitor] = Const.VisitorQueueType.Queue1
}
Const.showEmojiTime = 5
Const.triggerQueryImgPath = "Assets/Main/Sprites/UI/UICityVisitor/cfm_zhujiemian_fangke_qipao_2"
Const.triggerSmilingImgPath = "Assets/Main/Sprites/UI/UICityVisitor/cfm_zhujiemian_fangke_qipao_3"
Const.queueDistance = 2
Const.desMaxWidth = 360
Const.uiLotteryId = "221541"
return Const
