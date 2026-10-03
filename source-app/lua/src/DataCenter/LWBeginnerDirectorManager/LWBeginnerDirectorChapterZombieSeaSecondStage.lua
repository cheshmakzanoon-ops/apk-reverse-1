local base = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterBase")
local LWBeginnerDirectorChapterZombieSeaSecondStage = BaseClass("LWBeginnerDirectorChapterZombieSeaSecondStage", base)
local actModelPath = "Assets/Main/Prefabs/LWCityEvent/ActorHero/SoliderActor1.prefab"
local actFireVfxPath = "Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_hero_AK_qiangkou_new.prefab"
local actMuzzlePath = "Model/GameObject/A_Hero_bubing02_SJ/Hero@bubing02_skin/To_unity/DeformationSystem/Root/gun"

function LWBeginnerDirectorChapterZombieSeaSecondStage:__init()
  self.directorScript = {
    {
      Id = 1,
      PointType = BeginnerScriptPointType.GuideFLow,
      Params = {6013},
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {12}
      }
    },
    {
      Id = 2,
      PointType = BeginnerScriptPointType.SpawnCityActorHero,
      Params = {
        {
          actModelPath,
          {69, 39},
          {36, 20},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 22},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 24},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 26},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 28},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 30},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 52},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {69, 39},
          {36, 54},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {67, 38},
          {36, 44},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {65, 42},
          {36, 46},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {65, 42},
          {36, 48},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        },
        {
          actModelPath,
          {67, 40},
          {36, 50},
          1,
          actFireVfxPath,
          actMuzzlePath,
          0.13
        }
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {1},
        [BeginnerScriptPointTriggerType.Time] = {3}
      }
    },
    {
      Id = 3,
      PointType = BeginnerScriptPointType.GuideFLow,
      Params = {6004},
      Conditions = {
        [BeginnerScriptPointTriggerType.TaskAllReceived] = {1}
      }
    },
    {
      Id = 4,
      PointType = BeginnerScriptPointType.GuideFLow,
      Params = {6005},
      Conditions = {
        [BeginnerScriptPointTriggerType.TaskAllReceived] = {0},
        [BeginnerScriptPointTriggerType.OverTime] = {1}
      }
    },
    {
      Id = 5,
      PointType = BeginnerScriptPointType.SpawnArmyNPC,
      Params = {},
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {1},
        [BeginnerScriptPointTriggerType.Time] = {1}
      }
    },
    {
      Id = 6,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 6},
          {row = 13, col = 10},
          {row = 15, col = 13}
        },
        {1, 4},
        {3, 6},
        0
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    },
    {
      Id = 7,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 20},
          {row = 13, col = 24},
          {row = 15, col = 30}
        },
        {1, 4},
        {3, 6},
        0
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    },
    {
      Id = 8,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 36},
          {row = 13, col = 40}
        },
        {1, 4},
        {3, 6},
        0
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    },
    {
      Id = 9,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 36},
          {row = 13, col = 40}
        },
        {5, 15},
        {1, 1},
        100,
        25
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    },
    {
      Id = 10,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 61},
          {row = 13, col = 50}
        },
        {5, 15},
        {1, 1},
        100,
        25
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    },
    {
      Id = 11,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 61},
          {row = 13, col = 66},
          {row = 15, col = 69}
        },
        {5, 15},
        {1, 1},
        100,
        25
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    },
    {
      Id = 12,
      PointType = BeginnerScriptPointType.SetCityPointVisible,
      Params = {
        {3251, false}
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    },
    {
      Id = 13,
      PointType = BeginnerScriptPointType.SetCityPointVisible,
      Params = {
        {3251, true}
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {1}
      }
    },
    {
      Id = 14,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 45},
          {row = 13, col = 50},
          {row = 15, col = 54}
        },
        {2, 4},
        {3, 6},
        0
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    },
    {
      Id = 15,
      PointType = BeginnerScriptPointType.SpawnCityZombie,
      Params = {
        {
          {row = 15, col = 61},
          {row = 13, col = 66},
          {row = 15, col = 69}
        },
        {2, 4},
        {3, 9},
        0
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    }
  }
  self.chapterName = "LWBeginnerDirectorChapterZombieSeaSecondStage"
end

function LWBeginnerDirectorChapterZombieSeaSecondStage:__delete()
  self.directorScript = nil
end

return LWBeginnerDirectorChapterZombieSeaSecondStage
